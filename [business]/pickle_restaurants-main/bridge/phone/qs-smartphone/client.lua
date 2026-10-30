-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/phone/qs-smartphone (client) — Quasar custom-app registration + API.
--
-- Docs: call addCustomApp from the CLIENT after qs-smartphone has started.
-- Quasar has no Lua→iframe push — Send is a no-op; the React app polls instead.
-- ─────────────────────────────────────────────────────────────────────────────
local QS_RESOURCES = { "qs-smartphone", "qs-smartphone-pro" }

local RESOURCE
for _, res in ipairs(QS_RESOURCES) do
    if GetResourceState(res) ~= "missing" then RESOURCE = res break end
end
if not RESOURCE then return end
if not PhoneBridgeClaim(RESOURCE) then return end

local registered = false

-- Exact shape from qs-smartphone/docs (Custom app iframe). Shared PhoneAppShapes
-- is too thin for this build — missing category / creator / custom.bridge and the
-- export's real success is the returned boolean, not "didn't throw".
local function AddApp()
    if registered then return end
    while GetResourceState(RESOURCE) ~= "started" do Wait(500) end

    local origin = ("https://cfx-nui-%s"):format(GetCurrentResourceName())
    local ok, success, err = pcall(function()
        return exports[RESOURCE]:addCustomApp({
            id          = PhoneAppMeta.id,
            label       = PhoneAppMeta.name,
            icon        = PhoneAppIcon(),
            category    = "Food",
            creator     = PhoneAppMeta.developer,
            description = PhoneAppDescription(),
            appStoreOnly = false,   -- pre-installed on the home screen
            sizeMb      = 1,
            iframe      = { url = PhoneAppUI() },
            custom      = {
                enabled = true,
                bridge  = {
                    enabled        = true,
                    allowedOrigins = { origin },
                },
            },
        })
    end)

    if not ok then
        print(("[pickle_restaurants] %s addCustomApp threw: %s"):format(RESOURCE, tostring(success)))
        return
    end
    if success == false then
        print(("[pickle_restaurants] %s addCustomApp rejected: %s"):format(RESOURCE, tostring(err)))
        return
    end

    registered = true
    print(("[pickle_restaurants] %s: app registered (%s)"):format(RESOURCE, PhoneAppMeta.id))
end

CreateThread(function()
    Wait(1000)
    AddApp()
end)

-- Phone restart drops every registered app.
AddEventHandler("onResourceStart", function(res)
    if res ~= RESOURCE then return end
    registered = false
    Wait(1000)
    AddApp()
end)

-- Late join / phone data not ready on first attempt.
RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    registered = false
    CreateThread(function()
        Wait(1500)
        AddApp()
    end)
end)

RegisterNetEvent("esx:playerLoaded", function()
    registered = false
    CreateThread(function()
        Wait(1500)
        AddApp()
    end)
end)

PhoneApp = PhoneApp or {}
PhoneApp.resource = RESOURCE

function PhoneApp.Send(_) end
function PhoneApp.PushSupported() return false end

function PhoneApp.Notify(title, content)
    pcall(function() TriggerEvent("phone:notification", _L("phone_notify_join", title, content), "info") end)
end

function PhoneApp.Number() return nil end

function PhoneApp.Close()
    TriggerEvent("qs-smartphone:client:closePhone")
end
