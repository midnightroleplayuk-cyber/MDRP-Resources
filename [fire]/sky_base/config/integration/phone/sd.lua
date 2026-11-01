if Sky.Config.phone ~= "sd" then return end

local RESOURCE = "sd-phone"

-- Lifecycle payloads supply the actual recipients; the public getter proves liveness.
local service_calls = {}

function Sky.Functions.GetPhoneCallCapabilities()
    local enabled = IsDuplicityVersion() and GetResourceState(RESOURCE) == "started"
    return { provider = "sd", observe = enabled, poll = IsDuplicityVersion(), answer = enabled,
        finish = enabled, decline = enabled, availability = false }
end

function Sky.Functions.GetPhoneCall(source, call_id)
    if not IsDuplicityVersion() then return nil, "server_only" end
    if GetResourceState(RESOURCE) ~= "started" then return nil, "phone_unavailable" end
    local current, lifecycle
    if source ~= nil then
        current = exports[RESOURCE]:getCurrentCall(source)
        if not current or call_id and current.channel ~= call_id then return nil, "call_not_found" end
        call_id = current.channel
        lifecycle = service_calls[call_id]
    else
        lifecycle = service_calls[call_id]
        if lifecycle then
            for participant in pairs(lifecycle.participants) do
                local candidate = exports[RESOURCE]:getCurrentCall(participant)
                if candidate and candidate.channel == call_id then current = candidate; break end
            end
        end
    end
    if not lifecycle or not current then return nil, "call_not_observed" end
    local incoming = source ~= nil and lifecycle.participants[source] and lifecycle.callerSource ~= source
    if source ~= nil and not incoming and lifecycle.callerSource ~= source then return nil, "call_not_found" end
    local connected = lifecycle.state == "connected" and current.phase == "active"
        and (source == nil or lifecycle.calleeSource == source or lifecycle.callerSource == source)
    return { id = call_id, provider = "sd", state = connected and "connected" or "ringing",
        direction = incoming and "incoming" or "outgoing", serviceCall = true,
        -- SD's public payload omits the withheld flag and may contain the real caller number.
        -- Do not publish that number without an authoritative caller-ID visibility contract.
        anonymous = false, number = "", companyId = lifecycle.companyId, job = lifecycle.companyId,
        recipientSource = connected and lifecycle.calleeSource or nil }
end

function Sky.Functions.ControlPhoneCall(source, call_id, action)
    if action ~= "accept" and action ~= "finish" then return { success = false, error = "unsupported_call_action" } end
    local call, error_code = Sky.Functions.GetPhoneCall(source, call_id)
    if not call or not call.serviceCall or call.direction ~= "incoming" then
        return { success = false, error = error_code or "call_not_found" }
    end
    if action == "finish" then
        local result = exports[RESOURCE]:endCallFor(source)
        local current = Sky.Functions.GetPhoneCall(source, call_id)
        return { success = result.success == true and current == nil, error = current and "call_busy" or nil }
    end
    if call.state == "connected" then return { success = true, data = call } end
    local response = Sky.Cb.TriggerWithTimeout("sky_base:phone:sd:answer", source, 15000, call_id)
    local current = Sky.Functions.GetPhoneCall(source, call_id)
    if current and current.state == "connected" then return { success = true, data = current } end
    Sky.Debug("warn", "sd-phone did not confirm the requested call connection for source %s and channel %s.", source, call_id)
    return { success = false, error = response and response.error or "voice_unavailable" }
end

