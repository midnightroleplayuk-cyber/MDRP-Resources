-- =============================================
--  modules/management | client.lua
--  Opens the management NUI and relays its actions to the server.
-- =============================================

-- `section` (optional) tells the NUI to open a specific tab and scroll to it —
-- used after a placement flow so the boss lands back on Stations/Seating.
-- SHOP MODE: the panel opened at a supply depot's counter, showing only Supplies.
-- Held here rather than passed around because `relayThenRefresh` re-fetches getData on
-- every action, and a refresh that dropped the flag would close the shop out from under
-- someone mid-purchase. The server re-verifies the flag against where the player is
-- actually standing, so this is a request, never a grant.
local ShopMode = false

function OpenManagement(restaurantId, section, shop)
    ShopMode = shop and true or false
    local data = lib.callback.await("pickle_restaurants:management:getData", false,
        { id = restaurantId, shop = ShopMode })
    if not data or not data.ok then
        ShopMode = false
        return ShowNotification((data and data.error) or _L("manage_no_access"))
    end
    data.restaurantId = restaurantId
    if section then data.focus = { section = section } end
    OpenNUI("management", data)
end

local function relayThenRefresh(callbackName)
    return function(d, cb)
        local res = lib.callback.await(callbackName, false, d)
        if res and res.error then ShowNotification(res.error) end
        -- hand the fresh dataset back so the panel re-renders
        if d.id then
            local data = lib.callback.await("pickle_restaurants:management:getData", false, { id = d.id, shop = ShopMode })
            if data and data.ok then
                data.restaurantId = d.id
                SendNUIMessage({ action = "setView", view = "management", data = data })
            end
        end
        cb(res or {})
    end
end

-- Employment moves players between grades of the restaurant's JOB (there is no
-- employee row any more), and pay is per RANK — so `management:setCommission` is
-- gone with the per-employee rate it used to write, replaced by setRank.
RegisterNUICallback("management:hire",           relayThenRefresh("pickle_restaurants:management:hire"))
RegisterNUICallback("management:fire",           relayThenRefresh("pickle_restaurants:management:fire"))
RegisterNUICallback("management:setGrade",       relayThenRefresh("pickle_restaurants:management:setGrade"))
-- Paying tips out / running the wage bill: both refresh, since both change the
-- numbers the Payroll tab is looking at (the pool, the balance, the payslip list).
RegisterNUICallback("management:payTips",        relayThenRefresh("pickle_restaurants:management:payTips"))
RegisterNUICallback("management:runPayroll",     relayThenRefresh("pickle_restaurants:management:runPayroll"))
RegisterNUICallback("management:saveMenuItem",   relayThenRefresh("pickle_restaurants:management:saveMenuItem"))
RegisterNUICallback("management:deleteMenuItem", relayThenRefresh("pickle_restaurants:management:deleteMenuItem"))
RegisterNUICallback("management:deposit",        relayThenRefresh("pickle_restaurants:management:deposit"))
RegisterNUICallback("management:withdraw",       relayThenRefresh("pickle_restaurants:management:withdraw"))
RegisterNUICallback("management:buyStock",       relayThenRefresh("pickle_restaurants:management:buyStock"))
RegisterNUICallback("management:depositStock",   relayThenRefresh("pickle_restaurants:management:depositStock"))
RegisterNUICallback("management:withdrawStock",  relayThenRefresh("pickle_restaurants:management:withdrawStock"))

-- Clocking in/out from the panel's Dashboard tab. These go to the PHONE module's
-- callbacks on purpose — one ShiftCache, one tip pool, one set of shift rows, so the
-- register dashboard and the phone can never disagree about whether you're on shift.
-- They refresh like any other action, since the dashboard's roster/timer come down in
-- the getData payload.
RegisterNUICallback("management:clockIn",  relayThenRefresh("pickle_restaurants:phone:clockIn"))
RegisterNUICallback("management:clockOut", relayThenRefresh("pickle_restaurants:phone:clockOut"))

