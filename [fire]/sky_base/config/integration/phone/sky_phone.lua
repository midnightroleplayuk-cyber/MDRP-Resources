if Sky.Config.phone ~= "sky" then return end

local RESOURCE = "sky_phone"

local is_server = IsDuplicityVersion()
local tracking_platforms = { "twitter", "instagram", "tiktok", "darkchat", "tinder" }

function Sky.Functions.GetPhoneNumber(source)
    if is_server then
        return exports[RESOURCE]:GetEquippedPhoneNumber(source)
    end
    return exports[RESOURCE]:GetEquippedPhoneNumber()
end

function Sky.Functions.GetPhoneTrackingCapabilities()
    return { phoneNumber = true, socialMedia = true }
end

function Sky.Functions.GetSocialMediaTrackingPlatforms()
    return { table.unpack(tracking_platforms) }
end

if not is_server then return end

local tracking_profiles = {
    twitter = { table = "feather", field = "handle" },
    instagram = { table = "picstagram", field = "handle", sessions = true },
    tiktok = { table = "fliptok", field = "handle", sessions = true },
    darkchat = { table = "darkchat", field = "dark_id" },
    tinder = { table = "flare", field = "name" }
}

function Sky.Functions.ResolveSocialMediaPhoneNumber(platform, username)
    platform = type(platform) == "string" and platform:match("^%s*(.-)%s*$"):lower() or nil
    local profile = tracking_profiles[platform]
    if not profile then return nil, "unsupported_platform" end

    username = type(username) == "string" and username:match("^%s*(.-)%s*$") or nil
    if not username or username == "" then return nil, "invalid_username" end

    -- Table/column identifiers come only from the fixed provider map above.
    local device_join = profile.sessions and ([[
        JOIN `sky_phone_%s_sessions` ps ON ps.`profile_id` = p.`id`
        JOIN `sky_phone_devices` d ON d.`imei` = ps.`device_imei`
    ]]):format(profile.table) or "JOIN `sky_phone_devices` d ON d.`account_id` = p.`account_id`"
    local rows = Sky.Query(([[
        SELECT s.`phone_number` FROM `sky_phone_%s_profiles` p
        %s
        JOIN `sky_phone_sims` s ON s.`id` = d.`sim_id`
        WHERE p.`%s` = ?
        ORDER BY %s.`updated_at` DESC LIMIT 1
    ]]):format(profile.table, device_join, profile.field, profile.sessions and "ps" or "d"), { username })
    local phone_number = rows[1] and rows[1].phone_number
    if phone_number == nil then return nil, "not_found" end
    return tostring(phone_number)
end

function Sky.Functions.ValidateNumberChange(source, new_number)
    if GetResourceState(RESOURCE) ~= "started" then return false, "api_not_ready" end

    local api = exports[RESOURCE]:GetApiCapabilities()
    if not api.ready then return false, "api_not_ready" end
    if not api.features.phoneNumberValidation then return false, "unsupported_phone" end
    return exports[RESOURCE]:ValidatePhoneNumberChange(source, new_number)
end

function Sky.Functions.ChangeNumber(source, new_number)
    local api = exports[RESOURCE]:GetApiCapabilities()
    if not api.ready then return false, "api_not_ready" end
    if not api.features.phoneNumberChange then
        Sky.Debug("error", "sky_phone must be updated to a version exposing ChangePhoneNumber.")
        return false, "unsupported_phone"
    end

    local changed, number_or_error = exports[RESOURCE]:ChangePhoneNumber(source, new_number)
    if not changed then
        Sky.Debug("error", "sky_phone number change failed: %s.", tostring(number_or_error))
    end
    return changed == true, number_or_error
end

function Sky.Functions.IsNumberUsed(phone_number)
    local sim, lookup_error = exports[RESOURCE]:GetStoredSimByPhoneNumber(phone_number)
    if lookup_error == "api_not_ready" then
        error("sky_phone number check failed because its server API is not ready")
    end
    return sim ~= nil
end

function Sky.Functions.GetSourceFromNumber(phone_number)
    return exports[RESOURCE]:GetSourceFromPhoneNumber(phone_number)
end