if IsDuplicityVersion() then
    for event_name, state in pairs({
        ["sd-phone:server:call:started"] = "ringing",
        ["sd-phone:server:call:answered"] = "connected",
        ["sd-phone:server:call:ended"] = "ended"
    }) do
        AddEventHandler(event_name, function(call)
            -- Fake rings have no real caller. Company labels must map uniquely to a job.
            if not call.company or not call.caller or not call.caller.source then return end
            local previous = service_calls[call.channel]
            local participants = { [call.caller.source] = true }
            if call.callee and call.callee.source then participants[call.callee.source] = true end
            for _, target in ipairs(call.targets or {}) do
                if target.source then participants[target.source] = true end
            end
            if state == "ended" then
                service_calls[call.channel] = nil
            else
                service_calls[call.channel] = nil
                local company_id
                for _, company in ipairs(exports[RESOURCE]:getCompanyDirectory()) do
                    if company.name == call.company then
                        if company_id then
                            Sky.Debug("error", "sd-phone company label %s maps to multiple jobs; call %s cannot be routed.", call.company, call.channel)
                            return
                        end
                        company_id = company.id
                    end
                end
                if not company_id then
                    Sky.Debug("warn", "sd-phone company label %s has no directory job for call %s.", call.company, call.channel)
                    return
                end
                service_calls[call.channel] = { state = state, companyId = company_id,
                    callerSource = call.caller.source, calleeSource = call.callee and call.callee.source,
                    participants = participants }
            end
            for participant in pairs(previous and previous.participants or {}) do participants[participant] = true end
            for participant in pairs(participants) do
                TriggerEvent("sky_base:phone:callChanged", participant, call.channel, state)
            end
        end)
    end
    AddEventHandler("onResourceStop", function(resource)
        if resource == "sd-phone" then service_calls = {} end
    end)
end

function Sky.Functions.GetPhoneTrackingCapabilities()
    return { phoneNumber = true, socialMedia = false }
end

function Sky.Functions.ChangeNumber()
    Sky.Debug("error", "sd-phone does not support changing an assigned phone number.")
    return false
end

function Sky.Functions.IsNumberUsed(phone_number)
    if not IsDuplicityVersion() then
        Sky.Debug("error", "sd-phone number checks are only available on the server.")
        return false
    end

    return exports[RESOURCE]:isNumberInService(phone_number)
end

function Sky.Functions.RegisterCustomPhoneApp(app)
    if IsDuplicityVersion() then
        return false, "client_only"
    end

    local payload = {
        identifier = app.identifier,
        name = app.name,
        description = app.description,
        developer = app.developer,
        defaultApp = app.defaultApp == true,
        devices = "phone",
        job = app.job or app.jobs,
        ui = app.ui or app.uiPath or app.url,
        icon = app.icon,
        images = app.images,
        size = app.size,
        price = app.price,
        fixBlur = app.fixBlur,
        onOpen = app.onOpen or app.onUse,
        onClose = app.onClose,
        onDelete = app.onDelete or app.onUninstall
    }

    return exports[RESOURCE]:addCustomApp(payload)
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    if IsDuplicityVersion() then
        return false, "client_only"
    end

    return exports[RESOURCE]:sendCustomAppMessage(identifier, data or {})
end

function Sky.Functions.SendPhoneAppNotification(data, source)
    data = data or {}
    local payload = {
        app = data.app or data.identifier,
        image = data.image or data.icon,
        title = data.title,
        body = data.body or data.content or data.message or data.text,
        time = data.time,
        appId = data.appId or data.app or data.identifier
    }

    if IsDuplicityVersion() then
        local target = tonumber(source or data.source or data.src)
        if not target or target <= 0 then
            Sky.Debug("error", "sd-phone SendPhoneAppNotification called without a valid target source.")
            return false
        end

        return exports[RESOURCE]:notify(target, payload)
    end

    return exports[RESOURCE]:showNotification(payload)
end

function Sky.Functions.GetPhoneNumber(source)
    if not IsDuplicityVersion() then
        Sky.Debug("error", "sd-phone only exposes phone-number lookup on the server.")
        return nil
    end

    return exports[RESOURCE]:getPhoneNumber(source)
end

function Sky.Functions.RegisterCustomPhoneNumber()
    return false, "unsupported_phone"
end

function Sky.Functions.RemoveCustomPhoneNumber()
    return false
end

function Sky.Functions.OpenCustomPhoneApp(identifier, data)
    if IsDuplicityVersion() then return false end
    return exports[RESOURCE]:openApp(identifier, data)
end

function Sky.Functions.GetSourceFromNumber(phone_number)
    if not IsDuplicityVersion() then
        Sky.Debug("error", "sd-phone source lookup is only available on the server.")
        return nil
    end

    return exports[RESOURCE]:getSourceByNumber(phone_number)
end

function Sky.Functions.HasAirplaneMode(phone_number)
    if not IsDuplicityVersion() then
        Sky.Debug("error", "sd-phone airplane-mode lookup is only available on the server.")
        return false
    end

    local source = exports[RESOURCE]:getSourceByNumber(phone_number)
    if not source then return false end
    return exports[RESOURCE]:isAirplaneMode(source)
end