-- Plain refresh, no mutation: the Dashboard polls this so its shift timer, ticket
-- queue and roster stay live while the panel sits open.
RegisterNUICallback("management:refresh", function(d, cb)
    local data = d.id and lib.callback.await("pickle_restaurants:management:getData", false, { id = d.id })
    if data and data.ok then
        data.restaurantId = d.id
        return cb(data)
    end
    cb({ ok = false })
end)

-- Branding saves DON'T refresh the panel — that would remount the crop UI mid-setup.
-- The React side keeps its own optimistic copy; the server sync drives the props.
RegisterNUICallback("management:setBrandImage", function(d, cb)
    local res = lib.callback.await("pickle_restaurants:management:setBrandImage", false, d)
    if res and res.error then ShowNotification(res.error) end
    cb(res or {})
end)

-- Theme saves also skip the refresh — the NUI already applied the theme live.
RegisterNUICallback("management:setTheme", function(d, cb)
    local res = lib.callback.await("pickle_restaurants:management:setTheme", false, d)
    if res and res.error then ShowNotification(res.error) end
    cb(res or {})
end)

-- Rank edits skip the refresh for the same reason the rename does: they auto-save as
-- the boss types a salary or ticks a permission, and re-fetching getData would remount
-- the Ranks editor and yank the cursor out of the field mid-edit. The reply carries the
-- sanitized `ranks` array so the panel can reconcile without a full refetch.
RegisterNUICallback("management:setRank", function(d, cb)
    local res = lib.callback.await("pickle_restaurants:management:setRank", false, d)
    if res and res.error then ShowNotification(res.error) end
    cb(res or {})
end)

-- Rename also skips the refresh: it auto-saves as you type, and re-fetching getData
-- would remount the Brand tab and yank the cursor out of the field mid-edit.
RegisterNUICallback("management:setName", function(d, cb)
    local res = lib.callback.await("pickle_restaurants:management:setName", false, d)
    if res and res.error then ShowNotification(res.error) end
    cb(res or {})
end)

-- PLACEMENT LIVES IN THE ADMIN PANEL ONLY. Stations, counters, seats, virtual
-- points and the NPC spawn point are all placed from /restaurants by an admin —
-- the boss panel has no Stations tab any more, and the placement/removal server
-- callbacks are gated on IsPlayerAdmin, so a forged `management:*` NUI post has
-- nothing to reach. `manage_props` still governs the Branding tab.

-- ─── a job offer, awaiting THIS player's answer ──────────────────────────────
-- Hiring changes the target's job, so the server only ever ASKS (see the offer flow
-- in modules/management/server.lua). This is the answering half: the same
-- ox_lib context prompt modules/seating uses for a seat request, because it is the
-- same shape of question — another player wants to do something to you, and the
-- answer is a push back to them.
--
-- Deliberately NOT auto-dismissed on the TTL: a context menu the player is reading
-- must not vanish mid-click. A late answer is simply refused server-side, where the
-- offer's expiry lives.
RegisterNetEvent("pickle_restaurants:management:jobOffer", function(d)
    if type(d) ~= "table" then return end
    local function answer(accept)
        TriggerServerEvent("pickle_restaurants:management:answerJobOffer", { accept = accept })
    end
    lib.registerContext({
        id = "pickle_restaurants_job_offer",
        title = _L("mgmt_offer_title"),
        options = {
            {
                title = _L("mgmt_offer_accept"),
                description = _L("mgmt_offer_body", d.from or "?", d.restaurant or "?", d.grade or "?"),
                icon = "check",
                onSelect = function() answer(true) end,
            },
            {
                title = _L("mgmt_offer_decline"),
                description = _L("mgmt_offer_decline_hint"),
                icon = "xmark",
                onSelect = function() answer(false) end,
            },
        },
    })
    lib.showContext("pickle_restaurants_job_offer")
end)

-- The supplies CART (panel or depot counter). Refreshes like every other stock action
-- so the larder counts, the balance and the pending-run list all land together.
RegisterNUICallback("management:buySupplies", relayThenRefresh("pickle_restaurants:management:buySupplies"))
