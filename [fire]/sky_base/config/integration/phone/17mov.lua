if Sky.Config.phone ~= "17mov" then return end

local RESOURCE = "17mov_Phone"

function Sky.Functions.GetPhoneTrackingCapabilities()
    return { phoneNumber = true, socialMedia = false }
end

local registeredApps = {}
local appOpenHandlers = {}

local function build_app_url(app)
    local resource = app.resource or GetCurrentResourceName()
    local url = app.url

    if not url then
        local path = app.uiPath or app.ui or "source/html/index.html"
        if path:find("^nui://") then
            url = path:gsub("^nui://([^/]+)/", "https://cfx-nui-%1/")
        elseif path:find("^https?://") then
            url = path
        else
            path = path:gsub("^" .. resource .. "/", "")
            url = ("https://cfx-nui-%s/%s"):format(resource, path)
        end
    end

    if app.route and not url:find("skyPhoneRoute=", 1, true) then
        local separator = url:find("?", 1, true) and "&" or "?"
        url = ("%s%sskyPhoneRoute=%s"):format(url, separator, app.route)
    end

    if not url:find("skyPhone=", 1, true) then
        local separator = url:find("?", 1, true) and "&" or "?"
        url = ("%s%sskyPhone=17mov"):format(url, separator)
    end

    return url
end

local function build_icon_url(app)
    local icon = app.icon
    if type(icon) ~= "string" or icon == "" then
        return icon
    end

    if icon:find("^https?://") then
        return icon
    end

    if icon:find("^nui://") then
        return icon:gsub("^nui://([^/]+)/", "https://cfx-nui-%1/")
    end

    local resource = app.resource or GetCurrentResourceName()
    icon = icon:gsub("^" .. resource .. "/", "")
    return ("https://cfx-nui-%s/%s"):format(resource, icon)
end

local function build_app_data(app)
    return {
        name = app.identifier,
        label = app.name,
        ui = build_app_url(app),
        icon = build_icon_url(app),
        iconBackground = app.iconBackground or { angle = 135, colors = { "#1f2937", "#111827" } },
        default = app.defaultApp == true,
        preInstalled = app.defaultApp == true,
        resourceName = app.resource or GetCurrentResourceName(),
        rating = tonumber(app.rating) or 5.0,
        job = app.job
    }
end

function Sky.Functions.ChangeNumber(src, newNumber)
    exports[RESOURCE]:EjectSimCard(src)
    exports[RESOURCE]:AddSimcard(src, newNumber)
    TriggerClientEvent("sky_base:notification", src, "Phone", "Your phone number has been changed. Please relog.", "warn", 10000)
end

function Sky.Functions.IsNumberUsed(phoneNumber)
    local result = Sky.Query('SELECT COUNT(*) as count FROM 17phone_simcards WHERE number = ?', { phoneNumber })
    if result[1] and result[1].count > 0 then
        return true
    else
        return false
    end
end

-- 17mov_Phone registers custom apps per player on the client and re-emits them on
-- "17mov_Phone:Client:Ready", so registration and NUI messaging stay in the client realm.
function Sky.Functions.RegisterCustomPhoneApp(app)
    if IsDuplicityVersion() then
        Sky.Debug("error", "17mov_Phone custom apps register on the client; RegisterCustomPhoneApp was called on the server.")
        return false, "client_only"
    end

    local appData = build_app_data(app)

    registeredApps[appData.name] = appData
    if type(app.onOpen) == "function" then
        appOpenHandlers[appData.name] = app.onOpen
    end

    if GetResourceState(RESOURCE) == "started" then
        exports[RESOURCE]:AddApplication(appData)
    end

    return true
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    if IsDuplicityVersion() then
        Sky.Debug("error", "17mov_Phone custom app messages send from the client; SendCustomPhoneAppMessage was called on the server.")
        return
    end

    exports[RESOURCE]:SendAppMessage(identifier, data or {})
end

function Sky.Functions.SendPhoneAppNotification(data, source)
    data = data or {}

    local notification = {
        app = data.app or data.identifier,
        title = data.title,
        message = data.content or data.message or data.text
    }

    local href = data.href or data.route
    if href then
        notification.data = { href = href, alwaysShow = data.alwaysShow == true }
    end

    if not IsDuplicityVersion() then
        exports[RESOURCE]:CreateNotification(notification)
        return true
    end

    local target = tonumber(source or data.source or data.src)
    if not target or target <= 0 then
        Sky.Debug("error", "17mov_Phone SendPhoneAppNotification called on the server without a valid target source.")
        return false
    end

    exports[RESOURCE]:SendNotificationToSrc(target, notification)
    return true
end

function Sky.Functions.GetPhoneNumber(source)
    if IsDuplicityVersion() then
        return exports[RESOURCE]:GetNumberFromPlayer(source)
    end
    return exports[RESOURCE]:GetPlayerNumber()
end

function Sky.Functions.GetSourceFromNumber(phoneNumber)
    if not phoneNumber then return nil end
    return exports[RESOURCE]:GetPlayerSrcFromActiveNumber(phoneNumber)
end

function Sky.Functions.HasAirplaneMode(phoneNumber)
    local settings = exports[RESOURCE]:GetPhoneSettings(phoneNumber)
    return settings ~= nil and settings.planemode == true
end

if not IsDuplicityVersion() then
    RegisterNetEvent("17mov_Phone:Client:Ready", function()
        for _, appData in pairs(registeredApps) do
            exports[RESOURCE]:AddApplication(appData)
        end
    end)

    RegisterNetEvent("17mov_Phone:Client:AppStateChanged", function(appName, state)
        -- 17mov_Phone does not document the exact AppStateChanged state values; log the real
        -- token (debug only) so the open-state match below can be confirmed on a live server.
        Sky.Debug("debug", ("17mov_Phone AppStateChanged: app=%s state=%s (%s)"):format(tostring(appName), tostring(state), type(state)))

        local opened = state == true or state == "open" or state == "opened" or state == "focus" or state == "focused"
        if opened and appOpenHandlers[appName] then
            appOpenHandlers[appName]()
        end
    end)
end
