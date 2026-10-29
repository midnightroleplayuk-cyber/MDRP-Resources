-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/phone/gksphone (client) — the GKSPhone implementation of the phone API.
--
-- Defines the globals modules/phone calls: PhoneApp.Send / Notify / Number, and OWNS
-- registering the app. Like lb-phone, GKSPhone's custom-app registration is exposed to
-- the client (its AddCustomApp export is documented as Server/Client), so we register
-- here; the server half only carries the notification + number fallbacks.
--
-- Presence, not readiness (see the lb-phone bridge): a phone commonly starts AFTER the
-- jobs that register apps on it, so a started-check at load time would leave PhoneApp
-- nil forever. Presence decides which bridge owns the API; readiness is waited on below.
-- ─────────────────────────────────────────────────────────────────────────────
if GetResourceState("gksphone") == "missing" then return end

PhoneApp = PhoneApp or {}
PhoneApp.resource = "gksphone"

-- GKSPhone's registration shape (docs "Custom App → CustomApp"). Notable differences
-- from lb-phone: the icon field is `icons`, the page goes in `appurl` (`url` is a fixed
-- internal route you "do not touch"), the display name is per-language in `labelLangs`
-- while `name` is the unique machine id, and job gates live in `blockedjobs`/`allowjob`.
local function AddApp()
    local label = PhoneAppMeta.name
    -- Every language shows the same brand name; GKSPhone falls back to `name` for any
    -- locale not listed, but the docs enumerate these keys so we fill them all.
    local labelLangs = {}
    for _, lang in ipairs({
        "af", "ar", "cs", "de", "en", "es", "fr", "id", "nl",
        "pt-PT", "ro", "sv", "th", "tr", "uk", "zh-TW",
    }) do
        labelLangs[lang] = label
    end

    local ok, err = pcall(function()
        exports["gksphone"]:AddCustomApp({
            name        = PhoneAppMeta.id,      -- unique app id
            icons       = PhoneAppIcon(),       -- note: `icons`, not `icon`
            description = PhoneAppDescription(),
            appurl      = PhoneAppUI(),          -- our iframe page
            url         = "/customapp",          -- fixed internal route — do not touch
            blockedjobs = {},
            allowjob    = {},
            signal      = true,
            show        = true,
            labelLangs  = labelLangs,
        })
    end)
    if not ok then
        print(("[pickle_restaurants] gksphone AddCustomApp failed: %s"):format(tostring(err)))
    end
end

CreateThread(function()
    while GetResourceState("gksphone") ~= "started" do Wait(500) end
    Wait(1000)   -- let the AddCustomApp export come up
    AddApp()
end)

-- GKSPhone drops registered apps when it restarts, so add ours back.
AddEventHandler("onResourceStart", function(res)
    if res == "gksphone" then Wait(1000); AddApp() end
end)

-- GKSPhone fires this on the custom app's own resource every time the app is opened
-- (docs "Open App"). We don't need it to seed anything — the React app fetches its own
-- data on mount — but the callback must exist so the open handshake resolves cleanly.
RegisterNUICallback("getInfo", function(_, cb)
    cb("ok")
end)

-- Push a message into the app iframe. GKSPhone forwards the WHOLE table to the page as
-- a window `message` (docs "NuiSendMessage"), exactly like lb-phone's app-message —
-- modules/phone flattens `action` into the payload and useNuiEvent matches on `.action`.
function PhoneApp.Send(payload)
    pcall(function() exports["gksphone"]:NuiSendMessage(payload) end)
end

-- GKSPhone's notification and number exports are BOTH server-side (sendNotification /
-- GetPhoneBySource — see the server half of this bridge), and it publishes no client
-- equivalents. So the two client hooks below defer to the server:
--   • Notify — no native client notification path. The only caller is the promo push,
--     whose content already lands in-app via PhoneApp.Send above, so this is a
--     deliberate no-op rather than a broken export call.
--   • Number — return nil; modules/sales falls back to PhoneAppNumber(src), which
--     resolves it authoritatively with GetPhoneBySource(src) server-side.
function PhoneApp.Notify(_, _) end
function PhoneApp.Number() return nil end

-- Put the phone away for the doorstep hand-off (bridge/phone/shared.lua explains why).
-- GKSPhone publishes no close export, so these are the plausible names with its close
-- event as the fallback. Add yours here if your build differs.
local CLOSE_EXPORTS = { "PhoneClose", "ClosePhone", "closePhone" }
local CLOSE_EVENTS  = { "gksphone:CloseAllPhone" }

function PhoneApp.Close()
    PhoneCloseVia("gksphone", CLOSE_EXPORTS, CLOSE_EVENTS)
end
