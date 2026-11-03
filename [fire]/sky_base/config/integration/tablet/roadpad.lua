if Sky.Config.tablet ~= "roadpad" then return end

local RESOURCE = "roadpad"

local custom_apps = {}

local function url_encode(value)
    return tostring(value):gsub("\n", "\r\n"):gsub("([^%w%-_%.~])", function(character)
        return ("%%%02X"):format(string.byte(character))
    end)
end

local function append_query(url, key, value)
    local separator = url:find("?", 1, true) and "&" or "?"
    return ("%s%s%s=%s"):format(url, separator, key, url_encode(value))
end

local function build_road_tablet_url(app)
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

    if app.route then
        url = append_query(url, "skyTabletRoute", app.route)
    end

    return append_query(url, "skyTablet", "roadpad")
end

local function build_road_tablet_app_config(app)
    return {
        name = app.name,
        icon = app.roadTabletIcon or app.externalIcon or app.icon,
        default = app.defaultApp == true,
        category = app.category or "apps",
        custom_app_id = app.identifier,
        redirect = "custom_app",
        url = build_road_tablet_url(app),
        darkmode = app.darkmode == true,
        allowJobs = app.allowJobs or {},
        disallowJobs = app.disallowJobs or {},
        custom_event = app.custom_event or app.customEvent or {
            active = false,
            closeWhenOpenApp = false
        }
    }
end

local function send_road_tablet_notification(data)
    TriggerEvent("roadpad:sendNotification", {
        apptitle = data.apptitle or data.appTitle or data.app or data.identifier or "App",
        title = data.title or "",
        message = data.content or data.message or data.text or "",
        img = data.img or data.icon
    })
    return true
end

function Sky.Functions.RegisterCustomTabletApp(app)
    if type(app) ~= "table" or type(app.identifier) ~= "string" or app.identifier == "" then
        return false, "invalid_app"
    end
    local appConfig = build_road_tablet_app_config(app)

    custom_apps[appConfig.custom_app_id] = appConfig

    return true, appConfig
end

function Sky.Functions.RemoveCustomTabletApp(identifier)
    if type(identifier) ~= "string" or identifier == "" then
        return false, "invalid_app"
    end
    local existed = custom_apps[identifier] ~= nil
    custom_apps[identifier] = nil
    return existed
end

function Sky.Functions.SendCustomTabletAppMessage(identifier, event, data)
    if IsDuplicityVersion() then
        return false, "client_only"
    end
    return false, "unsupported_provider_api"
end

function Sky.Functions.SendTabletAppNotification(data, source)
    data = data or {}

    if IsDuplicityVersion() then
        local target = tonumber(source or data.source or data.src)
        if not target or target <= 0 then
            return false
        end

        TriggerClientEvent("sky_base:roadpad:sendNotification", target, data)
        return true
    end

    return send_road_tablet_notification(data)
end

function Sky.Functions.CloseExternalTablet()
    if IsDuplicityVersion() then
        return false, "client_only"
    end
    return exports[RESOURCE]:closeTablet()
end

if not IsDuplicityVersion() then
    RegisterNetEvent("sky_base:roadpad:sendNotification", function(data)
        Sky.Functions.SendTabletAppNotification(data)
    end)
end
