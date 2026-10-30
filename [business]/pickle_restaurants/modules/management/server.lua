-- =============================================
--  modules/management | server.lua
--  Employment (hire/fire/promote via the FRAMEWORK JOB), per-rank pay,
--  tips & payroll, finances (deposit/withdraw/ledger) and the
--  per-restaurant sellable menu.
-- =============================================

-- EMPLOYMENT IS THE FRAMEWORK'S JOB. There is no employee row any more: a
-- restaurant carries a job name (`metadata.job`, set by an admin) and everyone
-- holding that job works there, at the rank their grade names. So this file never
-- writes `pickle_restaurant_employees` — it moves players between job grades and
-- edits the per-RANK config (permissions, commission, salary) that every holder of
-- that grade shares.

-- The restaurant's job, as the panel needs to render it. nil = unassigned, which is
-- the one state that disables the whole Employees/Ranks side of the panel: a
-- restaurant REQUIRES a job to employ anyone.
local function jobBlock(rid)
    local name = RestaurantJob(rid)
    if not name then return nil end
    return { name = name, label = GetJobLabel(name), grades = GetJobGradeList(name) }
end

-- The NUI wants a stable ORDERED list. `RestaurantRanks` is keyed by grade NUMBER,
-- and a 0-based numeric map is exactly the shape json.encode can't be trusted to
-- hand over intact — so flatten it, sorted by grade (the same wire shape the retired
-- `roles` array had, plus salary/boss).
local function ranksArray(rid)
    local arr = {}
    for grade, cfg in pairs(RestaurantRanks(rid) or {}) do
        arr[#arr + 1] = {
            grade       = tonumber(grade) or 0,
            label       = cfg.label,
            permissions = cfg.permissions or {},
            commission  = tonumber(cfg.commission) or 0,
            salary      = tonumber(cfg.salary) or 0,
            boss        = cfg.boss or false,
        }
    end
    table.sort(arr, function(a, b) return a.grade < b.grade end)
    return arr
end

-- `RestaurantRoster` reads the FRAMEWORK's roster, which may answer asynchronously
-- (an ESX/QB player query). An ox_lib callback has to return a value, so block this
-- coroutine on the reply instead of handing the panel an empty list it would never
-- get a correction for. The callback always fires, so this can't hang.
local function rosterAwait(rid)
    local p = promise.new()
    RestaurantRoster(rid, function(list) p:resolve(list or {}) end)
    return Citizen.Await(p) or {}
end

-- Grades are validated against the JOB's real grade ladder, never against anything
-- we author: the framework owns the ladder, and a grade it doesn't define would put
-- a player in a rank nothing can resolve (no label, no pay). A job with no ladder at
-- all (a standalone job authored without grades) has grade 0 and nothing else.
-- Returns the clamped grade, or nil when the submitted one isn't real.
local function validGrade(jobName, grade)
    grade = math.floor(tonumber(grade) or 0)
    local grades = GetJobGradeList(jobName) or {}
    if #grades == 0 then return (grade == 0) and 0 or nil end
    for _, g in ipairs(grades) do
        if math.floor(tonumber(g.grade) or 0) == grade then return grade end
    end
    return nil
end

-- Employment mutators act on a PLAYER, not on a row: `SetPlayerJobGrade` needs a
-- source. The panel names someone either way — the nearby picker knows a server id,
-- the roster knows an identifier — so resolve both to a source here. An identifier
-- with nobody online behind it can't be moved (a framework only knows how to set a
-- LOADED player's job), and that is reported rather than silently succeeding.
-- Returns source|nil, identifier|nil.
local function resolveTarget(d)
    local sid = tonumber(d.serverId or d.target)
    if sid then
        local ident = GetIdentifier(sid)
        if ident then return sid, ident end
    end
    local ident = d.identifier and tostring(d.identifier) or nil
    if not ident or ident == "" then return nil, nil end
    for _, p in ipairs(GetPlayers()) do
        p = tonumber(p)
        if p and GetIdentifier(p) == ident then return p, ident end
    end
    return nil, ident
end

-- ─── open ────────────────────────────────────────────────────────────────────

