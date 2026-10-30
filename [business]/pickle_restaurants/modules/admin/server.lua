-- =============================================
--  modules/admin | server.lua
--  Admin command + callbacks: create/delete restaurants, assign owner,
--  edit global settings & cookable recipes. All gated by IsPlayerAdmin.
-- =============================================

local function buildAdminData()
    local data = {
        restaurants = {},
        theme       = GetSetting("app_theme", nil), -- App-level: skins /restaurants itself
        phoneTheme  = GetSetting("phone_theme", nil), -- ONE global skin for the companion phone app
        settings    = SettingsCache,
        -- The EFFECTIVE buy-in costs (the `ingredient_costs` setting with each
        -- installed pack's defaults underneath it). `settings.ingredient_costs` is
        -- the AUTHORED map alone, so a panel seeded from that alone showed 0 for
        -- everything a pack prices — and saving that 0 back would have written a
        -- free toy over the pack's price. The editors display from this and write to
        -- the authored map, so only a cost someone actually typed is ever stored.
        ingredientCosts = IngredientCosts(),
        -- Each installed pack's DEFAULT prices on their own. The cost editor needs
        -- these separately from the effective map: it lists a row for every packaged
        -- item (so a pack's content is priceable at all) but only STORES a row that
        -- differs from the pack's default — otherwise merely touching that screen
        -- would author every default and freeze it against future pack updates.
        dlcCosts = DlcIngredientCosts and DlcIngredientCosts() or {},
        -- The three authored creation kinds, each flagged valid/missing + per-entry
        -- annotations (defaultPrice, tap, duplicate_input, *_installed). The NUI
        -- strips the annotations before saving the array back.
        foods       = AnnotateFoods(),
        tools       = AnnotateTools(),
        ingredients = AnnotateIngredients(),
        -- The shipped default menu, verbatim — feeds the NUI's "Import Defaults"
        -- dialog (restore a deleted default / reset an edited one, no restart).
        defaults    = { foods = DEFAULT_FOODS, tools = DEFAULT_TOOLS, ingredients = DEFAULT_INGREDIENTS },
        -- READ-ONLY, not a setting: the embedded takeout-box quad (core/shared.lua).
        -- The "Inside the box" cropper locks its frame to this aspect so a crop lands
        -- in the box exactly as it was dragged. Nothing in the panel writes it back.
        boxQuad     = Config.BoxQuad,
        -- Every job the framework knows, with its grade ladder — what the per-restaurant
        -- Job card picks from. `jobsAvailable` is false on a standalone server, where WE
        -- are the framework and the list is the `jobs` setting the admin authors himself;
        -- the panel says so instead of showing an empty picker that looks broken.
        jobs          = GetJobList(),
        jobsAvailable = JobsAvailable(),
        items       = BuildItemList(),     -- catalogue for item-pickers
        -- Kitchen products (cooked patty, raw_pizza, a frosted cake): authored here,
        -- never installed items. Component pickers offer these alongside `items` so
        -- every legitimate component is on a list — which is what lets those pickers
        -- stop accepting typed-in names that exist nowhere.
        products    = BuildProductList(),
        groups      = CollectGroups(),     -- every group name in use (UI suggestions)
        players     = {},
        -- Brand-texture aspects for the crop UI, from the ONE render-target registry
        -- (core/shared.lua) so the panel never hardcodes a resolution that drifts.
        renderTargets = BrandRenderTargets(),
        -- Installed DLC packs (modules/dlc), READ-ONLY: what each one is and what it
        -- contributes. Their entries also appear in the Menu tab's lists carrying a
        -- `dlc` mark, which is what renders them uneditable there — this is the
        -- inventory of packs, Settings → DLC.
        dlcs        = DlcList and DlcList() or {},
        -- Supplier depots, RAW (a part-placed bay is shown so it can be fixed) plus
        -- whether each bay is in use right now. Sent separately from `settings` because
        -- the Settings tab must not write this list back — the gizmo owns it.
        supplyDepots = SupplyAdminData and SupplyAdminData() or {},
        -- The baking containers the RECIPES declare, so the seat editor lists the trays
        -- that exist instead of asking anyone to type a model name — and knows how many
        -- seats each one owes (`slots` = the recipe's output_count; a cake tin holds 1,
        -- a cookie tray 6). Derived, never stored: add a container to a recipe and its
        -- card appears. Sent apart from `settings` because nothing here writes back.
        bakeContainers = BakeContainerList(),
    }
    for _, r in pairs(RestaurantCache) do
        local props = {}
        for _, p in pairs(PropCache) do
            if p.restaurant_id == r.id then props[#props + 1] = PropSummary(p) end
        end
        data.restaurants[#data.restaurants + 1] = {
            id           = r.id,
            name         = r.name,
            label        = r.label,
            owner        = r.owner_identifier,
            balance      = RestaurantBalance(r.id),
            hasCounter   = r.counter ~= nil,
            hasShell     = (r.metadata and r.metadata.shell) ~= nil,
            hasNpcSpawn  = (r.metadata and r.metadata.npc_spawn) ~= nil,
            groups       = r.groups or {},
            -- The job this restaurant employs through. A restaurant REQUIRES one —
            -- employment, permissions, commission and wages all hang off the grade a
            -- player holds — so an unassigned restaurant is reported as MISSING rather
            -- than merely empty, and the panel flags it in the list.
            job          = r.metadata and r.metadata.job or nil,
            jobLabel     = (r.metadata and r.metadata.job) and GetJobLabel(r.metadata.job) or nil,
            jobMissing   = ((r.metadata and r.metadata.job) == nil) or nil,
            -- Per-restaurant map blip override; nil = following the global
            -- Settings → Map Blip default (the panel shows that default's values).
            blip         = r.blip,
            props        = props,
            propCount    = #props,
            brand_image  = r.metadata and r.metadata.brand_image or nil,
            brand_images = r.metadata and r.metadata.brand_images or nil,
            phone_image  = r.metadata and r.metadata.phone_image or nil,
            theme        = r.metadata and r.metadata.theme or nil,
        }
    end
    for _, src in ipairs(GetPlayers()) do
        src = tonumber(src)
        data.players[#data.players + 1] = { id = src, name = GetPlayerCharacterName(src) }
    end
    return data
end

local function openAdmin(src)
    if not IsPlayerAdmin(src) then
        return ShowNotification(src, _L("no_permission"))
    end
    TriggerClientEvent("pickle_restaurants:openAdmin", src, buildAdminData())
end

lib.callback.register("pickle_restaurants:admin:getData", function(src)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local d = buildAdminData()
    d.ok = true
    return d
end)

CreateThread(function()
    while not RestaurantsReady do Wait(200) end
    RegisterCommand(GetSetting("admin_command", "restaurants"), function(src)
        if src == 0 then return print("This command must be run in-game.") end
        openAdmin(src)
    end, false)
end)

-- ─── create / delete ─────────────────────────────────────────────────────────

local function reloadRestaurant(id)
    local row = MySQL.single.await("SELECT * FROM pickle_restaurants WHERE id = ?", { id })
    if not row then RestaurantCache[id] = nil return end
    row.blip     = (type(row.blip) == "string") and json.decode(row.blip) or row.blip
    row.counter  = (type(row.counter) == "string") and json.decode(row.counter) or row.counter
    row.roles    = (type(row.roles) == "string") and json.decode(row.roles) or row.roles
    row.groups   = (type(row.groups) == "string") and json.decode(row.groups) or row.groups
    row.metadata = (type(row.metadata) == "string") and json.decode(row.metadata) or (row.metadata or {})
    RestaurantCache[id] = row
end

lib.callback.register("pickle_restaurants:admin:create", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    if not d or not d.name or d.name == "" then return { ok = false, error = _L("admin_name_required") } end
    -- NO BLIP COLUMN: a new restaurant FOLLOWS the global `blip` setting (an empty
    -- column is what BuildClientRestaurant resolves against the setting). It used to
    -- be seeded with a COPY of the setting here, and since a per-restaurant override
    -- always wins, that made Settings → Map Blip permanently inert — saved, synced
    -- and shadowed on every restaurant that existed.
    -- NO BALANCE EITHER: a restaurant's money is its JOB's society account now (see
    -- "The balance is the job's society account"), and it has no job yet — assigning one
    -- is the next thing an admin does. `starting_balance` is therefore applied THEN, not
    -- here, and the dead column is left at its default.
    local id = MySQL.insert.await(
        "INSERT INTO pickle_restaurants (name, label) VALUES (?, ?)",
        { d.name, d.label or d.name })
    if not id then return { ok = false } end
    reloadRestaurant(id)
    SyncWorldSoon()
    return { ok = true, id = id }
end)

lib.callback.register("pickle_restaurants:admin:delete", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local id = tonumber(d.id); if not id then return { ok = false } end
    -- collect props so clients can despawn them
    local propIds = {}
    for pid, p in pairs(PropCache) do if p.restaurant_id == id then propIds[#propIds + 1] = pid end end

    -- REFUND EVERY IN-FLIGHT TICKET FIRST. Deleting a restaurant used to drop its
    -- open orders straight out of the DB, so anyone who had pre-paid at a kiosk,
    -- register or from the phone simply lost their money with no ticket left to
    -- cancel. Go through the ONE shared refund path (core/server.lua): it's
    -- idempotent (the `refunded` flag means a ticket a cashier is cancelling at the
    -- same moment can't be paid twice), refunds the account that was charged, and
    -- queues the payout for anyone offline. This MUST run before the DELETEs below
    -- — the balance/ledger reversal it does needs the rows to still exist, and the
    -- pending-refund rows it queues live in their own table, which survives.
    local refundedCount = 0
    for _, o in pairs(OrderCache[id] or {}) do
        if o.status == "open" then
            local ok = pcall(RefundOrder, id, o, _L("refund_reason_closed"))
            if ok then refundedCount = refundedCount + 1
            else
                print(("[pickle_restaurants] REFUND FAILED deleting restaurant %s, ticket #%s (order %s)")
                    :format(tostring(id), tostring(o.ticket), tostring(o.id)))
            end
        end
    end
    if refundedCount > 0 then
        print(("[pickle_restaurants] refunded %d open ticket(s) while deleting restaurant %d"):format(refundedCount, id))
    end

    MySQL.update.await("DELETE FROM pickle_restaurants WHERE id = ?", { id })
    MySQL.update.await("DELETE FROM pickle_restaurant_props WHERE restaurant_id = ?", { id })
    MySQL.update.await("DELETE FROM pickle_restaurant_menu WHERE restaurant_id = ?", { id })
    MySQL.update.await("DELETE FROM pickle_restaurant_stock WHERE restaurant_id = ?", { id })
    MySQL.update.await("DELETE FROM pickle_restaurant_ledger WHERE restaurant_id = ?", { id })
    MySQL.update.await("DELETE FROM pickle_restaurant_orders WHERE restaurant_id = ?", { id })
    -- Payroll history and any UNPAID tips go with the restaurant. `pickle_restaurant_
    -- employees` is not touched: employment is the framework's job now, so that table
    -- is legacy and nothing reads or writes it. Job ASSIGNMENTS aren't per-restaurant
    -- either (a standalone player's job outlives one business), so they stay put.
    MySQL.update.await("DELETE FROM pickle_restaurant_payroll WHERE restaurant_id = ?", { id })
    MySQL.update.await("DELETE FROM pickle_restaurant_tips WHERE restaurant_id = ?", { id })
    RestaurantCache[id] = nil
    StockCache[id] = nil
    ClearOrders(id) -- drops OrderCache/NextTicket + bumps the rev so a stale register can't re-apply
    -- Audience resolved ONCE, and before the props start disappearing: the restaurant's
    -- extent is derived from them, so mid-loop it would shrink toward nothing and the last
    -- few removals would reach nobody. (RestaurantCache is already cleared above, so this
    -- reads PropCache — which is exactly why it has to happen before the loop.)
    local audience = PlayersNearRestaurant(id, ScopeRadius.PROP)
    for _, pid in ipairs(propIds) do
        PropCache[pid] = nil
        SendTo(audience, "pickle_restaurants:propRemoved", pid)
        -- release state other modules key on this prop (cooking items, seat
        -- occupancy, station claims) — same notice removeProp gives
        TriggerEvent("pickle_restaurants:propDeleted", pid)
    end
    SyncWorldSoon()
    return { ok = true }
end)

lib.callback.register("pickle_restaurants:admin:setOwner", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local id = tonumber(d.id); if not GetRestaurant(id) then return { ok = false } end
    local identifier = nil
    if d.target then
        identifier = GetIdentifier(tonumber(d.target))
        if not identifier then return { ok = false, error = _L("admin_player_not_found") } end
    end
    MySQL.update.await("UPDATE pickle_restaurants SET owner_identifier = ? WHERE id = ?", { identifier, id })
    RestaurantCache[id].owner_identifier = identifier
    return { ok = true, owner = identifier }
end)

-- ─── job assignment ──────────────────────────────────────────────────────────
-- The restaurant's JOB is the one thing that makes it employable: staff are whoever
-- holds it, permissions/commission/salary are per GRADE of it, and the boss panel's
-- Employees tab is the framework's roster for it. Assigning it is an ADMIN act —
-- it decides who has power over the business, so a boss can't hand it to himself.
--
-- Setting it SEEDS the per-rank config from the job's grade ladder (SetRestaurantJob,
-- core) so a freshly assigned job is immediately usable: boss grades hold everything,
-- the rest get `default_rank_permissions`. Clearing it (blank/absent `job`) leaves the
-- ranks behind on purpose — re-assigning the same job restores the pay the boss set.
lib.callback.register("pickle_restaurants:admin:setJob", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local id = tonumber(d and d.id); if not GetRestaurant(id) then return { ok = false } end
    local job = d.job and tostring(d.job) or nil
    if job == "" then job = nil end
    -- Validate against the real job list: a name the framework doesn't know would leave
    -- the restaurant with a job nobody can hold and no grade ladder to seed ranks from
    -- — i.e. permanently unstaffable, with nothing on screen to say why.
    if job then
        local known = false
        for _, j in ipairs(GetJobList() or {}) do
            if j.name == job then known = true break end
        end
        if not known then return { ok = false, error = _L("admin_unknown_job") } end
    end
    SetRestaurantJob(id, job) -- write-through + seeds ranks + ensures the account + syncs
    -- SEED FLOAT. `starting_balance` used to be written into our own `balance` column at
    -- creation; the money is the job's society account now, and a brand-new restaurant
    -- only gets an account when it gets a job — so this is where the float lands, and
    -- only when the account is genuinely empty (re-assigning a job must never top a
    -- working business back up).
    local seed = math.floor(tonumber(GetSetting("starting_balance", 0)) or 0)
    if job and seed > 0 and RestaurantBalance(id) <= 0 then
        if AdjustBalance(id, seed) then
            AddLedger(id, "deposit", seed, _L("ledger_starting_float"), GetIdentifier(src))
        end
    end
    ShowNotification(src, job and _L("admin_job_set", GetJobLabel(job)) or _L("admin_job_cleared"))
    return { ok = true, job = job, jobLabel = job and GetJobLabel(job) or nil }
end)

-- Recipe groups carried by a restaurant (what it may cook & sell). Groups are
-- free-form names; content with no group is available to every restaurant.
lib.callback.register("pickle_restaurants:admin:setGroups", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local id = tonumber(d.id); if not GetRestaurant(id) then return { ok = false } end
    local groups, seen = {}, {}
    for _, g in ipairs(type(d.groups) == "table" and d.groups or {}) do
        g = tostring(g):gsub("^%s+", ""):gsub("%s+$", "")
        if g ~= "" and not seen[g] then
            seen[g] = true
            groups[#groups + 1] = g
        end
    end
    MySQL.update.await("UPDATE pickle_restaurants SET `groups` = ? WHERE id = ?",
        { #groups > 0 and json.encode(groups) or nil, id })
    RestaurantCache[id].groups = #groups > 0 and groups or nil
    -- Groups decide what this restaurant may cook and sell, so the world is now
    -- stale: the synced payload is filtered per restaurant by group, and without
    -- this the menu boards, kiosk, register catalogue and cooking bar all keep
    -- offering the old set until something else happens to trigger a sync.
    SyncWorldSoon()
    ShowNotificationOnce(src, "settings_saved", _L("admin_settings_saved"))
    return { ok = true, groups = groups }
end)

-- Branding: same per-texture URL + crop config as the boss panel, but admin-gated so
-- a server admin can brand any restaurant. Shares SetRestaurantBrand (management).
lib.callback.register("pickle_restaurants:admin:setBrandImage", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local res = SetRestaurantBrand(tonumber(d.id), d.key, d.url, d.crop)
    if res and res.ok then ShowNotificationOnce(src, "branding_saved", _L("branding_saved")) end
    return res
end)

-- Custom per-item image: MERGE one item's { url, crop } into the global `item_images`
-- setting (a blank url clears it). Targeted so an edit in the Food & Drinks tab can't
-- clobber one made in the Ingredients tab. The override wins over the inventory image
-- in GetItemImage, so a re-sync pushes it to every world/board surface at once.
lib.callback.register("pickle_restaurants:admin:setItemImage", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    if not SetItemImageOverride(d.item, d.url, d.crop) then return { ok = false } end
    SyncWorldSoon()
    ShowNotificationOnce(src, "settings_saved", _L("admin_settings_saved"))
    return { ok = true }
end)

-- ─── map blip (per restaurant) ───────────────────────────────────────────────
-- The `blip` column is that restaurant's OWN map presence, and it is only ever
-- written HERE, by an admin deciding this restaurant differs. A new restaurant is
-- created with the column EMPTY (it used to be seeded with a copy of the global
-- setting, which shadowed that setting forever). Empty is "follow the server
-- default", never "no blip": BuildClientRestaurant falls through to the setting when
-- the column is empty, so an override can always be handed back — explicitly with
-- the panel's reset, or implicitly by ReleaseCopiedBlips when the default changes.
local function SanitizeBlip(b)
    if type(b) ~= "table" then return nil end
    local function num(v, d, lo, hi)
        v = tonumber(v); if not v then return d end
        if v < lo then return lo elseif v > hi then return hi end
        return v
    end
    return {
        enabled = b.enabled ~= false,
        sprite  = math.floor(num(b.sprite, 93, 1, 826)),  -- blip sprite id
        color   = math.floor(num(b.color, 1, 0, 85)),     -- blip colour index
        scale   = num(b.scale, 0.8, 0.1, 3.0),
    }
end

lib.callback.register("pickle_restaurants:admin:setBlip", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local id = tonumber(d and d.id); if not id then return { ok = false } end
    local r = GetRestaurant(id); if not r then return { ok = false, error = _L("mgmt_no_restaurant") } end
    local blip = SanitizeBlip(d.blip)
    -- Two statements, not one nil-able parameter: a nil in the middle of a Lua
    -- parameter table truncates the list, so the NULL case is its own query.
    if blip then
        MySQL.update.await("UPDATE pickle_restaurants SET blip = ? WHERE id = ?", { json.encode(blip), id })
    else
        MySQL.update.await("UPDATE pickle_restaurants SET blip = NULL WHERE id = ?", { id })
    end
    r.blip = blip -- write-through: the cache is what the sync payload reads
    SyncWorldSoon() -- the blip rides the restaurant sync payload
    ShowNotification(src, _L("blip_saved"))
    return { ok = true, blip = blip }
end)

-- Theme: same seed config as the boss panel, admin-gated. Shares
-- SetRestaurantTheme (management).
lib.callback.register("pickle_restaurants:admin:setTheme", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local res = SetRestaurantTheme(tonumber(d.id), d.theme)
    if res and res.ok then ShowNotification(src, _L("theme_saved")) end
    return res
end)

-- Rename: same identity write as the boss panel, admin-gated so a server admin can
-- rename any restaurant (the owner renames their own via management:setName).
-- Shares SetRestaurantName (management), which re-derives the internal codename
-- from the label exactly like admin:create does.
lib.callback.register("pickle_restaurants:admin:setName", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local res = SetRestaurantName(tonumber(d.id), d.label)
    if res and res.ok then ShowNotification(src, _L("mgmt_name_saved", res.label)) end
    return res
end)

-- App-level theme: skins the /restaurants admin panel itself, stored as the
-- `app_theme` setting (not per-restaurant). Client-render-only — no world sync.
lib.callback.register("pickle_restaurants:admin:setAppTheme", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    SetSetting("app_theme", SanitizeTheme(d.theme))
    ShowNotification(src, _L("theme_saved"))
    return { ok = true }
end)

-- Phone-app theme: ONE global skin for the companion phone app, stored as the
-- `phone_theme` setting (not per-restaurant — the phone keeps a single consistent look).
--
-- NO PUSH. This used to broadcast the theme to every player, and because the panel
-- auto-saves (there are no save buttons by design) that meant one send per connected player
-- per debounce tick — a colour picker drag was thousands of messages. It was also entirely
-- REDUNDANT: the phone's own bootstrap payload already carries `theme` (modules/phone's
-- getData), so every phone reads the current skin when it opens. The push existed only to
-- repaint phones that were already open mid-edit — and the admin doing the editing is
-- looking at the panel's own live preview, not at their phone.
--
-- Behaviour change, stated plainly: a phone already open when an admin restyles the app
-- keeps the old skin until it is next opened.
lib.callback.register("pickle_restaurants:admin:setPhoneTheme", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    local theme = SanitizeTheme(d.theme)
    SetSetting("phone_theme", theme)
    ShowNotification(src, _L("theme_saved"))
    return { ok = true }
end)

-- ─── settings ────────────────────────────────────────────────────────────────

-- The authored menu arrays (foods/tools/ingredients) are settings like any other,
-- but each is sanitized on the way in (the NUI is untrusted) and triggers a
-- derivation rebuild so the runtime caches (RecipeCache, derived assembly/drinks/
-- crafts/finishes/condiments/baking, prep models) reflect the edit immediately.
local MENU_SANITIZERS = {
    foods       = SanitizeFoods,
    tools       = SanitizeTools,
    ingredients = SanitizeIngredients,
    -- Custom per-item images (item → { url, crop }). Rebuild picks up the new
    -- ItemImageCache so a saved image propagates to every surface via GetItemImage.
    item_images = SanitizeItemImages,
    -- The eat/drink animation catalogue foods pick from (`consume.anim`): clips are
    -- handed straight to the client, so a malformed entry is dropped here.
    consume_anims = SanitizeConsumeAnims,
}

-- Keys that are sanitized on the way in but are NOT menu content, so writing one must
-- not drag `RebuildDerived()` (the recipe/assembly/prep-model derivation) along with it.
-- `jobs` is the standalone job ladder: with no framework installed that list IS the job
-- system, so a malformed entry doesn't merely look wrong — it decides who may work
-- somewhere.
local PLAIN_SANITIZERS = {
    jobs = function(v) return SanitizeJobs and SanitizeJobs(v) or v end,
    -- The bookable slot vocabulary. A slot id is what a hold's WINDOW is computed from,
    -- so junk here would create bookings that never start and never expire — the exact
    -- bug the reservation rewrite fixed on the way in from the phone. `"now"` always
    -- survives: it needs no clock, and an emptied list must still be bookable.
    reservation_slots = function(v)
        local out, seen = { "now" }, { now = true }
        for _, s in ipairs(type(v) == "table" and v or {}) do
            s = tostring(type(s) == "table" and (s.id or s.slot or "") or s):gsub("%s+", "")
            if s == "now" or s:match("^%d%d?:%d%d$") then
                -- normalise 9:00 → 09:00 so two spellings can't hold the same table twice
                if s ~= "now" then s = ("%02d:%02d"):format(tonumber(s:match("^(%d+)")), tonumber(s:match(":(%d+)$"))) end
                if not seen[s] then seen[s] = true; out[#out + 1] = s end
            end
        end
        return out
    end,
    -- BAKING TRAY WELLS: [container model] = { cols, spread_x, spread_y, offset_x,
    -- offset_y } in tray-local metres. These become world offsets on every client, so
    -- junk here doesn't misconfigure a feature, it scatters cookies across the kitchen —
    -- hence numbers coerced, NaN rejected (it propagates through the rotation into an
    -- entity coordinate) and everything clamped to a metre, already far larger than any
    -- tray. Clamping is also what stops `inf`.
    -- An entry with NO spread on either axis is dropped rather than stored: it would
    -- stack every serving on one point, and "no authored pitch, use the measured grid"
    -- is what a missing key already says.
    bake_slots = function(v)
        local out = {}
        local function num(x, lo, hi)
            x = tonumber(x)
            if not x or x ~= x then return 0.0 end -- x ~= x is NaN
            return math.max(math.min(x, hi), lo)
        end
        for model, c in pairs(type(v) == "table" and v or {}) do
            if type(model) == "string" and model ~= "" and type(c) == "table" then
                local e = { cols = math.floor(num(c.cols, 1, 12)),
                            spread_x = num(c.spread_x, -1.0, 1.0), spread_y = num(c.spread_y, -1.0, 1.0),
                            offset_x = num(c.offset_x, -1.0, 1.0), offset_y = num(c.offset_y, -1.0, 1.0) }
                if e.cols < 1 then e.cols = 1 end
                if e.spread_x ~= 0.0 or e.spread_y ~= 0.0 then out[model] = e end
            end
        end
        return out
    end,
    -- An enum, not free text: PayTips branches on it, and an unrecognised value would
    -- silently mean "even" anyway — better to store what actually happens.
    tip_split = function(v) return (tostring(v) == "grade") and "grade" or "even" end,
    -- SUPPLY RUNS. The Settings tab edits the SCALARS; the depot list is written only
    -- by the gizmo placement callbacks in modules/supply. So a settings write that
    -- carries no `depots` key keeps the ones already stored — without this, a debounced
    -- auto-save landing after a placement would delete the bay just placed, and the
    -- panel would look like the gizmo hadn't saved anything.
    supply_runs = function(v)
        if type(v) ~= "table" then return GetSetting("supply_runs", {}) end
        if v.depots == nil then
            local cur = GetSetting("supply_runs", {})
            v.depots = (type(cur) == "table" and cur.depots) or {}
        end
        return v
    end,
}

-- A global BLIP edit has to be visible on the restaurants that never made a choice.
-- Creation used to stamp a copy of the setting into every restaurant's own `blip`
-- column, and an override always wins — so the setting did nothing, on every
-- restaurant that already existed. Creation no longer copies (admin:create), and a
-- global edit hands back any column that still holds the OLD default verbatim: a
-- value that only ever got there by being copied from the setting was never a
-- decision. (A deliberate override that happens to equal the old default is
-- indistinguishable from a copy — and follows the setting from now on, which is
-- what it looked like anyway.) Restaurants with genuinely different numbers keep them,
-- and the panel's "Use server default" is still the explicit way back.
local function ReleaseCopiedBlips(prev)
    if type(prev) ~= "table" then return end
    local function same(a, b)
        return (a.enabled ~= false) == (b.enabled ~= false)
            and tonumber(a.sprite) == tonumber(b.sprite)
            and tonumber(a.color) == tonumber(b.color)
            and math.abs((tonumber(a.scale) or 0) - (tonumber(b.scale) or 0)) < 0.001
    end
    for id, r in pairs(RestaurantCache) do
        if type(r.blip) == "table" and same(r.blip, prev) then
            MySQL.update.await("UPDATE pickle_restaurants SET blip = NULL WHERE id = ?", { id })
            r.blip = nil -- write-through: the cache is what the sync payload reads
        end
    end
end

-- Apply a settings write, routing the three authored menu keys through their
-- sanitizer. Returns true if a menu key was written (caller rebuilds derived).
local function applySetting(key, value)
    -- read BEFORE the write: the release compares against the outgoing default
    local prevBlip = (key == "blip") and GetSetting("blip", nil) or nil
    local san = MENU_SANITIZERS[key]
    if san then SetSetting(key, san(value)); return true end
    local plain = PLAIN_SANITIZERS[key]
    SetSetting(key, plain and plain(value) or value)
    if key == "blip" then ReleaseCopiedBlips(prevBlip) end
    return false
end

lib.callback.register("pickle_restaurants:admin:saveSetting", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    if not d.key then return { ok = false } end
    if applySetting(d.key, d.value) then RebuildDerived() end
    SyncWorldSoon() -- foods/tools/blip may have changed
    ShowNotificationOnce(src, "settings_saved", _L("admin_settings_saved"))
    return { ok = true }
end)

-- Batch save (the debounced auto-save writes a whole settings group at once): one DB
-- write per key, ONE sync, ONE "saved" notification — so an auto-save of a multi-field
-- group doesn't spam a notification per field.
lib.callback.register("pickle_restaurants:admin:saveSettings", function(src, d)
    if not IsPlayerAdmin(src) then return { ok = false } end
    if type(d.settings) ~= "table" then return { ok = false } end
    local n, rebuild = 0, false
    for k, v in pairs(d.settings) do
        if applySetting(k, v) then rebuild = true end
        n = n + 1
    end
    if n == 0 then return { ok = false } end
    if rebuild then RebuildDerived() end
    SyncWorldSoon()
    ShowNotificationOnce(src, "settings_saved", _L("admin_settings_saved"))
    return { ok = true }
end)

-- ─── menu ────────────────────────────────────────────────────────────────────

-- Reset the whole authored menu (foods + tools + ingredients) to the shipped
-- defaults (Settings → General). Rebuilds derived caches + syncs.
lib.callback.register("pickle_restaurants:admin:resetRecipes", function(src)
    if not IsPlayerAdmin(src) then return { ok = false } end
    ResetMenuToDefault()
    SyncWorldSoon()
    ShowNotification(src, _L("admin_recipes_reset"))
    return { ok = true }
end)
