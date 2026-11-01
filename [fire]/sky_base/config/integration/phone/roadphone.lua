if Sky.Config.phone ~= "roadphone" then return end

local RESOURCE = "roadphone"

function Sky.Functions.GetPhoneTrackingCapabilities()
    return { phoneNumber = true, socialMedia = false }
end

local function append_query(url, key, value)
    local separator = url:find("?", 1, true) and "&" or "?"
    return ("%s%s%s=%s"):format(url, separator, key, tostring(value))
end

local function build_road_phone_url(app)
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
        url = append_query(url, "skyPhoneRoute", app.route)
    end

    return append_query(url, "skyPhone", "roadphone")
end

local function resolve_road_phone_app_identifier(app)
    for _, key in ipairs({ "identifier", "id", "custom_app_id" }) do
        local identifier = app[key]

        if type(identifier) == "string" then
            identifier = identifier:match("^%s*(.-)%s*$")

            if identifier ~= "" then
                return identifier
            end
        end
    end

    return nil
end

local function build_road_phone_app_config(app)
    return {
        name = app.name,
        icon = app.roadphoneIcon or app.icon,
        default = app.defaultApp == true,
        category = app.category or "apps",
        custom_app_id = resolve_road_phone_app_identifier(app),
        redirect = "custom_app",
        url = build_road_phone_url(app),
        darkmode = app.darkmode == true,
        allowJobs = app.allowJobs or {},
        disallowJobs = app.disallowJobs or {},
        custom_event = {
            active = false,
            closeWhenOpenApp = false
        }
    }
end

local function send_road_phone_notification(data)
    exports[RESOURCE]:sendNotification({
        apptitle = data.apptitle or data.appTitle or data.app or data.identifier or "App",
        title = data.title or "",
        message = data.content or data.message or data.text or "",
        img = data.img or data.icon
    })
end

function Sky.Functions.ChangeNumber(src, newNumber)
    Sky.Debug("error", "RoadPhone number changes are not supported through sky_base. Use RoadPhone admin tools.")
end

function Sky.Functions.IsNumberUsed(phoneNumber)
    Sky.Debug("error", "RoadPhone number uniqueness checks are not supported through sky_base.")
    return false
end

function Sky.Functions.RegisterCustomPhoneApp(app)
    if type(app) ~= "table" then
        Sky.Debug("error", "RoadPhone custom app registration failed: expected an app table, got %s.", type(app))
        return false, "invalid_app"
    end

    local app_config = build_road_phone_app_config(app)
    local identifier = app_config.custom_app_id

    if not identifier then
        Sky.Debug(
            "error",
            "RoadPhone custom app registration failed for '%s': set app.identifier, app.id, or app.custom_app_id.",
            tostring(app.name or app.resource or "unknown")
        )
        return false, "missing_identifier"
    end

    return true, app_config
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    local payload = {
        app = identifier,
        identifier = identifier,
        customevent = identifier,
        event = data and (data.event or data.type) or identifier,
        data = data or {}
    }

    for key, value in pairs(data or {}) do
        payload[key] = value
    end

    exports[RESOURCE]:SendMessageNUI(payload)
end

function Sky.Functions.SendPhoneAppNotification(data, source)
    data = data or {}

    if IsDuplicityVersion() then
        local target = tonumber(source or data.source or data.src)
        if not target or target <= 0 then
            return false
        end

        TriggerClientEvent("sky_base:roadphone:sendNotification", target, data)
        return true
    end

    send_road_phone_notification(data)
    return true
end

function Sky.Functions.GetPhoneNumber(source)
    if IsDuplicityVersion() then
        return exports[RESOURCE]:getNumberFromIdentifier(Sky.FW.GetIdentifier(source))
    end
    return exports[RESOURCE]:getPhoneNumber()
end

if not IsDuplicityVersion() then
    function Sky.Functions.SetPhoneInputFocus(focused)
        exports[RESOURCE]:inputFocus(focused)
        return true
    end

    RegisterNetEvent("sky_base:roadphone:sendNotification", function(data)
        Sky.Functions.SendPhoneAppNotification(data)
    end)

    -- Phone adapters load before the client callback module.
    AddEventHandler("onClientResourceStart", function(resource_name)
        if resource_name == GetCurrentResourceName() then
            Sky.Cb.Register("sky_base:roadphone:hasAirplaneMode", Sky.Functions.HasAirplaneMode)
        end
    end)
end

function Sky.Functions.GetSourceFromNumber(phoneNumber)
    if not phoneNumber then return nil end
    return exports[RESOURCE]:getSourceFromPhone(phoneNumber)
end

function Sky.Functions.HasAirplaneMode(phoneNumber)
    if not IsDuplicityVersion() then
        local flight_mode = exports[RESOURCE]:isFlightmode()
        assert(type(flight_mode) == "boolean",
            ("RoadPhone isFlightmode returned %s instead of a boolean."):format(type(flight_mode)))
        return flight_mode
    end

    local target = tonumber(Sky.Functions.GetSourceFromNumber(phoneNumber))
    if not target or target <= 0 then
        Sky.Debug("warn", "RoadPhone could not resolve an online source for the requested phone number (getSourceFromPhone).")
        return false
    end

    local flight_mode = Sky.Cb.TriggerWithTimeout("sky_base:roadphone:hasAirplaneMode", target, 5000)
    assert(type(flight_mode) == "boolean",
        ("RoadPhone flight-mode client callback returned %s for source %s. Check that this adapter is loaded on the client and inspect its F8 console."):format(type(flight_mode), target))
    return flight_mode
end
