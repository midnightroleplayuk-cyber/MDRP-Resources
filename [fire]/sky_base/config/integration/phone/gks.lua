if Sky.Config.phone ~= "gks" then return end

local RESOURCE = "gksphone"

-- GKS V2 documents connection state through its local server lifecycle.
local service_calls = {}

function Sky.Functions.GetPhoneCallCapabilities()
    local enabled = IsDuplicityVersion() and GetResourceState(RESOURCE) == "started"
    return { provider = "gks", observe = enabled, poll = IsDuplicityVersion(), answer = false,
        finish = enabled, decline = false, availability = false }
end

function Sky.Functions.GetPhoneCall(source, call_id)
    if not IsDuplicityVersion() then return nil, "server_only" end
    if GetResourceState(RESOURCE) ~= "started" then return nil, "phone_unavailable" end
    if source ~= nil then
        local participating, current_id = exports[RESOURCE]:IsInCall(source)
        if not participating or call_id and current_id ~= call_id then return nil, "call_not_found" end
        call_id = current_id
    end
    local call = exports[RESOURCE]:GetCall(call_id)
    if not call then return nil, "call_not_found" end
    local lifecycle = service_calls[call_id]
    if not lifecycle then return nil, "call_not_observed" end
    local incoming = source ~= nil and lifecycle.targetSource == source
    if source ~= nil and not incoming and lifecycle.callerSource ~= source then return nil, "call_not_found" end
    local anonymous = call.is_anonymous ~= false
    return { id = call_id, provider = "gks", state = lifecycle.state,
        direction = incoming and "incoming" or "outgoing", serviceCall = true,
        anonymous = anonymous,
        number = anonymous and "" or (incoming and lifecycle.callerNumber or lifecycle.targetNumber),
        companyId = lifecycle.company, job = lifecycle.company,
        recipientSource = lifecycle.state == "connected" and lifecycle.targetSource or nil }
end

function Sky.Functions.ControlPhoneCall(source, call_id, action)
    if action ~= "finish" then return { success = false, error = "unsupported_call_action" } end
    local call, error_code = Sky.Functions.GetPhoneCall(source, call_id)
    if not call or not call.serviceCall or call.direction ~= "incoming" or call.state ~= "connected" then
        return { success = false, error = error_code or "call_not_found" }
    end
    exports[RESOURCE]:EndCall(source)
    local current = Sky.Functions.GetPhoneCall(source, call_id)
    return { success = current == nil, error = current and "call_busy" or nil }
end

if IsDuplicityVersion() then
    for event_name, state in pairs({
        ["gksphone:calls:newCall"] = "ringing",
        ["gksphone:calls:callAnswered"] = "connected",
        ["gksphone:calls:callEnded"] = "ended"
    }) do
        AddEventHandler(event_name, function(call)
            if not call.company or call.isBusy or call.isJobCall == false then return end
            if state == "ended" then
                service_calls[call.callId] = nil
            else
                service_calls[call.callId] = {
                    state = state, callerSource = call.callerSource, targetSource = call.targetSource,
                    callerNumber = call.callerNumber, targetNumber = call.targetNumber,
                    company = call.company
                }
            end
            if call.targetSource then TriggerEvent("sky_base:phone:callChanged", call.targetSource, call.callId, state) end
        end)
    end
    AddEventHandler("onResourceStop", function(resource)
        if resource == "gksphone" then service_calls = {} end
    end)
end

function Sky.Functions.GetPhoneTrackingCapabilities()
    return { phoneNumber = true, socialMedia = false }
end

local function append_query(url, key, value)
    local separator = url:find("?", 1, true) and "&" or "?"
    return ("%s%s%s=%s"):format(url, separator, key, tostring(value))
end

local function build_cfx_nui_url(resource, path)
    if path:find("^https?://") then
        return path
    end

    if path:find("^nui://") then
        return path:gsub("^nui://([^/]+)/", "https://cfx-nui-%1/")
    end

    path = path:gsub("^" .. resource .. "/", "")
    return ("https://cfx-nui-%s/%s"):format(resource, path)
end

local function build_gks_phone_url(app)
    local resource = app.resource or GetCurrentResourceName()
    local url = app.url or build_cfx_nui_url(resource, app.uiPath or app.ui or "source/html/index.html")

    if app.route and not url:find("skyPhoneRoute=", 1, true) then
        url = append_query(url, "skyPhoneRoute", app.route)
    end

    if not url:find("skyPhone=", 1, true) then
        url = append_query(url, "skyPhone", "gks")
    end

    return url
end

local function build_label_langs(app)
    if app.labelLangs then
        return app.labelLangs
    end

    local labelLangs = {}
    for _, language in ipairs({
        "af", "ar", "cs", "de", "en", "es", "fr", "id", "nl", "pt-PT", "ro", "sv", "th", "tr", "uk", "zh-TW"
    }) do
        labelLangs[language] = app.name
    end

    return labelLangs
end

function Sky.Functions.ChangeNumber(src, newNumber)
    exports[RESOURCE]:NumberChange(src, newNumber)
end

function Sky.Functions.IsNumberUsed(phoneNumber)
    local result = Sky.Query('SELECT * FROM users WHERE phone_number = ?', { phoneNumber })
    if result[1] then
        return true
    else
        return false
    end
end

function Sky.Functions.RegisterCustomPhoneApp(app)
    local resource = app.resource or GetCurrentResourceName()
    local result, reason = exports[RESOURCE]:AddCustomApp({
        name = app.identifier,
        icons = build_cfx_nui_url(resource, app.gksIcon or app.icon or "icon.png"),
        description = app.description or "",
        categori = app.category or "mix",
        appurl = build_gks_phone_url(app),
        url = "/customapp",
        blockedjobs = app.disallowJobs or {},
        allowjob = app.allowJobs or {},
        signal = app.signal == true,
        show = app.show ~= false,
        startapp = app.defaultApp == true,
        labelLangs = build_label_langs(app),
        onOpen = app.onOpen,
        onClose = app.onClose
    })

    if result == false then
        return false, reason
    end

    return true, result
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    if IsDuplicityVersion() then
        Sky.Debug("error", "GKSPHONE custom app messages must be sent from the client.")
        return false
    end

    return exports[RESOURCE]:NuiSendMessage(data or {})
end

function Sky.Functions.SendPhoneAppNotification(data, source)
    data = data or {}

    local notification = {
        title = data.title or data.appTitle or data.app or data.identifier or "App",
        message = data.content or data.message or data.text or "",
        icon = data.icon,
        duration = math.max(1000, math.floor(tonumber(data.duration) or 5000)),
        type = data.type or "info",
        buttonactive = data.buttonactive == true,
        button = data.button
    }

    if not IsDuplicityVersion() then
        return exports[RESOURCE]:Notification(notification)
    end

    local target = tonumber(source or data.source or data.src)
    if not target or target <= 0 then
        Sky.Debug("error", "GKSPHONE SendPhoneAppNotification called without a valid target source.")
        return false
    end

    return exports[RESOURCE]:sendNotification(target, notification)
end

function Sky.Functions.GetSourceFromNumber(phoneNumber)
    if not phoneNumber then return nil end
    return exports[RESOURCE]:GetSourceByPhone(phoneNumber)
end

function Sky.Functions.HasAirplaneMode(phoneNumber)
    return exports[RESOURCE]:CheckFlightMode()
end

if not IsDuplicityVersion() then
    function Sky.Functions.SetPhoneInputFocus(focused)
        exports[RESOURCE]:InputChange(focused)
        return true
    end
end
