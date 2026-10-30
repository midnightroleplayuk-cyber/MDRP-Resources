-- =============================================
--  modules/sales | client.lua
--  Opens the staff POS register NUI, relays its order callbacks, and hosts the
--  customer-side payment confirm (a server-awaited prompt that ALWAYS answers).
-- =============================================

-- The restaurant whose register this client currently has open (nil = none). Used
-- to decide whether an incoming live-ticket list applies to us.
local OpenRid = nil

function OpenRegister(restaurantId)
    local data = lib.callback.await("pickle_restaurants:sales:getRegister", false, { id = restaurantId })
    if not data or not data.ok then return ShowNotification((data and data.error) or _L("sales_no_work")) end
    OpenRid = restaurantId
    OpenNUI("register", data)
end

-- Customer-facing self-service kiosk: opens the SAME priced menu the register
-- sells, but the customer builds and pays for their own order (no cashier). The
-- server still turns it into a normal kitchen ticket that staff fulfil at the
-- register, so nothing about the kitchen/fulfillment flow changes.
function OpenKiosk(restaurantId)
    local data = lib.callback.await("pickle_restaurants:sales:getKiosk", false, { id = restaurantId })
    if not data or not data.ok then return ShowNotification((data and data.error) or _L("sales_kiosk_unavailable")) end
    OpenNUI("order", data)
end

-- The restaurant whose corner "Tickets" widget is currently shown (nil = none).
-- Set/cleared by OpenNUI/CloseNUI for restaurant-scoped experiences.
TicketWidgetRid = nil

-- Show the read-only "Tickets" widget for `rid` (cooking / management / virtual).
-- Seeds it once from a lightweight callback (non-blocking so it can't stall the
-- open flow), then it stays live off the `orders` broadcast below.
function ShowTicketWidget(rid, theme)
    TicketWidgetRid = rid
    SendNUIMessage({ action = "ticketWidget", show = true, theme = theme })
    CreateThread(function()
        local res = lib.callback.await("pickle_restaurants:sales:getTickets", false, { id = rid })
        if TicketWidgetRid == rid then
            SendNUIMessage({ action = "ticketWidget", show = true, tickets = (res and res.tickets) or {}, theme = theme })
        end
    end)
end

function HideTicketWidget()
    TicketWidgetRid = nil
    SendNUIMessage({ action = "ticketWidget", show = false })
end

-- Live ticket list: the server broadcasts the fresh open-order list whenever it
-- changes (create/cancel/complete, from ANY cashier) or the pool changes. We apply
-- it whenever this client has that restaurant's register open — no sequencing
-- needed: this is the ONLY thing that updates the list, and FiveM delivers these
-- events reliably and in order, so the last list sent is always the last shown. We
-- only ever touch the ticket LIST (never the whole panel) so the catalog/cart are
-- untouched. The same broadcast also keeps the corner Tickets widget live.
RegisterNetEvent("pickle_restaurants:sales:orders", function(rid, orders)
    orders = orders or {}
    if OpenRid == rid and NUIView == "register" then
        SendNUIMessage({ action = "orders", orders = orders })
    end
    if TicketWidgetRid == rid then
        SendNUIMessage({ action = "ticketWidget", show = true, tickets = orders })
    end
end)

-- POS actions just report ok/error; the ticket list refreshes itself via the
-- broadcast above (which the acting cashier receives too).
--
-- The 2nd arg to lib.callback.await is `false` (NOT a timeout). In ox_lib that
-- argument is a per-EVENT `delay`/cooldown: a positive number blocks the SAME
-- callback from being sent again for that many ms, returning nil WITHOUT ever
-- reaching the server. Passing a "timeout" like 45000 here silently rate-limited
-- each order action to once per 45s — the second create/cancel within the window
-- died on the client (no server hit), which is exactly the "can't create a new
-- one / cancel does nothing until restart" bug. `false` = no cooldown; the actual
-- response timeout is ox_lib's own `ox:callbackTimeout` convar (default 5 min).
local function relayOrder(event)
    RegisterNUICallback(event, function(d, cb)
        local res = lib.callback.await("pickle_restaurants:" .. event, false, d)
        if res and res.error then ShowNotification(res.error) end
        -- Re-assert focus after every action: an order flow (receipt add/remove,
        -- the customer confirm) can drop the NUI cursor, and then the NEXT click —
        -- charging a new order, cancelling the next ticket — silently no-ops. Keep
        -- the panel clickable so back-to-back create/cancel/create always works.
        if NUIView == "register" or NUIView == "order" then
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(false)
        end
        cb(res or { ok = false })
    end)
end
relayOrder("sales:createOrder")
relayOrder("sales:completeOrder")
relayOrder("sales:cancelOrder")
-- The self-service kiosk order (customer pays for their own; becomes a ticket).
relayOrder("sales:kioskOrder")

-- ─── customer payment confirm ────────────────────────────────────────────────
-- The server awaits this while the cashier's register shows "waiting". The
-- promise is GUARANTEED to resolve: Accept/Decline buttons, the NUI's own 30s
-- countdown, a view-close watcher (ESC closes panels without telling anyone),
-- and a 35s belt-and-suspenders timeout.

local paySettle = nil -- settle(answer): resolves the pending prompt exactly once

RegisterNUICallback("sales:payChoice", function(d, cb)
    if paySettle then paySettle(d and d.accept == true) end
    cb({})
end)

lib.callback.register("pickle_restaurants:sales:confirmCharge", function(data)
    if NUIView ~= "none" then return false end -- busy in another panel → auto-decline
    local p, settled = promise.new(), false
    local function settle(answer)
        if settled then return end
        settled = true
        paySettle = nil
        p:resolve(answer == true)
    end
    paySettle = settle
    OpenNUI("payconfirm", data)

    -- ESC (the generic panel-close) kills the view without answering — watch for it.
    CreateThread(function()
        while not settled and NUIView == "payconfirm" do Wait(100) end
        settle(false)
    end)
    SetTimeout(35000, function() settle(false) end)

    local accepted = Citizen.Await(p)
    if NUIView == "payconfirm" then CloseNUI() end
    return accepted == true
end)
