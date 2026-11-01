if Sky.Config.phone ~= "lb" and Sky.Config.phone ~= "lb-unique" then return end

local RESOURCE = "lb-phone"

-- Both LB inventory modes use the same authoritative server call API.
function Sky.Functions.GetPhoneCallCapabilities()
    local enabled = IsDuplicityVersion() and GetResourceState(RESOURCE) == "started"
    return { provider = Sky.Config.phone, observe = enabled, poll = IsDuplicityVersion(),
        answer = false, finish = enabled, decline = false, availability = false }
end

function Sky.Functions.GetPhoneCall(source, call_id)
    if not IsDuplicityVersion() then return nil, "server_only" end
    if GetResourceState(RESOURCE) ~= "started" then return nil, "phone_unavailable" end
    local call
    if source == nil then
        call = exports[RESOURCE]:GetCall(call_id)
    else
        local participating, current_id, current_call = exports[RESOURCE]:IsInCall(source)
        if not participating or call_id and current_id ~= call_id then return nil, "call_not_found" end
        call = current_call
    end
    if not call then return nil, "call_not_found" end
    local caller, callee = call.caller or {}, call.callee or {}
    local incoming = source ~= nil and caller.source ~= source
    if incoming and (call.answered or not call.company) and callee.source ~= source then
        return nil, "call_not_found"
    end
    return { id = call.callId, provider = Sky.Config.phone,
        state = call.answered and "connected" or "ringing",
        direction = incoming and "incoming" or "outgoing", serviceCall = call.company ~= nil,
        anonymous = call.hideCallerId == true,
        number = call.hideCallerId and "" or (incoming and caller.number or callee.number),
        companyId = call.company, job = call.company,
        recipientSource = call.answered and callee.source or nil }
end

function Sky.Functions.ControlPhoneCall(source, call_id, action)
    if action ~= "finish" then return { success = false, error = "unsupported_call_action" } end
    local call, error_code = Sky.Functions.GetPhoneCall(source, call_id)
    if not call or not call.serviceCall or call.direction ~= "incoming" or call.state ~= "connected" then
        return { success = false, error = error_code or "call_not_found" }
    end
    local ended = exports[RESOURCE]:EndCall(source)
    local current = Sky.Functions.GetPhoneCall(source, call_id)
    return { success = ended == true and current == nil, error = current and "call_busy" or nil }
end

if IsDuplicityVersion() then
    for _, event_name in ipairs({ "lb-phone:newCall", "lb-phone:callAnswered", "lb-phone:callEnded" }) do
        AddEventHandler(event_name, function(call)
            if call.company and call.callee and call.callee.source then
                TriggerEvent("sky_base:phone:callChanged", call.callee.source, call.callId)
            end
        end)
    end
end

if Sky.Config.phone ~= "lb" then return end

function Sky.Functions.GetPhoneTrackingCapabilities()
    return { phoneNumber = true, socialMedia = true }
end

local socialMediaTrackingPlatforms = {
    "twitter",
    "instagram",
    "tiktok",
    "darkchat",
    "tinder"
}

local socialMediaTrackingQueries = {
    twitter = 'SELECT `phone_number` FROM `phone_twitter_accounts` WHERE `username` = ? LIMIT 1',
    instagram = 'SELECT `phone_number` FROM `phone_instagram_accounts` WHERE `username` = ? LIMIT 1',
    tiktok = 'SELECT `phone_number` FROM `phone_tiktok_accounts` WHERE `username` = ? LIMIT 1',
    darkchat = 'SELECT `phone_number` FROM `phone_darkchat_accounts` WHERE `username` = ? LIMIT 1',
    tinder = 'SELECT `phone_number` FROM `phone_tinder_accounts` WHERE `name` = ? LIMIT 1'
}

function Sky.Functions.GetSocialMediaTrackingPlatforms()
    local platforms = {}
    for index = 1, #socialMediaTrackingPlatforms do
        platforms[index] = socialMediaTrackingPlatforms[index]
    end
    return platforms
end

function Sky.Functions.ResolveSocialMediaPhoneNumber(platform, username)
    if not IsDuplicityVersion() then
        return nil, "server_only"
    end

    platform = type(platform) == "string" and platform:match("^%s*(.-)%s*$"):lower() or nil
    local query = platform and socialMediaTrackingQueries[platform] or nil
    if not query then
        return nil, "unsupported_platform"
    end

    username = type(username) == "string" and username:match("^%s*(.-)%s*$") or nil
    if not username or username == "" then
        return nil, "invalid_username"
    end

    local result = Sky.Query(query, { username }) or {}
    local phoneNumber = result[1] and result[1].phone_number
    if phoneNumber == nil then
        return nil, "not_found"
    end

    return tostring(phoneNumber)
end

function Sky.Functions.ChangeNumber(src, newNumber)
    Sky.DB.SetValue("phone_phones", "phone_number", newNumber, "owner_id", Sky.FW.GetIdentifier(src))
    TriggerClientEvent("sky_base:notification", src, "Phone", "Your phone number has been changed", "success")
end

function Sky.Functions.IsNumberUsed(phoneNumber)
    local result = Sky.Query('SELECT COUNT(*) as count FROM phone_phones WHERE phone_number = ?', { phoneNumber })
    if result[1] and result[1].count > 0 then
        return true
    else
        return false
    end
end

function Sky.Functions.RegisterCustomPhoneApp(app)
    local payload = {
        identifier = app.identifier,
        name = app.name,
        description = app.description,
        developer = app.developer,
        defaultApp = app.defaultApp == true,
        size = app.size,
        icon = app.icon,
        ui = app.ui,
        fixBlur = app.fixBlur ~= false,
        onOpen = app.onOpen
    }

    return exports[RESOURCE]:AddCustomApp(payload)
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    exports[RESOURCE]:SendCustomAppMessage(identifier, data or {})
end

function Sky.Functions.RemoveCustomPhoneApp(identifier)
    if IsDuplicityVersion() then return false, "client_only" end
    return exports[RESOURCE]:RemoveCustomApp(identifier)
end

function Sky.Functions.SendPhoneAppNotification(data)
    return exports[RESOURCE]:SendNotification({
        app = data.app or data.identifier,
        title = data.title,
        content = data.content or data.message or data.text
    })
end

function Sky.Functions.GetPhoneNumber(source)
    if IsDuplicityVersion() then
        return exports[RESOURCE]:GetEquippedPhoneNumber(source)
    end
    return exports[RESOURCE]:GetEquippedPhoneNumber()
end

function Sky.Functions.RegisterCustomPhoneNumber(number, handler)
    if IsDuplicityVersion() then return false, "client_only" end
    return exports[RESOURCE]:CreateCustomNumber(number, {
        onCall = function(call)
            call.deny()
            handler(number)
        end
    })
end

function Sky.Functions.RemoveCustomPhoneNumber(number)
    if IsDuplicityVersion() then return false end
    return exports[RESOURCE]:RemoveCustomNumber(number)
end

function Sky.Functions.OpenCustomPhoneApp(identifier, data)
    if IsDuplicityVersion() then return false end
    exports[RESOURCE]:OpenApp(identifier, data)
    return true
end

function Sky.Functions.GetSourceFromNumber(phoneNumber)
    if not phoneNumber then return nil end
    return exports[RESOURCE]:GetSourceFromNumber(phoneNumber)
end

function Sky.Functions.HasAirplaneMode(phoneNumber)
    return exports[RESOURCE]:HasAirplaneMode(phoneNumber)
end