function Sky.Functions.HasAirplaneMode(phone_number)
    local device, lookup_error = exports[RESOURCE]:GetStoredDeviceByPhoneNumber(phone_number)
    if lookup_error == "api_not_ready" then
        error("sky_phone airplane-mode lookup failed because its server API is not ready")
    end
    if not device then return false end

    local rows = Sky.Query([[
        SELECT `payload` FROM `sky_phone_device_data`
        WHERE `device_imei` = ? AND `namespace` = 'settings' LIMIT 1
    ]], { device.imei })
    local payload = rows[1] and json.decode(rows[1].payload)
    return payload and payload.settings and payload.settings.airplaneMode == true or false
end

function Sky.Functions.SendPhoneAppNotification(data, source)
    if type(data) ~= "table" then return false, "invalid_notification" end
    local target = tonumber(source or data.source or data.src)
    if not target or target <= 0 then
        Sky.Debug("error", "sky_phone SendPhoneAppNotification called without a valid target source.")
        return false, "invalid_source"
    end
    TriggerClientEvent("sky_base:sky_phone:sendNotification", target, data)
    return true
end

function Sky.Functions.GetPhoneCallCapabilities()
    local controls = false
    if GetResourceState(RESOURCE) == "started" then
        local api = exports[RESOURCE]:GetApiCapabilities()
        controls = api.ready and api.features.calls.externalControl == true
    end
    return { provider = "sky", observe = controls, poll = false, answer = controls,
        finish = controls, decline = controls, availability = controls }
end

function Sky.Functions.GetPhoneCall(source, call_id)
    if GetResourceState(RESOURCE) ~= "started" then return nil, "phone_unavailable" end
    local call, error_code
    if source == nil then
        call, error_code = exports[RESOURCE]:GetActiveCallById(call_id)
    else
        call, error_code = exports[RESOURCE]:GetActiveCallBySource(source)
    end
    if not call or call_id and call.id ~= call_id then return nil, error_code or "call_not_found" end
    return {
        id = call.id,
        provider = "sky",
        state = call.state,
        direction = call.direction,
        serviceCall = call.serviceCall,
        anonymous = call.anonymous,
        number = call.anonymous and "" or call.otherNumber,
        companyId = call.companyId,
        recipientSource = call.state == "connected" and call.callee.source or nil
    }
end

function Sky.Functions.ControlPhoneCall(source, call_id, action)
    local capabilities = Sky.Functions.GetPhoneCallCapabilities()
    if not capabilities[action == "accept" and "answer" or action] then
        Sky.Debug("warn", "sky_phone does not expose the requested authoritative call action: %s.", tostring(action))
        return { success = false, error = "unsupported_phone" }
    end
    local call, error_code = Sky.Functions.GetPhoneCall(source, call_id)
    if not call or call.direction ~= "incoming" or not call.serviceCall then
        return { success = false, error = error_code or "call_not_found" }
    end
    if action == "accept" then
        if call.state == "connected" then return { success = true, data = call } end
        local result, answer_error = exports[RESOURCE]:AnswerCallForSource(source, { id = call_id })
        return result or { success = false, error = answer_error }
    end
    if action == "finish" then
        local success, end_error = exports[RESOURCE]:EndCallForSource(source)
        return { success = success == true, error = end_error }
    end
    return { success = false, error = "unsupported_call_action" }
end

function Sky.Functions.SetPhoneDispatchAvailability(source, enabled)
    if not Sky.Functions.GetPhoneCallCapabilities().availability then
        return { success = false, error = "unsupported_phone" }
    end
    local result, error_code = exports[RESOURCE]:SetCallAvailabilityForSource(source, { available = enabled, dispatcher = enabled })
    return result or { success = false, error = error_code }
end

if GetCurrentResourceName() == "sky_base" then
    AddEventHandler("sky_phone:server:apiReady", function()
        TriggerEvent("sky_base:phone:ready")
    end)
    AddEventHandler("onServerResourceStart", function(resource_name)
        if resource_name == "sky_phone" and Sky.Functions.GetPhoneCallCapabilities().availability then
            TriggerEvent("sky_base:phone:ready")
        end
    end)
    AddEventHandler("sky_phone:server:callChanged", function(source, call)
        if call.serviceCall and call.direction == "incoming" then
            TriggerEvent("sky_base:phone:callChanged", source, call.id, call.state)
        end
    end)
end
