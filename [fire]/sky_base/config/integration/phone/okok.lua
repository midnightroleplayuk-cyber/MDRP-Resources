if Sky.Config.phone ~= "okok" then return end

local RESOURCE = "okokPhone"

function Sky.Functions.GetPhoneTrackingCapabilities()
    return { phoneNumber = true, socialMedia = false }
end

local function append_query(url, key, value)
    local separator = url:find("?", 1, true) and "&" or "?"
    return ("%s%s%s=%s"):format(url, separator, key, tostring(value))
end

local function build_cfx_nui_url(resource, path)
    if type(path) ~= "string" or path == "" then
        return nil
    end

    if path:find("^https?://") then
        return path
    end

    if path:find("^nui://") then
        return path:gsub("^nui://([^/]+)/", "https://cfx-nui-%1/")
    end

    path = path:gsub("^" .. resource .. "/", "")
    return ("https://cfx-nui-%s/%s"):format(resource, path)
end

local function build_okok_phone_url(app)
    local resource = app.resource or GetCurrentResourceName()
    local url = app.url or build_cfx_nui_url(resource, app.uiPath or app.ui or "source/html/index.html")

    if app.route then
        url = append_query(url, "skyPhoneRoute", app.route)
    end

    return append_query(url, "skyPhone", "okok")
end

local function build_okok_phone_icon(app)
    local resource = app.resource or GetCurrentResourceName()
    return build_cfx_nui_url(resource, app.okokIcon or app.icon or "icon.png")
end

function Sky.Functions.ChangeNumber(src, newNumber)
    Sky.DB.SetValue("okokphone_phones", "phone_number", newNumber, "owner", Sky.FW.GetIdentifier(src))
    TriggerClientEvent("sky_base:notification", src, "Phone", "Your phone number has been changed. Please relog.", "warn", 10000)
end

function Sky.Functions.IsNumberUsed(phoneNumber)
    local result = Sky.Query('SELECT COUNT(*) as count FROM okokphone_phones WHERE phone_number = ?', { phoneNumber })
    if result[1] and result[1].count > 0 then
        return true
    else
        return false
    end
end

function Sky.Functions.RegisterCustomPhoneApp(app)
    if GetResourceState(RESOURCE) ~= "started" then
        return false, "okokPhone not started"
    end

    local appData = {
        id = app.identifier,
        label = app.name,
        description = app.description,
        custom = true,
        icon = build_okok_phone_icon(app),
        previewImagesCount = math.max(0, math.floor(tonumber(app.previewImagesCount) or 0)),
        notifications = app.notification ~= false and true or false,
        resourceName = GetCurrentResourceName(),
        webUrl = build_okok_phone_url(app)
    }

    local ok, result = pcall(function()
        return exports[RESOURCE]:loadApp(appData)
    end)
    if not ok then
        return false, result
    end

    if type(result) == "boolean" then
        return result
    end

    return true, result
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    SendNUIMessage(data or {})
end

function Sky.Functions.SendPhoneAppNotification(data, source)
    data = data or {}

    local notification = {
        title = data.title or data.appTitle or data.app or data.identifier or "App",
        text = data.content or data.message or data.text or "",
        app = data.app or data.identifier,
        icon = data.icon,
        duration = math.max(1000, math.floor(tonumber(data.duration) or 3000))
    }

    if IsDuplicityVersion() then
        local target = tonumber(source or data.source or data.src)
        if not target or target <= 0 then
            return false
        end

        TriggerClientEvent("okokPhone:client:NotifyDI", target, notification)
        return true
    end

    TriggerEvent("okokPhone:client:NotifyDI", notification)
    return true
end

function Sky.Functions.GetPhoneNumber(source)
    if not IsDuplicityVersion() then return nil end
    local rows = Sky.Query(
        "SELECT `phone_number` FROM `okokphone_phones` WHERE `owner` = ? LIMIT 1",
        { Sky.FW.GetIdentifier(source) }
    ) or {}
    return rows[1] and rows[1].phone_number or nil
end

function Sky.Functions.GetSourceFromNumber(phoneNumber)
    if not phoneNumber then return nil end
    return exports[RESOURCE]:getSourceFromPhoneNumber(phoneNumber)
end

function Sky.Functions.HasAirplaneMode(phoneNumber)
    return LocalPlayer.state['okokPhone:airplaneMode']
end
