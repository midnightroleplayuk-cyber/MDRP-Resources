-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/phone/17mov_Phone (client) — the 17mov phone implementation.
--
-- Registration is CLIENT-side here (the docs register in `client/main.lua`), like
-- lb-phone and GKSPhone and unlike Quasar. The app is an iframe pointed at our own
-- page, so once it exists it talks straight back to pickle_restaurants and needs
-- nothing further from the phone.
--
-- Presence, not readiness (see the lb-phone bridge): a phone commonly starts AFTER
-- the jobs that register apps on it, so a started-check at load time would leave
-- PhoneApp nil forever. Presence decides which bridge owns the API; readiness is
-- waited on below.
-- ─────────────────────────────────────────────────────────────────────────────
local RESOURCE = "17mov_Phone"

if GetResourceState(RESOURCE) == "missing" then return end
if not PhoneBridgeClaim(RESOURCE) then return end

local function AddApp()
    while GetResourceState(RESOURCE) ~= "started" do Wait(500) end
    Wait(1000)   -- let the AddApplication export come up

    local ok, err = pcall(function()
        exports[RESOURCE]:AddApplication({
            name         = PhoneAppMeta.id,
            label        = PhoneAppMeta.name,
            ui           = PhoneAppUI(),
            icon         = PhoneAppIcon(),
            -- `iconBackground` takes a hex string OR a gradient object. The brand
            -- green, flat: a restaurant's own theme is a per-restaurant seed and
            -- the phone icon belongs to the app, not to any one franchise.
            iconBackground = "#1F7A4C",
            default      = true,    -- can't be uninstalled; ships on the home screen
            preInstalled = true,
            resourceName = GetCurrentResourceName(),
            rating       = 5.0,
            -- No `job` key on purpose: this app is the CUSTOMER's as much as the
            -- staff's (ordering, reservations, delivery), and a job gate would hide
            -- it from everyone the restaurant exists to serve.
        })
    end)
    if not ok then
        print(("[pickle_restaurants] %s AddApplication failed: %s"):format(RESOURCE, tostring(err)))
        PrintPhoneAppInstall("The phone rejected the automatic registration.")
    end
end

CreateThread(AddApp)

-- The phone drops registered apps when it restarts, so add ours back.
AddEventHandler("onResourceStart", function(res)
    if res == RESOURCE then CreateThread(AddApp) end
end)

-- Leave nothing behind if WE stop: the app's page would 404 with the resource
-- serving it gone. `uninstall` is deliberately NOT set — that flag wipes it off
-- every player's phone, and a restart is not an uninstall.
AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    pcall(function()
        exports[RESOURCE]:RemoveApplication({ name = PhoneAppMeta.id, resourceName = res })
    end)
end)

PhoneApp = PhoneApp or {}
PhoneApp.resource = RESOURCE

-- 17mov publishes no Lua→iframe push for EXTERNAL apps (its `SendNuiMessage` is
-- the phone's own internal channel), so live pushes are not supported and the
-- React app polls instead — the same arrangement Quasar gets. Saying so through
-- PushSupported is what makes modules/phone choose polling rather than sit waiting
-- for messages that will never arrive. The candidate probe still runs first, so a
-- build that DOES publish one is picked up without editing this file.
local PUSH_EXPORTS = { "SendCustomAppMessage", "SendAppMessage", "SendNuiMessage" }
local pushExport, pushChecked = nil, false

function PhoneApp.Send(payload)
    if pushExport then
        PhoneCallExport(RESOURCE, pushExport, PhoneAppMeta.id, payload)
        return
    end
    if pushChecked then return end
    for _, name in ipairs(PUSH_EXPORTS) do
        -- PhoneCallExport, not a bare pcall: a missing export raises on the INDEX,
        -- which as an argument to pcall escapes it entirely (bridge/phone/shared.lua)
        if PhoneCallExport(RESOURCE, name, PhoneAppMeta.id, payload) then
            pushExport = name
            return
        end
    end
    pushChecked = true
end

function PhoneApp.PushSupported()
    return pushExport ~= nil
end

-- CreateNotification is client-side on this phone (the server half routes through
-- our own client event to reach it). `message` is its word for the body.
function PhoneApp.Notify(title, content)
    pcall(function()
        exports[RESOURCE]:CreateNotification({
            app     = PhoneAppMeta.id,
            title   = title,
            message = content,
        })
    end)
end

-- Nothing client-side answers this; the server's GetNumberFromPlayer is
-- authoritative and modules/sales falls back to it.
function PhoneApp.Number() return nil end

-- Put the phone away for the doorstep hand-off (bridge/phone/shared.lua explains
-- why). 17mov publishes an explicit, unambiguous close, so this calls it directly.
-- The IsPhoneOpen check is its OWN pcall: on a build that doesn't publish it, one
-- shared pcall would swallow the close as well.
function PhoneApp.Close()
    local ok, open = pcall(function() return exports[RESOURCE]:IsPhoneOpen() end)
    if ok and open == false then return end
    pcall(function() exports[RESOURCE]:ClosePhone() end)
end

-- The server half's notification route. 17mov's notification API is client-only,
-- so a server-side push hops through here rather than the bridge pretending it has
-- a server export it does not.
RegisterNetEvent("pickle_restaurants:17mov:notify", function(title, content)
    PhoneApp.Notify(title, content)
end)
