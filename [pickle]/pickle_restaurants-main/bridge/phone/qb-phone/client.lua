-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/phone/qb-phone (client) — the QBCore phone implementation of the phone API.
--
-- Defines the globals modules/phone calls: PhoneApp.Send / Notify / Number / Close.
-- See the server half for why registration is a probe-and-report rather than a call:
-- stock qb-phone has no custom-app host, and the forks that added one disagree about
-- where it lives, so this side gets its own attempt when the server's came up empty.
--
-- Presence, not readiness (see the lb-phone bridge): a phone commonly starts AFTER
-- the jobs that register apps on it, so a started-check at load time would leave
-- PhoneApp nil forever.
-- ─────────────────────────────────────────────────────────────────────────────

local RESOURCE = "qb-phone"

if GetResourceState(RESOURCE) == "missing" then return end
if not PhoneBridgeClaim(RESOURCE) then return end   -- also stamps PhoneApp.resource

local registered = false

local function TryClientRegister()
    if registered then return end
    local name, shape = PhoneTryRegister(RESOURCE)
    if name then
        registered = true
        return print(("[pickle_restaurants] %s: app registered client-side via %s (shape %d)")
            :format(RESOURCE, name, shape))
    end
    print(("[pickle_restaurants] %s: no client-side app registration export either — "
        .. "add the app by hand (run `pickle_phoneapp` in the server console for the values)")
        :format(RESOURCE))
end

RegisterNetEvent("pickle_restaurants:phone:qbClientRegister", function()
    while GetResourceState(RESOURCE) ~= "started" do Wait(500) end
    Wait(1000)
    TryClientRegister()
end)

-- Ask on spawn: a player who joined after the server ran its probe never saw the
-- broadcast, and on a fork that registers per-player this side is the only one that can.
CreateThread(function()
    Wait(5000)
    TriggerServerEvent("pickle_restaurants:phone:qbAsk")
end)

-- ─── live push into the app page ─────────────────────────────────────────────
-- qb-phone publishes no Lua→app message path (there's no iframe to message on stock
-- builds at all), so the plausible fork names are probed once and, if none answer,
-- PushSupported() goes false and the React app polls instead — everything
-- request/response already works regardless, since the page's fetchNui POSTs land on
-- THIS resource's NUI callbacks no matter who hosts the iframe.
local PUSH_EXPORTS = {
    "sendCustomAppMessage", "SendCustomAppMessage",
    "sendAppMessage", "SendAppMessage",
    "emitCustomAppEvent", "customAppEmit",
}

local resolved = nil   -- nil = untried, false = no candidate works

function PhoneApp.Send(payload)
    if resolved == false then return end
    if resolved then
        PhoneCallExport(RESOURCE, resolved, PhoneAppMeta.id, payload)
        return
    end
    -- PhoneCallExport, not a bare pcall: indexing a missing export RAISES, and as an
    -- argument to pcall that raise happens before pcall runs (bridge/phone/shared.lua)
    for _, name in ipairs(PUSH_EXPORTS) do
        if PhoneCallExport(RESOURCE, name, PhoneAppMeta.id, payload) then
            resolved = name
            print(("[pickle_restaurants] %s: live app push via %s"):format(RESOURCE, name))
            return
        end
    end
    resolved = false
    print(("[pickle_restaurants] %s exposes no Lua→app push export — the app will poll instead. "
        .. "See bridge/phone/qb-phone/client.lua"):format(RESOURCE))
end

-- Answers modules/phone's `phone:pushSupported` NUI callback, which is what tells the
-- app to poll rather than wait for pushes that will never arrive.
function PhoneApp.PushSupported() return resolved ~= false end

-- Resolve the push path EAGERLY rather than on the first real broadcast: the app asks
-- whether to poll as soon as it opens, and "untried" would answer yes-push and then
-- silently never deliver. `ping` matches no useNuiEvent handler, so a working push
-- costs the page nothing.
CreateThread(function()
    while GetResourceState(RESOURCE) ~= "started" do Wait(500) end
    Wait(2000)
    PhoneApp.Send({ action = "ping" })
end)

-- The same CustomNotification event the server half uses, fired locally. Stable across
-- qb-phone builds, and takes a Font Awesome class rather than an image URL.
function PhoneApp.Notify(title, content)
    pcall(function()
        TriggerEvent("qb-phone:client:CustomNotification", title, content, "fas fa-utensils", "#dc2626", 5000)
    end)
end

-- The number is on the CHARACTER (PlayerData.charinfo.phone), so it comes from the
-- core rather than from qb-phone — which is what makes it fork-proof.
function PhoneApp.Number()
    local ok, num = pcall(function()
        local d = QBCore and QBCore.Functions.GetPlayerData()
        return d and d.charinfo and d.charinfo.phone
    end)
    if ok and num then return tostring(num) end
    return nil
end

-- Put the phone away for the doorstep hand-off (bridge/phone/shared.lua explains why).
-- qb-phone closes on an event; the exports are fork candidates tried first. NEVER list
-- a toggle here — on an already-closed phone a toggle would open it.
local CLOSE_EXPORTS = { "ClosePhone", "closePhone" }
local CLOSE_EVENTS  = { "qb-phone:client:PhoneClose", "qb-phone:client:ClosePhone" }

function PhoneApp.Close()
    PhoneCloseVia(RESOURCE, CLOSE_EXPORTS, CLOSE_EVENTS)
end