lib.callback.register("pickle_restaurants:management:getData", function(src, d)
    local id = tonumber(d.id)
    local r = GetRestaurant(id); if not r then return { ok = false } end
    -- ResolvePerms' 2nd return is "holds every permission here": a server admin, the
    -- owner, or someone on a BOSS grade of the restaurant's job. That is what gates
    -- the pay-by-rank editor — setting what a grade earns is a boss's job, not a
    -- shift lead's.
    local perms, isBoss = ResolvePerms(id, src)
    if not perms then return { ok = false, error = _L("no_work_here") } end
    local effective = isBoss and ALL_PERMS or perms

    local ledger = {}
    if effective.view_finances then
        ledger = MySQL.query.await(
            "SELECT type, amount, description, identifier, created_at FROM pickle_restaurant_ledger WHERE restaurant_id = ? ORDER BY id DESC LIMIT 50",
            { id }) or {}
    end

    -- Payslip history (tips + salary runs), newest first and capped like the ledger.
    -- Visible to whoever can see the money OR runs the payroll — a manager who can pay
    -- wages but not read the ledger still has to see what was already paid, or they'd
    -- pay twice.
    local payroll = {}
    if effective.view_finances or effective.manage_payroll then
        payroll = MySQL.query.await(
            "SELECT identifier, name, grade, amount, kind, paid_at FROM pickle_restaurant_payroll WHERE restaurant_id = ? ORDER BY id DESC LIMIT 50",
            { id }) or {}
    end

    -- The POS price list: every sellable this restaurant can access (group-
    -- filtered), joined with its price row. Rows priced for something no longer
    -- in the catalog (item uninstalled / group removed) surface as `stale` so
    -- the owner can clean them up.
    local priceList, priced = BuildPricedCatalog(id, false)
    local stale = {}
    do
        local inCatalog = {}
        for _, e in ipairs(priceList) do inCatalog[e.key] = true end
        for key, p in pairs(priced) do
            if not inCatalog[key] then
                local item, variant = key:match("^(.-)::(.+)$")
                if not item then item, variant = key, "" end
                stale[#stale + 1] = { key = key, item = item, variant = variant,
                                      label = GetItemLabel(item) .. (variant ~= "" and (" (" .. variant .. ")") or ""),
                                      -- a stale entry still renders with its picture: it may
                                      -- have left the catalog but the item's art usually
                                      -- still resolves, and a label alone doesn't identify it
                                      image = GetItemImage(item),
                                      price = p.price }
            end
        end
        table.sort(stale, function(a, b) return a.key < b.key end)
    end

    local props = {}
    for _, p in pairs(PropCache) do
        if p.restaurant_id == id then props[#props + 1] = PropSummary(p) end
    end

    -- Supplies: the raw ingredients the restaurant can buy into its shared stock
    -- pool (the `ingredient_costs` map), each with its per-unit cost and the count
    -- currently in the larder. Cooking consumes from this pool.
    local supplies = {}
    if effective.manage_stock then
        -- Keys here are STOCK KEYS, not necessarily item names: a multi-faced
        -- ingredient is priced and stocked per face (`restaurant_toy:lardboy`), so
        -- the larder shows one row per toy at its own price. `item` stays the REAL
        -- item — it's what the deposit/withdraw buttons would move and what decides
        -- whether the row is installed at all.
        for key, cost in pairs(IngredientCosts()) do
            local item, vid = SplitStockKey(key)
            -- Buying is NOT group-gated (a restaurant may stock ahead of an admin
            -- granting the group), but the kitchen is: an ingredient that authors its
            -- own group and isn't carried here can be bought and never used. Say so on
            -- the row rather than letting the larder fill with things that silently
            -- never reach the prep bar. Only the ingredient's OWN authored group
            -- counts — `group` below is derived for display and gates nothing.
            local idef = IngredientDef(item)
            local lockedGroup = (idef and idef.group and not RestaurantHasAccess(id, idef.group))
                and idef.group or nil
            supplies[#supplies + 1] = {
                locked = lockedGroup and true or nil, lockedGroup = lockedGroup,
                key = key, item = item, variant = vid,
                label = StockKeyLabel(key), image = StockKeyImage(key),
                -- the heading the tab files this row under (the item's authored
                -- group, else derived from what consumes it). nil = Ungrouped.
                group = ItemGroup(item),
                cost = math.max(0, math.floor(tonumber(cost) or 0)),
                stock = GetStockCount(id, key), installed = ItemExists(item),
                -- how many the manager is personally carrying (offer to deposit).
                -- A FACE can't move between pocket and larder: the inventory item is
                -- generic, so a deposited toy has no face to name and a withdrawn one
                -- would launder a dear toy into a cheap one. Buying is per face;
                -- moving isn't offered for one.
                held = vid and 0 or (Inventory.GetItemCount(src, item) or 0),
                movable = (vid == nil) or nil,
                -- SUPPLY RUNS: what is already bought and still sitting at the depot.
                -- It counts against the cap, so the row has to show it or the tab is
                -- lying about how much more can be ordered.
                pending = (PendingSupplyUnits and PendingSupplyUnits(id, key) or 0),
            }
        end
        table.sort(supplies, function(a, b) return (a.label or a.item):lower() < (b.label or b.item):lower() end)
    end
    -- The Supplies tab's own header state: the per-item ceiling (0 = uncapped) and the
    -- runs waiting to be fetched. Both are 0/empty with the feature off, so the tab
    -- renders exactly as it always did.
    local supplyRuns = {
        enabled = SupplyRunsEnabled and SupplyRunsEnabled() or false,
        cap     = SupplyStockCap and SupplyStockCap() or 0,
        pending = (effective.manage_stock and PendingSupplyOrders) and PendingSupplyOrders(id) or {},
        -- Was this panel opened AT a depot counter? That is the only place the Supplies
        -- tab is a shop once runs are on. Verified server-side, never taken from the
        -- payload: `d.shop` is a request, standing there is the answer.
        shop    = (d and d.shop == true) and (SupplyShopNear and SupplyShopNear(src) or false) or false,
        -- What one load can hold, so the CART can enforce the same two ceilings this
        -- server does instead of letting someone build an order that can only be
        -- refused at checkout. `capacity` is total units per run, `boxUnits` is what
        -- turns that into a box count on screen.
        capacity  = (SupplyRunsEnabled and SupplyRunsEnabled() and SupplyRunCapacity) and SupplyRunCapacity() or 0,
        boxUnits  = (SupplyConfig and SupplyConfig().box_units) or 0,
    }

    -- ─── Dashboard ───────────────────────────────────────────────────────────
    -- The at-a-glance tab EVERY employee sees, permission-free: clocking in is not a
    -- management action, it's how you start your shift at the register. Shift state is
    -- read straight from the phone module's ShiftCache and mutated through the SAME
    -- clockIn/clockOut callbacks the phone uses, so the two surfaces can never drift.
    -- Everything else is a read-only summary assembled from caches we already hold;
    -- the money figures are gated on view_finances like the rest of the panel.
    -- Who works here, straight from the framework's job roster (never a table of
    -- ours) — so a hire made in another resource's boss menu shows up here, and
    -- nobody can be on our payroll without holding the job.
    local job     = jobBlock(id)
    local staff   = job and rosterAwait(id) or {}
    local dash
    do
        local myId = GetIdentifier(src)
        local shifts = ShiftCache and ShiftCache[id] or {}
        local mine = shifts[myId]
        local roster = {}
        for _, sh in pairs(shifts) do
            roster[#roster + 1] = { name = sh.name, tips = sh.tips or 0,
                                    since = sh.clock_in_ts, cooked = sh.cooked or 0 }
        end
        table.sort(roster, function(a, b) return (a.since or 0) < (b.since or 0) end)

        -- the register queue at a glance (the same open tickets the POS shows)
        local openCount, openValue = 0, 0
        for _, o in ipairs(GetOpenOrders(id) or {}) do
            openCount = openCount + 1
            openValue = openValue + (tonumber(o.total) or 0)
        end

        -- how many registers/kiosks this place actually has, so a dashboard opened at
        -- one says what else is out there
        local registers, kiosks, seats = 0, 0, 0
        for _, p in ipairs(props) do
            if p.prop_type == "counter" or p.prop_type == "virtual_register" then registers = registers + 1
            elseif p.prop_type == "kiosk" or p.prop_type == "kiosk_ground" then kiosks = kiosks + 1
            elseif p.prop_type == "seat" then seats = seats + 1 end
        end

        -- supplies already run dry (nothing left in the larder) — the one thing that
        -- silently stops a kitchen mid-service
        local out = {}
        for _, s in ipairs(supplies) do
            if s.installed and s.stock <= 0 then out[#out + 1] = { item = s.item, label = s.label, image = s.image } end
        end

        dash = {
            now        = os.time(),   -- server clock, so the NUI's timer never drifts on a stale page
            clockedIn  = mine ~= nil,
            since      = mine and mine.clock_in_ts or nil,
            tips       = mine and mine.tips or 0,
            cooked     = mine and mine.cooked or 0,
            roster     = roster,
            openOrders = openCount,
            openValue  = effective.view_finances and RoundMoney(openValue) or nil,
            employees  = #staff,   -- headcount on the JOB, not rows in a table of ours
            registers  = registers, kiosks = kiosks, seats = seats,
            menuSize   = #priceList,
            outOfStock = out,
        }
        if effective.view_finances then
            local row = MySQL.single.await(
                "SELECT COUNT(*) AS n, COALESCE(SUM(amount), 0) AS total FROM pickle_restaurant_ledger " ..
                "WHERE restaurant_id = ? AND type = 'sale' AND created_at >= CURDATE()", { id })
            dash.todaySales  = RoundMoney(tonumber(row and row.total) or 0)
            dash.todayOrders = tonumber(row and row.n) or 0
        end
    end

    return {
        ok        = true,
        dashboard = dash,
        restaurant = { id = r.id, label = r.label, name = r.name, balance = RestaurantBalance(r.id), owner = r.owner_identifier,
                       hasShell     = (r.metadata and r.metadata.shell) ~= nil,
                       hasNpcSpawn  = (r.metadata and r.metadata.npc_spawn) ~= nil,
                       brand_image  = r.metadata and r.metadata.brand_image or nil,
                       brand_images = r.metadata and r.metadata.brand_images or nil,
                       phone_image  = r.metadata and r.metadata.phone_image or nil,
                       theme        = r.metadata and r.metadata.theme or nil },
        theme     = r.metadata and r.metadata.theme or nil, -- App-level: skins the open panel
        perms     = effective,
        -- Holds-everything: owner, server admin, or a boss grade of the job. Gates the
        -- rename card in the Brand tab and the Ranks editor, neither of which is a
        -- staff permission (see management:setName / management:setRank). `isOwner` is
        -- kept as the same value under its old name so nothing that reads it breaks.
        isBoss    = isBoss or false,
        isOwner   = isBoss or false,
        -- The job this restaurant employs through. nil + jobMissing = an admin hasn't
        -- assigned one, which is the ONE state where nobody can be hired: the panel
        -- says so rather than offering a hire form that can only fail.
        job        = job,
        jobMissing = (job == nil) or nil,
        -- Every permission key there is, so the Ranks editor renders the real list
        -- instead of a copy that drifts when PERMISSIONS grows.
        permissions = PERMISSIONS,
        -- Pay by RANK: one config per grade, shared by everyone on it.
        ranks     = ranksArray(id),
        roster    = staff,
        -- Tips are STAFF money held in escrow (unpaid `pickle_restaurant_tips` rows),
        -- never house money — the balance never sees them. Paying them out is
        -- manage_payroll's job.
        tipPool   = TipPool(id),
        payroll   = payroll,
        ledger    = ledger,
        priceList = priceList,
        stale     = stale,
        supplies  = supplies,
        supplyRuns = supplyRuns,
        props     = props,
        nearby    = effective.manage_employees and NearbyPlayers(src, 10.0) or {},
        -- Brand-texture aspects for the crop UI, from the ONE render-target registry
        -- (core/shared.lua) so the panel never hardcodes a resolution that drifts.
        renderTargets = BrandRenderTargets(),
    }
end)

-- ─── employment (the framework job) ──────────────────────────────────────────
-- Hiring puts a player ON the restaurant's job; firing takes them off it. Nothing
-- is written to our own tables, which is the whole point: the job IS the employment
-- record, so a hire made here is visible to every other resource that reads jobs and
-- a job change made elsewhere needs no reconciliation on our side.
--
-- Every one of these needs the restaurant to HAVE a job. `management:setCommission`
-- is GONE — commission is a property of the rank now (management:setRank), so there
-- is nothing per-person left to set.

-- ─── hiring is an OFFER, never an assignment ─────────────────────────────────
-- A HIRE CHANGES THE TARGET'S JOB, and a job is the whole of what a character does
-- on the server. Hiring straight through `SetPlayerJobGrade` meant anyone with
-- `manage_employees` could pick a passer-by out of the `nearby` list and overwrite
-- their police/EMS/mayor job on the spot — and then "fire" them into unemployment.
-- That is a grief vector however well-permissioned the hirer is, because the
-- permission is over the RESTAURANT, not over the other player.
--
-- So a hire raises an OFFER the target answers, exactly like the seat request in
-- modules/seating: the callback reports only that the ask went out, and the job move
-- happens on the accept — re-validated there, because the world moves while a prompt
-- is up (the hirer may have lost the permission, the restaurant may have been given a
-- different job, the target may have been hired elsewhere in the meantime).
local HIRE_TTL = 30            -- seconds an offer stays answerable (TUNE IN-GAME)
local HireOffers = {}          -- [target src] = { rid, job, grade, from, expires }

local function offerLive(o) return o ~= nil and o.expires > os.time() end

-- One offer in flight per TARGET: a prompt is an interruption, so a restaurant can't
-- queue them up against someone who is ignoring them.
local function pruneOffers()
    local now = os.time()
    for tgt, o in pairs(HireOffers) do
        if o.expires <= now then HireOffers[tgt] = nil end
    end
end

AddEventHandler("playerDropped", function()
    HireOffers[source] = nil
end)

-- A grade's human name off the job's own ladder — what the offer prompt has to say,
-- since "grade 2" tells the person being asked nothing about the job they're taking.
local function gradeLabel(jobName, grade)
    for _, g in ipairs(GetJobGradeList(jobName) or {}) do
        if g.grade == grade then return g.label end
    end
    return _L("job_grade_n", grade)
end

lib.callback.register("pickle_restaurants:management:hire", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_employees") then return { ok = false, error = _L("no_permission") } end
    local r = GetRestaurant(id); if not r then return { ok = false, error = _L("mgmt_no_restaurant") } end
    local job = RestaurantJob(id)
    -- No job = literally nothing to hire into. An admin assigns one in /restaurants.
    if not job then return { ok = false, error = _L("mgmt_no_job") } end

    local target, identifier = resolveTarget(d)
    if not target then return { ok = false, error = _L("mgmt_player_not_found") } end
    if r.owner_identifier == identifier then return { ok = false, error = _L("mgmt_player_owns") } end
    local info = GetPlayerJobInfo(target)
    if info and info.name == job then return { ok = false, error = _L("mgmt_already_employed") } end

    local grade = validGrade(job, d.grade)
    if not grade then return { ok = false, error = _L("mgmt_bad_grade") } end
    -- Hiring straight onto a BOSS grade is an escalation: it hands over every
    -- permission at this restaurant, so only someone who already holds them all may
    -- do it. A shift lead with manage_employees hires staff, not bosses.
    if IsJobBossGrade(job, grade) then
        local _, isBoss = ResolvePerms(id, src)
        if not isBoss then return { ok = false, error = _L("mgmt_boss_grade_denied") } end
    end
    -- Everything above is the HIRER's side of the check and is re-run on the accept.
    -- Nothing has changed about the target yet: all this does is ask.
    pruneOffers()
    if offerLive(HireOffers[target]) then return { ok = false, error = _L("mgmt_offer_pending") } end
    HireOffers[target] = { rid = id, job = job, grade = grade, from = src, expires = os.time() + HIRE_TTL }

    -- BOTH channels, like the seat request: the phone notification is the record for
    -- someone who was driving, the prompt is what can actually be answered.
    if PhoneNotify then
        PhoneNotify(target, _L("mgmt_offer_notify_title"), _L("mgmt_offer_notify_body", r.label, gradeLabel(job, grade)))
    end
    TriggerClientEvent("pickle_restaurants:management:jobOffer", target, {
        restaurant = r.label,
        job        = GetJobLabel(job) or job,
        grade      = gradeLabel(job, grade),
        from       = GetPlayerCharacterName(src) or "",
        ttl        = HIRE_TTL,
    })
    ShowNotification(src, _L("mgmt_offer_sent", GetPlayerCharacterName(target) or ""))
    return { ok = true, pending = true, grade = grade, message = _L("mgmt_offer_sent", GetPlayerCharacterName(target) or "") }
end)

-- The TARGET's answer. A net event, not a callback: from their side the prompt is
-- fire-and-forget, and everything that follows is a push to the other player.
-- EVERY hire condition is re-checked here — this is the point the job actually moves,
-- so it is the point that has to be right, not the moment the offer was raised.
RegisterNetEvent("pickle_restaurants:management:answerJobOffer", function(d)
    local src = source
    pruneOffers()
    local o = HireOffers[src]
    if not offerLive(o) then return end
    HireOffers[src] = nil

    if not (d and d.accept) then
        if o.from then ShowNotification(o.from, _L("mgmt_offer_declined", GetPlayerCharacterName(src) or "")) end
        return
    end

    local r = GetRestaurant(o.rid)
    if not r then return end
    -- The hirer must STILL hold the permission, and the restaurant must still employ
    -- through the job that was offered: an offer is an intent, never a stored grant.
    if not (o.from and HasPerm(o.rid, o.from, "manage_employees")) then
        return ShowNotification(src, _L("mgmt_offer_expired"))
    end
    if RestaurantJob(o.rid) ~= o.job then
        return ShowNotification(src, _L("mgmt_offer_expired"))
    end
    local grade = validGrade(o.job, o.grade)
    if not grade then return ShowNotification(src, _L("mgmt_offer_expired")) end
    -- The boss-grade escalation guard, re-run for the same reason as the rest: a
    -- shift lead who was demoted while the prompt was up must not still be able to
    -- land someone on a grade that holds every permission here.
    if IsJobBossGrade(o.job, grade) then
        local _, isBoss = ResolvePerms(o.rid, o.from)
        if not isBoss then return ShowNotification(src, _L("mgmt_offer_expired")) end
    end
    if not SetPlayerJobGrade(src, o.job, grade) then
        return ShowNotification(src, _L("mgmt_hire_failed"))
    end

    ShowNotification(src, _L("mgmt_hired_at", r.label))
    ShowNotification(o.from, _L("mgmt_hired", GetPlayerCharacterName(src) or ""))
end)

lib.callback.register("pickle_restaurants:management:fire", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_employees") then return { ok = false, error = _L("no_permission") } end
    local r = GetRestaurant(id); if not r then return { ok = false, error = _L("mgmt_no_restaurant") } end
    local job = RestaurantJob(id)
    if not job then return { ok = false, error = _L("mgmt_no_job") } end

    local target, identifier = resolveTarget(d)
    -- Firing sets the framework's unemployed job, which only works on a loaded player.
    if not target then return { ok = false, error = _L("mgmt_player_offline") } end
    if r.owner_identifier == identifier then return { ok = false, error = _L("mgmt_player_owns") } end
    -- CHECK THE JOB, always: this callback can otherwise be pointed at any player in
    -- the server and would strip them of a job that has nothing to do with us.
    local info = GetPlayerJobInfo(target)
    if not info or info.name ~= job then return { ok = false, error = _L("mgmt_not_employed") } end
    -- A boss can only be dismissed by someone who is one.
    if info.isBoss or RankFor(id, info.grade).boss then
        local _, isBoss = ResolvePerms(id, src)
        if not isBoss then return { ok = false, error = _L("mgmt_boss_grade_denied") } end
    end

    if not SetPlayerJobGrade(target, nil, 0) then return { ok = false, error = _L("mgmt_fire_failed") } end
    ShowNotification(target, _L("mgmt_fired_from", r.label))
    ShowNotification(src, _L("mgmt_fired", GetPlayerCharacterName(target) or ""))
    return { ok = true }
end)

lib.callback.register("pickle_restaurants:management:setGrade", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_employees") then return { ok = false, error = _L("no_permission") } end
    local job = RestaurantJob(id)
    if not job then return { ok = false, error = _L("mgmt_no_job") } end

    local target = resolveTarget(d)
    if not target then return { ok = false, error = _L("mgmt_player_offline") } end
    local info = GetPlayerJobInfo(target)
    if not info or info.name ~= job then return { ok = false, error = _L("mgmt_not_employed") } end

    local grade = validGrade(job, d.grade)
    if not grade then return { ok = false, error = _L("mgmt_bad_grade") } end
    -- Same escalation guard as hiring, in BOTH directions: promoting someone into a
    -- boss grade, or demoting a boss out of one, is a boss-only act.
    if IsJobBossGrade(job, grade) or info.isBoss or RankFor(id, info.grade).boss then
        local _, isBoss = ResolvePerms(id, src)
        if not isBoss then return { ok = false, error = _L("mgmt_boss_grade_denied") } end
    end
    if not SetPlayerJobGrade(target, job, grade) then return { ok = false, error = _L("mgmt_grade_failed") } end

    ShowNotificationOnce(src, "role_saved", _L("mgmt_role_saved"))
    return { ok = true, grade = grade }
end)

-- ─── ranks (pay & permissions per grade) ─────────────────────────────────────
-- One config per grade of the restaurant's job, shared by everyone on it: what they
-- may do here, what cut of a sale they take, what they're paid per payroll run.
-- BOSS-ONLY on purpose — this is where the money is decided, and `manage_employees`
-- (which moves people between grades) must not also let someone write their own pay.
lib.callback.register("pickle_restaurants:management:setRank", function(src, d)
    local id = tonumber(d.id)
    local perms, isBoss = ResolvePerms(id, src)
    if not perms or not isBoss then return { ok = false, error = _L("no_permission") } end
    local job = RestaurantJob(id)
    if not job then return { ok = false, error = _L("mgmt_no_job") } end
    local grade = validGrade(job, d.grade)
    if not grade then return { ok = false, error = _L("mgmt_bad_grade") } end

    -- The NUI is untrusted: take only REAL permission keys (never whatever keys the
    -- payload happens to carry), a commission that is a percentage, and a whole-dollar
    -- salary. `label` and `boss` are deliberately NOT writable — the job owns the one
    -- and the framework's grade flag owns the other.
    local granted = {}
    local submitted = type(d.permissions) == "table" and d.permissions or {}
    for _, k in ipairs(PERMISSIONS) do
        if submitted[k] == true then granted[k] = true end
    end
    SetRestaurantRank(id, grade, {
        permissions = granted,
        commission  = math.max(0, math.min(100, math.floor(tonumber(d.commission) or 0))),
        salary      = math.max(0, math.floor(tonumber(d.salary) or 0)),
    })
    ShowNotificationOnce(src, "rank_saved", _L("mgmt_rank_saved"))
    return { ok = true, ranks = ranksArray(id) }
end)

-- ─── tips & payroll ──────────────────────────────────────────────────────────
-- Tips are staff money the restaurant merely HOLDS (unpaid rows, never the balance);
-- salaries come OUT of the balance. Both are one gate, `manage_payroll`, which a boss
-- holds implicitly through ALL_PERMS.

-- `PayTips`/`RunPayroll` (core) refuse with a KEY as their THIRD return, because the
-- engine has no business deciding how a panel words a refusal. This maps each one to
-- the boss-facing string; an unmapped key falls back to the generic failure rather
-- than printing a raw key at somebody.
local PAYOUT_ERRORS = {
    tips_none            = "mgmt_no_tips",
    tips_no_staff        = "mgmt_no_recipients",
    payroll_none         = "mgmt_payroll_nobody",
    payroll_insufficient = "payroll_insufficient",
    no_restaurant        = "mgmt_no_restaurant",
}

lib.callback.register("pickle_restaurants:management:payTips", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_payroll") then return { ok = false, error = _L("no_permission") } end
    if not GetRestaurant(id) then return { ok = false, error = _L("mgmt_no_restaurant") } end
    -- THREE returns: paid, the recipient ROWS, and a refusal key. `recipients` is a
    -- table (who got what), never a count — the count is #recipients.
    local paid, recipients, errKey = PayTips(id)
    -- Nothing owed, or nobody on shift to split it between: say WHICH rather than
    -- reporting a $0 payout as a success, and never collapse the two ("no tips" when
    -- the pool is full and the room is empty sends a boss looking for the wrong fault).
    if errKey then return { ok = false, error = _L(PAYOUT_ERRORS[errKey] or "mgmt_payroll_failed") } end
    local n = #(recipients or {})
    if not paid or paid <= 0 or n == 0 then return { ok = false, error = _L("mgmt_no_tips") } end
    ShowNotification(src, _L("mgmt_tips_paid", paid, n))
    return { ok = true, paid = paid, recipients = n, tipPool = TipPool(id) }
end)

lib.callback.register("pickle_restaurants:management:runPayroll", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_payroll") then return { ok = false, error = _L("no_permission") } end
    local r = GetRestaurant(id); if not r then return { ok = false, error = _L("mgmt_no_restaurant") } end
    -- A run is ATOMIC: a restaurant that can't cover the whole wage bill pays nobody,
    -- and comes back as (nil, <locale key>) rather than paying the first few names in
    -- the roster and leaving the rest short.
    local paid, recipients, errKey = RunPayroll(id)
    if errKey then return { ok = false, error = _L(PAYOUT_ERRORS[errKey] or "mgmt_payroll_failed") } end
    local n = #(recipients or {})
    if not paid or paid <= 0 or n == 0 then return { ok = false, error = _L("mgmt_payroll_nobody") } end
    ShowNotification(src, _L("mgmt_payroll_paid", paid, n))
    return { ok = true, paid = paid, recipients = n, balance = RestaurantBalance(id) }
end)

-- ─── price list (POS menu) ───────────────────────────────────────────────────
-- Prices are set per catalog entry (`key` = item, or item::flavor for drinks).
-- The key is resolved against the restaurant's live sellable catalog — a price
-- can never be written for something the restaurant can't actually make.

lib.callback.register("pickle_restaurants:management:saveMenuItem", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_menu") then return { ok = false, error = _L("no_permission") } end
    local entry
    for _, e in ipairs(BuildSellableCatalog(id)) do
        if e.key == d.key then entry = e break end
    end
    if not entry then return { ok = false, error = _L("mgmt_item_required") } end
    MySQL.update.await([[
        INSERT INTO pickle_restaurant_menu (restaurant_id, item, variant, label, price, category, enabled)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE label = VALUES(label), price = VALUES(price), category = VALUES(category), enabled = VALUES(enabled)
    ]], { id, entry.item, entry.variant or "", entry.label, math.max(0, math.floor(tonumber(d.price) or 0)),
          entry.kind, d.enabled and 1 or 0 })
    ShowNotificationOnce(src, "menu_saved", _L("mgmt_menu_saved"))
    SyncWorldSoon() -- refresh the customer-facing menu SCREEN board (modules/screens)
    return { ok = true }
end)

lib.callback.register("pickle_restaurants:management:deleteMenuItem", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_menu") then return { ok = false, error = _L("no_permission") } end
    local item, variant = tostring(d.key or ""):match("^(.-)::(.+)$")
    if not item then item, variant = tostring(d.key or ""), "" end
    MySQL.update.await("DELETE FROM pickle_restaurant_menu WHERE restaurant_id = ? AND item = ? AND variant = ?",
        { id, item, variant })
    ShowNotification(src, _L("mgmt_menu_removed"))
    SyncWorldSoon() -- refresh the customer-facing menu SCREEN board (modules/screens)
    return { ok = true }
end)

-- ─── supplies (shared stock pool) ────────────────────────────────────────────
-- Buy raw ingredients into the restaurant's shared stock pool, paid out of the
-- restaurant balance at the configured ingredient cost. Cooking consumes from
-- this pool, so a restaurant must keep it stocked to keep the kitchen running.

-- A PURCHASE IS A CART, and there is ONE function that makes one. The panel and the
-- depot counter both build a basket and pick a payment method; the old one-line
-- `buyStock` (still used by the phone) is that same call with a single line. Two
-- purchase paths would be two sets of rules to keep in step: the cap, the run capacity,
-- the shop gate and the ledger all live here once.
--
-- PAYMENT is either the business account ("society", how it always worked) or the
-- buyer's own CASH. Cash matters because a restaurant with an empty account can still
-- be restocked out of a manager's pocket, and because the depot counter is a shop like
-- any other. Either way the money leaves BEFORE the stock is granted.
local function BuySupplies(src, id, lines, payment)
    if not HasPerm(id, src, "manage_stock") then return { ok = false, error = _L("no_permission") } end
    local r = GetRestaurant(id); if not r then return { ok = false } end
    if type(lines) ~= "table" or #lines == 0 then return { ok = false, error = _L("mgmt_cart_empty") } end

    local runs = SupplyRunsEnabled and SupplyRunsEnabled() or false
    -- WITH RUNS ON, NEITHER PANEL IS A SHOP. Supplies are ordered at a depot counter, so
    -- the purchase is gated on standing at one. Hiding the buy controls is only the
    -- polite half: the NUI is untrusted, and without this a saved panel or a forged post
    -- would still buy from the other side of the map.
    local depot = runs and SupplyShopNear and SupplyShopNear(src) or nil
    if runs and not depot then return { ok = false, error = _L("supply_not_at_shop") } end
    -- ORDERING IS THE CLAIM: the boxes hit the floor of this depot as soon as it is paid
    -- for. So everything that could stop a run is asked BEFORE the money moves (already
    -- running, an order still outstanding, every bay busy) rather than after, when a
    -- refusal would mean handing payment back.
    if runs and CanBeginSupplyRun then
        local ok, why = CanBeginSupplyRun(src, depot)
        if not ok then return { ok = false, error = _L(why) } end
    end

    -- Validate and price the WHOLE cart before any money moves. A cart that fails
    -- half-way through would leave a restaurant paying for part of an order it never
    -- asked for.
    local costs = IngredientCosts()
    local cap = SupplyStockCap and SupplyStockCap() or 0
    local clean, total, units = {}, 0, 0
    local seen = {}
    for _, l in ipairs(lines) do
        local key = tostring(l.key or l.item or "")
        if costs[key] == nil then return { ok = false, error = _L("mgmt_item_required") } end
        -- One line per key: a duplicated key would be capped twice against its own
        -- earlier line and priced as if the two were unrelated.
        if seen[key] then return { ok = false, error = _L("mgmt_item_required") } end
        seen[key] = true
        local qty = math.max(1, math.min(1000, math.floor(tonumber(l.qty) or 0)))
        -- THE LARDER HAS A CEILING, and units already bought-but-uncollected count
        -- against it, or ordering twice in a row walks straight past a cap that only
        -- looked at what had actually arrived.
        if cap > 0 then
            local have = GetStockCount(id, key) + (PendingSupplyUnits and PendingSupplyUnits(id, key) or 0)
            if have + qty > cap then
                return { ok = false, error = _L("mgmt_stock_capped", cap, math.max(0, cap - have)) }
            end
        end
        clean[#clean + 1] = { key = key, qty = qty }
        total = total + math.max(0, math.floor(tonumber(costs[key]) or 0)) * qty
        units = units + qty
    end
    -- An order bigger than one rig can haul is refused AT THE TILL rather than quietly
    -- becoming fewer boxes than were paid for: the pile is the picture of the order.
    if runs and units > SupplyRunCapacity() then
        return { ok = false, error = _L("mgmt_stock_load_too_big", SupplyRunCapacity()) }
    end

    local cash = (payment == "cash")
    local ident = GetIdentifier(src)
    if total > 0 then
        if cash then
            if GetMoney(src, "money") < total then return { ok = false, error = _L("not_enough_cash") } end
            RemoveMoney(src, total, "money")
            -- Amount 0: the BUSINESS didn't pay, so this must not read as a business
            -- expense in its books. It is still logged, because who restocked out of
            -- their own pocket is exactly the sort of thing a boss asks about later.
            AddLedger(id, "supply", 0, _L("ledger_restock_cash", units, total), ident)
        else
            -- The balance is a society account the whole server shares, so it can move
            -- between a read and a write. THE DEBIT IS THE AUTHORITY: trusting a
            -- pre-read would hand out free ingredients whenever it failed (funds gone,
            -- account missing, banking resource down).
            if RestaurantBalance(id) < total then return { ok = false, error = _L("mgmt_insufficient_funds") } end
            if not AdjustBalance(id, -total) then
                return { ok = false, error = _L("mgmt_insufficient_funds") }
            end
            AddLedger(id, "supply", -total, _L("ledger_restock_cart", units), ident)
        end
    end

    -- The money is gone either way, which is what makes a queued run the RESTAURANT's
    -- cargo rather than the buyer's: anyone who could have ordered it can go and fetch
    -- it, and an abandoned run is never lost.
    if runs then
        local orderId, boxes = CreateSupplyOrder(id, ident, clean, units)
        -- The run starts HERE, not at a bay: the pile appears the moment the order is
        -- paid for, at the depot it was paid at. A depot that filled up between the check
        -- above and this line leaves the order pending and re-claimable, which is the
        -- same state an abandoned run is in.
        local started
        if orderId and boxes then
            local order = { id = orderId, restaurant_id = id, boxes = boxes }
            started = BeginSupplyRun and BeginSupplyRun(src, depot, order)
        end
        if not boxes then
            -- Nothing was ordered, so nothing should have been paid. Refund whichever
            -- pocket it came out of rather than leaving a purchase with no cargo.
            if total > 0 then
                if cash then AddMoney(src, total, "money") else AdjustBalance(id, total) end
            end
            return { ok = false, error = _L("mgmt_stock_order_failed") }
        end
        ShowNotification(src, _L(started and "mgmt_cart_loading" or "mgmt_cart_ordered", units, boxes))
        return { ok = true, pending = true, boxes = boxes, balance = RestaurantBalance(id) }
    end
    for _, l in ipairs(clean) do AddStock(id, l.key, l.qty) end
    ShowNotification(src, _L("mgmt_cart_bought", units))
    return { ok = true, balance = RestaurantBalance(id) }
end

-- The cart, from the panel or the depot counter.
lib.callback.register("pickle_restaurants:management:buySupplies", function(src, d)
    return BuySupplies(src, tonumber(d.id), d.lines, d.payment)
end)

-- ONE LINE, society funds: what the phone's Stock screen has always sent. Kept as a
-- thin wrapper so there is still only one set of purchase rules.
lib.callback.register("pickle_restaurants:management:buyStock", function(src, d)
    local id = tonumber(d.id)
    local key = tostring(d.key or d.item or "")
    local res = BuySupplies(src, id, { { key = key, qty = d.qty } }, d.payment)
    if res.ok then res.stock = GetStockCount(id, key) end
    return res
end)

lib.callback.register("pickle_restaurants:management:depositStock", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_stock") then return { ok = false, error = _L("no_permission") } end
    -- Deposit/withdraw move REAL inventory items, so a per-face stock key can never
    -- be one end of the trade: the pocket item is generic, so a deposit would have no
    -- face to record and a withdrawal would turn a dear toy into a cheap one. Buying
    -- is per face; moving is not offered for one, and says so.
    local key = tostring(d.key or d.item or "")
    local item, vid = SplitStockKey(key)
    if vid then return { ok = false, error = _L("mgmt_variant_not_movable") } end
    local costs = IngredientCosts()
    if costs[item] == nil or not ItemExists(item) then return { ok = false, error = _L("mgmt_item_required") } end
    local qty = math.max(1, math.min(1000, math.floor(tonumber(d.qty) or 0)))
    if (Inventory.GetItemCount(src, item) or 0) < qty then return { ok = false, error = _L("mgmt_not_enough_held") } end
    Inventory.RemoveItem(src, item, qty)
    AddStock(id, item, qty)
    AddLedger(id, "supply", 0, _L("ledger_stock_deposit", qty, GetItemLabel(item)), GetIdentifier(src))
    ShowNotification(src, _L("mgmt_stock_deposited", qty, GetItemLabel(item)))
    return { ok = true, stock = GetStockCount(id, item), held = Inventory.GetItemCount(src, item) or 0 }
end)

lib.callback.register("pickle_restaurants:management:withdrawStock", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_stock") then return { ok = false, error = _L("no_permission") } end
    -- Deposit/withdraw move REAL inventory items, so a per-face stock key can never
    -- be one end of the trade: the pocket item is generic, so a deposit would have no
    -- face to record and a withdrawal would turn a dear toy into a cheap one. Buying
    -- is per face; moving is not offered for one, and says so.
    local key = tostring(d.key or d.item or "")
    local item, vid = SplitStockKey(key)
    if vid then return { ok = false, error = _L("mgmt_variant_not_movable") } end
    local costs = IngredientCosts()
    if costs[item] == nil or not ItemExists(item) then return { ok = false, error = _L("mgmt_item_required") } end
    local qty = math.max(1, math.min(1000, math.floor(tonumber(d.qty) or 0)))
    if GetStockCount(id, item) < qty then return { ok = false, error = _L("mgmt_not_enough_stock") } end
    if Inventory.CanCarryItem and not Inventory.CanCarryItem(src, item, qty) then
        return { ok = false, error = _L("mgmt_cant_carry") }
    end
    -- pull from the pool FIRST (write-through + fails if raced dry), then give
    if not RemoveStock(id, item, qty) then return { ok = false, error = _L("mgmt_not_enough_stock") } end
    Inventory.AddItem(src, item, qty)
    AddLedger(id, "supply", 0, _L("ledger_stock_withdraw", qty, GetItemLabel(item)), GetIdentifier(src))
    ShowNotification(src, _L("mgmt_stock_withdrawn", qty, GetItemLabel(item)))
    return { ok = true, stock = GetStockCount(id, item), held = Inventory.GetItemCount(src, item) or 0 }
end)

-- ─── finances ────────────────────────────────────────────────────────────────

lib.callback.register("pickle_restaurants:management:deposit", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_balance") then return { ok = false, error = _L("no_permission") } end
    local amount = math.floor(tonumber(d.amount) or 0)
    if amount <= 0 then return { ok = false } end
    if GetMoney(src, "money") < amount then return { ok = false, error = _L("not_enough_cash") } end
    -- CREDIT THE ACCOUNT FIRST. Taking the cash and then failing to bank it would
    -- destroy a player's money; this way a failure costs them nothing.
    local banked, why = AdjustBalance(id, amount)
    if not banked then
        return { ok = false, error = _L(why == "refused" and "mgmt_bank_refused" or "mgmt_no_account") }
    end
    RemoveMoney(src, amount, "money")
    AddLedger(id, "deposit", amount, _L("ledger_deposit"), GetIdentifier(src))
    return { ok = true, balance = RestaurantBalance(id) }
end)

lib.callback.register("pickle_restaurants:management:withdraw", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_balance") then return { ok = false, error = _L("no_permission") } end
    local amount = math.floor(tonumber(d.amount) or 0)
    if amount <= 0 then return { ok = false } end
    if RestaurantBalance(id) < amount then return { ok = false, error = _L("mgmt_insufficient_funds") } end
    -- The DEBIT is the authority (see buyStock): pay the player only once the business
    -- account has actually given the money up, or a failed debit would mint cash.
    local paid, why = AdjustBalance(id, -amount)
    if not paid then
        return { ok = false, error = _L(why == "no_job" and "mgmt_no_account" or "mgmt_insufficient_funds") }
    end
    AddMoney(src, amount, "money")
    AddLedger(id, "withdraw", -amount, _L("ledger_withdrawal"), GetIdentifier(src))
    return { ok = true, balance = RestaurantBalance(id) }
end)

-- ─── branding ────────────────────────────────────────────────────────────────

-- The restaurant's brand image URLs, stored in the metadata blob and synced to
-- clients. The client render-target module draws them onto the food-packaging props
-- (pizza box, cup, tray paper, side container). Without `key` this sets the SHARED
-- default (`brand_image`, used by any texture with no override); with a `key` it sets
-- that one texture's override (`brand_images[key]`). Blank clears the entry.
-- Derived from the render-target registry (BrandRenderTargets) so a new brand target
-- is editable without touching this whitelist.
local BRAND_KEYS = {}
for _, t in ipairs(BrandRenderTargets()) do BRAND_KEYS[t.key] = true end

-- A crop is a normalised SOURCE rectangle { x, y, w, h } (0..1) into the image; the
-- client draws exactly that region onto the texture. Sanitise to 4 numbers within
-- bounds with a positive size, else drop it (falls back to a centred cover crop).
local function sanitizeCrop(c)
    if type(c) ~= "table" then return nil end
    local x, y, w, h = tonumber(c.x), tonumber(c.y), tonumber(c.w), tonumber(c.h)
    if not (x and y and w and h) or w <= 0 or h <= 0 then return nil end
    local function clamp(v) return math.max(0.0, math.min(1.0, v)) end
    x, y = clamp(x), clamp(y)
    w, h = math.min(w, 1.0 - x), math.min(h, 1.0 - y)
    if w <= 0 or h <= 0 then return nil end
    return { x = x, y = y, w = w, h = h }
end

-- Set a restaurant's branding and re-sync. `key` nil/"" sets the shared default image
-- (`brand_image`); a texture key sets that one texture's { url, crop } override. Blank
-- url clears the entry. Shared by the boss (management) and admin panels — each gates
-- its own permission before calling. Returns ok/error.
function SetRestaurantBrand(id, key, url, crop)
    local r = GetRestaurant(id); if not r then return { ok = false, error = _L("mgmt_no_restaurant") } end
    url = tostring(url or ""):gsub("^%s+", ""):gsub("%s+$", "")
    r.metadata = r.metadata or {}
    if key == "phone" then
        -- The storefront image the companion phone app shows for this restaurant (feed card +
        -- menu header). Separate from the packaging default so the phone can differ.
        r.metadata.phone_image = (url ~= "") and url or nil
    elseif key ~= nil and key ~= "" then
        if not BRAND_KEYS[key] then return { ok = false, error = _L("mgmt_unknown_texture") } end
        r.metadata.brand_images = r.metadata.brand_images or {}
        r.metadata.brand_images[key] = (url ~= "") and { url = url, crop = sanitizeCrop(crop) } or nil
        if next(r.metadata.brand_images) == nil then r.metadata.brand_images = nil end
    else
        r.metadata.brand_image = (url ~= "") and url or nil
    end
    MySQL.update.await("UPDATE pickle_restaurants SET metadata = ? WHERE id = ?", { json.encode(r.metadata), id })
    SyncWorldSoon() -- push the new branding to every client's render target
    return { ok = true }
end

lib.callback.register("pickle_restaurants:management:setBrandImage", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_props") then return { ok = false, error = _L("no_permission") } end
    local res = SetRestaurantBrand(id, d.key, d.url, d.crop)
    if res and res.ok then ShowNotificationOnce(src, "branding_saved", _L("branding_saved")) end
    return res
end)

-- ─── theme ───────────────────────────────────────────────────────────────────

-- The restaurant's NUI theme seed, stored in the metadata blob and synced to
-- clients. The whole panel palette is DERIVED from these three values on the
-- React side (CSS relative colors), so this is the entire theme config:
-- primary #rrggbb, mode dark|paper, radius sharp|soft|round.
local THEME_MODES = { dark = true, paper = true }
local THEME_RADII = { sharp = true, soft = true, round = true }

-- Global so the admin panel's app-theme callback can reuse it (the NUI is
-- untrusted; only whitelisted seed values are ever stored).
function SanitizeTheme(t)
    if type(t) ~= "table" then return nil end
    local out = {}
    local p = tostring(t.primary or ""):lower()
    if p:match("^#%x%x%x%x%x%x$") then out.primary = p end
    if THEME_MODES[t.mode] then out.mode = t.mode end
    if THEME_RADII[t.radius] then out.radius = t.radius end
    if next(out) == nil then return nil end
    return out
end

-- Set a restaurant's theme seed and re-sync. `theme` nil/empty clears it back to
-- the default kit. Shared by the boss (management) and admin panels — each gates
-- its own permission before calling.
function SetRestaurantTheme(id, theme)
    local r = GetRestaurant(id); if not r then return { ok = false, error = _L("mgmt_no_restaurant") } end
    r.metadata = r.metadata or {}
    r.metadata.theme = SanitizeTheme(theme)
    MySQL.update.await("UPDATE pickle_restaurants SET metadata = ? WHERE id = ?", { json.encode(r.metadata), id })
    SyncWorldSoon() -- the theme rides the restaurant sync payload
    return { ok = true }
end

lib.callback.register("pickle_restaurants:management:setTheme", function(src, d)
    local id = tonumber(d.id)
    if not HasPerm(id, src, "manage_props") then return { ok = false, error = _L("no_permission") } end
    local res = SetRestaurantTheme(id, d.theme)
    if res and res.ok then ShowNotificationOnce(src, "theme_saved", _L("theme_saved")) end
    return res
end)

-- ─── identity (rename) ───────────────────────────────────────────────────────

-- Caps mirror the `pickle_restaurants` columns (label VARCHAR(100), name
-- VARCHAR(60)) so a long name is trimmed here rather than truncated by MySQL.
local MAX_LABEL_LEN = 100
local MAX_NAME_LEN  = 60

-- The internal codename is DERIVED from the display label — exactly what the
-- admin panel's create form does (admins never type a raw slug), but slugged
-- SERVER-side so a rename can't plant a codename the untrusted NUI made up.
local function restSlug(s)
    return (tostring(s or ""):lower():gsub("[^a-z0-9]+", "_"):gsub("^_+", ""):gsub("_+$", ""))
end

-- Rename a restaurant. Shared by the boss (management) and admin panels — each
-- gates its own permission before calling. Write-through to BOTH the cache and
-- MySQL (the mutator pattern), then re-sync so the blip, station labels, menu/
-- orders boards and the phone all pick the new name up without a restart.
function SetRestaurantName(id, label)
    id = tonumber(id)
    local r = GetRestaurant(id); if not r then return { ok = false, error = _L("mgmt_no_restaurant") } end
    label = tostring(label or ""):gsub("^%s+", ""):gsub("%s+$", "")
    label = label:sub(1, MAX_LABEL_LEN)
    if label == "" then return { ok = false, error = _L("mgmt_name_required") } end
    local name = restSlug(label):sub(1, MAX_NAME_LEN)
    if name == "" then name = r.name end -- a label of pure symbols keeps the old key
    MySQL.update.await("UPDATE pickle_restaurants SET name = ?, label = ? WHERE id = ?", { name, label, id })
    r.name, r.label = name, label
    SyncWorldSoon()
    return { ok = true, name = name, label = label }
end

lib.callback.register("pickle_restaurants:management:setName", function(src, d)
    local id = tonumber(d.id)
    -- Renaming the business is an OWNER-level act, not a staff one: there is no
    -- per-employee permission for it in PERMISSIONS, and the name lands on every
    -- customer-facing surface (blip, screens, phone, receipts). ResolvePerms'
    -- second return is exactly "holds everything here" — owner, server admin or a
    -- BOSS grade of the job — so gate on that rather than inventing a perm or
    -- borrowing manage_props (which a shift lead may hold).
    local perms, isBoss = ResolvePerms(id, src)
    if not perms or not isBoss then return { ok = false, error = _L("no_permission") } end
    local res = SetRestaurantName(id, d.label)
    if res and res.ok then ShowNotification(src, _L("mgmt_name_saved", res.label)) end
    return res
end)
