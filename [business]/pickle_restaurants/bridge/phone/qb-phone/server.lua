-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/phone/qb-phone (server) — the QBCore phone implementation.
--
-- READ THIS BEFORE DEBUGGING "the app didn't appear":
-- stock qb-phone has no custom-app system at all. Its apps are entries in
-- `Config.PhoneApplications` whose pages live INSIDE qb-phone's own html bundle —
-- there is no iframe host and no documented registration export. Several popular
-- forks did add one (names and payload shapes differ), so this bridge probes for it
-- and uses it when it's there; when it isn't, it prints the manual route instead of
-- failing silently. Everything else this resource needs from a phone — notifications
-- and the character's number — works on STOCK qb-phone, which is why the bridge is
-- still worth having even where the app has to be added by hand.
--
-- Presence, not readiness: a phone often starts after the jobs that register apps on
-- it, so a started-check here would leave the bridge undefined forever.
-- ─────────────────────────────────────────────────────────────────────────────

local RESOURCE = "qb-phone"

if GetResourceState(RESOURCE) == "missing" then return end
if not PhoneBridgeClaim(RESOURCE) then return end

-- What a hand-install of the app on qb-phone actually involves. Printed with the
-- shared values block, because "add these fields to your app config" is true of every
-- other phone and NOT true here — an admin who doesn't know that will paste a config
-- entry, see a dead icon, and conclude the resource is broken.
local INSTALL_NOTES = {
    "qb-phone specifics: stock builds have no iframe/custom-app host, so the app",
    "cannot register itself. Add an entry to Config.PhoneApplications in",
    "qb-phone/config.lua and point it at the page URL above (this needs a fork or a",
    "small html patch that renders a custom app in an iframe).",
    "Notifications and the caller's phone number work on stock qb-phone regardless.",
}

QBPhoneAppRegistered = false

local function AddApp()
    if QBPhoneAppRegistered then return true end
    local name, shape = PhoneTryRegister(RESOURCE)
    if not name then return false end
    QBPhoneAppRegistered = true
    print(("[pickle_restaurants] %s: app registered via %s (shape %d)"):format(RESOURCE, name, shape))
    return true
end

CreateThread(function()
    while GetResourceState(RESOURCE) ~= "started" do Wait(500) end
    Wait(1000)   -- let the exports come up
    if AddApp() then return end
    -- No server-side registrar. A fork may expose it client-side instead, so hand the
    -- clients a shot before falling back to telling the admin how to do it by hand.
    -- `-1` on purpose, and it is not a scoping candidate: qb-phone registers the app on the
    -- CLIENT side, so every connected client genuinely has to run this once — there is no
    -- subset of players for whom it's relevant. It fires exactly twice in a server's life
    -- (our boot, and qb-phone's own start), never on a gameplay event, and late joiners take
    -- the targeted `phone:qbAsk` path below instead. A one-time boot broadcast is not what
    -- builds an event backlog.
    TriggerClientEvent("pickle_restaurants:phone:qbClientRegister", -1)
    PrintPhoneAppInstall(("%s did not accept a runtime app registration."):format(RESOURCE), INSTALL_NOTES)
end)

-- A client that joined after the probe ran still needs telling to try its own side.
RegisterNetEvent("pickle_restaurants:phone:qbAsk", function()
    if not QBPhoneAppRegistered then
        TriggerClientEvent("pickle_restaurants:phone:qbClientRegister", source)
    end
end)

-- The phone restarting drops every registered app, so add ours back.
AddEventHandler("onResourceStart", function(res)
    if res == RESOURCE then
        Wait(1000)
        QBPhoneAppRegistered = false
        if not AddApp() then TriggerClientEvent("pickle_restaurants:phone:qbClientRegister", -1) end
    end
end)

-- qb-phone's notification is an EVENT, not an export, and it is the one part of this
-- bridge that is stable across builds:
--   qb-phone:client:CustomNotification(title, text, icon, color, timeout)
-- It takes a Font Awesome class rather than an image URL, so the order thumbnail we
-- pass to every other phone has nowhere to go here and the app's own glyph is used.
-- Guarded so a phone-less player never errors the callback that's notifying them.
function PhoneAppNotify(src, title, content, _thumbnail)
    pcall(function()
        TriggerClientEvent("qb-phone:client:CustomNotification", src,
            title, content, "fas fa-utensils", "#dc2626", 5000)
    end)
end

-- The number lives on the CHARACTER, not the phone: qb-phone reads
-- PlayerData.charinfo.phone like everything else in QBCore. Going through the core
-- rather than a qb-phone export is what makes this work on every fork — and it's the
-- authoritative answer even where a fork does publish a lookup.
function PhoneAppNumber(src)
    local ok, num = pcall(function()
        local p = QBCore and QBCore.Functions.GetPlayer(tonumber(src))
        return p and p.PlayerData and p.PlayerData.charinfo and p.PlayerData.charinfo.phone
    end)
    if ok and num then return tostring(num) end
    return nil
end
