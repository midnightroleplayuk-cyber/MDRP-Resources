-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/phone/lb-phone (client) — the lb-phone implementation of the phone API.
--
-- Defines the globals modules/phone calls: PhoneApp.Send / Notify / Number, and OWNS
-- registering the app. Registration lives in the bridge (not the module) because the
-- phones disagree about where it happens at all — lb-phone registers from the CLIENT,
-- Quasar from the SERVER. The module just uses the app once it exists.
--
-- The resource guard is "not MISSING" rather than the usual "is STARTED": a phone
-- commonly starts AFTER the jobs that register apps on it, and a hard started-check at
-- load time would leave PhoneApp nil forever on those servers. Presence decides which
-- bridge owns the API; readiness is waited on below.
-- ─────────────────────────────────────────────────────────────────────────────
if GetResourceState("lb-phone") == "missing" then return end

PhoneApp = PhoneApp or {}
PhoneApp.resource = "lb-phone"

local function AddApp()
    local ok, err = exports["lb-phone"]:AddCustomApp({
        identifier  = PhoneAppMeta.id,
        name        = PhoneAppMeta.name,
        description = PhoneAppDescription(),
        developer   = PhoneAppMeta.developer,
        defaultApp  = true,            -- ships pre-installed
        size        = PhoneAppMeta.size,
        ui          = PhoneAppUI(),
        icon        = PhoneAppIcon(),
        fixBlur     = true,            -- our CSS uses rem/em (Tailwind)
    })
    if not ok then
        print(("[pickle_restaurants] lb-phone AddCustomApp failed: %s"):format(tostring(err)))
    end
end

CreateThread(function()
    while GetResourceState("lb-phone") ~= "started" do Wait(500) end
    Wait(1000)   -- let the AddCustomApp export come up
    AddApp()
end)

-- lb-phone drops every registered app when it restarts, so add ours back.
AddEventHandler("onResourceStart", function(res)
    if res == "lb-phone" then Wait(1000); AddApp() end
end)

-- lb-phone forwards the WHOLE table into the iframe as a window `message`, which is
-- why modules/phone flattens `action` into the payload before calling this.
function PhoneApp.Send(payload)
    pcall(function() exports["lb-phone"]:SendCustomAppMessage(PhoneAppMeta.id, payload) end)
end

function PhoneApp.Notify(title, content)
    pcall(function()
        exports["lb-phone"]:SendNotification({ app = PhoneAppMeta.id, title = title, content = content })
    end)
end

function PhoneApp.Number()
    local ok, num = pcall(function() return exports["lb-phone"]:GetEquippedPhoneNumber() end)
    return ok and num or nil
end

-- Put the phone away — the doorstep hand-off can't play with it in the ped's hand
-- (see bridge/phone/shared.lua). lb-phone is the one phone with a documented, explicit
-- close, so this bridge calls it directly instead of going through PhoneCloseVia.
-- The IsOpen check is its OWN pcall: on a build that doesn't publish it, one shared
-- pcall would swallow the close as well.
function PhoneApp.Close()
    local ok, open = pcall(function() return exports["lb-phone"]:IsOpen() end)
    if ok and open == false then return end
    pcall(function() exports["lb-phone"]:ToggleOpen(false) end)
end
