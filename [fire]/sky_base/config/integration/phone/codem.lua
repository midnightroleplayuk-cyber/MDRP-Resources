if Sky.Config.phone ~= "codem" then return end

local RESOURCE = "codem-phone"

-- mPhone 2.5 includes pending company recipients in IsInCall.
function Sky.Functions.GetPhoneCallCapabilities()
    local enabled = IsDuplicityVersion() and GetResourceState(RESOURCE) == "started"
    return { provider = "codem", observe = enabled, poll = IsDuplicityVersion(), answer = false,
        finish = enabled, decline = false, availability = false }
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
    return { id = call.callId, provider = "codem", state = call.answered and "connected" or "ringing",
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
    local ended = exports[RESOURCE]:EndCall(call_id)
    local current = Sky.Functions.GetPhoneCall(source, call_id)
    return { success = ended == true and current == nil, error = current and "call_busy" or nil }
end

if not IsDuplicityVersion() then
    function Sky.Functions.SetPhoneInputFocus(focused)
        exports[RESOURCE]:SetInputFocus(focused)
        return true
    end
end
function Sky.Functions.GetPhoneTrackingCapabilities()
    return { phoneNumber = true, socialMedia = true }
end

local socialMediaTrackingPlatforms = {
    "twitter",
    "instagram",
    "tiktok",
    "darkchat",
    "onlyyou",
    "tinder"
}

local socialMediaTrackingQueries = {
    twitter = {
        query = 'SELECT `phone_number` FROM `codem_mphone_accounts` WHERE `appname` = ? AND `username` = ? LIMIT 1',
        appName = "twix"
    },
    instagram = {
        query = 'SELECT `phone_number` FROM `codem_mphone_accounts` WHERE `appname` = ? AND `username` = ? LIMIT 1',
        appName = "instashot"
    },
    tiktok = {
        query = 'SELECT `phone_number` FROM `codem_mphone_accounts` WHERE `appname` = ? AND `username` = ? LIMIT 1',
        appName = "toctik"
    },
    darkchat = {
        query = 'SELECT `phone_number` FROM `codem_mphone_accounts` WHERE `appname` = ? AND `username` = ? LIMIT 1',
        appName = "darkchat"
    },
    onlyyou = {
        query = 'SELECT `phone_number` FROM `codem_mphone_accounts` WHERE `appname` = ? AND `username` = ? LIMIT 1',
        appName = "onlyyou"
    },
    tinder = {
        query = 'SELECT `phone_number` FROM `codem_mphone_thunderaccount` WHERE `name` = ? LIMIT 1'
    }
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
    local queryConfig = platform and socialMediaTrackingQueries[platform] or nil
    if not queryConfig then
        return nil, "unsupported_platform"
    end

    username = type(username) == "string" and username:match("^%s*(.-)%s*$") or nil
    if not username or username == "" then
        return nil, "invalid_username"
    end

    local params = queryConfig.appName and { queryConfig.appName, username } or { username }
    local result = Sky.Query(queryConfig.query, params) or {}
    local phoneNumber = result[1] and result[1].phone_number
    if phoneNumber == nil then
        return nil, "not_found"
    end

    return tostring(phoneNumber)
end

function Sky.Functions.ChangeNumber(src, newNumber)
    Sky.DB.SetValue("codem_mphone_data", "phone_number", newNumber, "owner", Sky.FW.GetIdentifier(src))
    TriggerClientEvent("sky_base:notification", src, "Phone", "Your phone number has been changed", "success")
end

function Sky.Functions.IsNumberUsed(phoneNumber)
    local result = Sky.Query('SELECT COUNT(*) as count FROM codem_mphone_data WHERE phone_number = ?', { phoneNumber })
    if result[1] and result[1].count > 0 then
        return true
    else
        return false
    end
end

function Sky.Functions.RegisterCustomPhoneApp(app)

    local resource = app.resource or GetCurrentResourceName()
    local html = app.html

    if not html and app.uiPath then
        html = LoadResourceFile(resource, app.uiPath)
    end

    if html and app.uiPath then
        local basePath = ("nui://%s/%s"):format(resource, app.uiPath:gsub("[^/]+$", ""))
        html = html:gsub('src="%./', 'src="' .. basePath)
        html = html:gsub("src='%./", "src='" .. basePath)
        html = html:gsub('href="%./', 'href="' .. basePath)
        html = html:gsub("href='%./", "href='" .. basePath)
    end

    if app.route and html then
        html = html:gsub("</head>", ('<script>window.SKY_PHONE_APP_ROUTE="%s";</script></head>'):format(app.route))
    end

    local exportName = app.addAppExport or "AddCustomApp"
    local appData = {
        identifier = app.identifier,
        name = app.name,
        ui = html or app.ui,
        icon = app.icon,
        description = app.description,
        defaultApp = app.defaultApp == true,
        notification = app.notification ~= false,
        fixBlur = app.fixBlur == true,
        job = app.job,
        addAppStore = app.addAppStore == true,
        developer = app.developer,
        headerImage = app.headerImage,
        swiperItems = app.swiperItems,
        games = app.games == true,
        price = app.price,
        size = app.size
    }

    local phone_exports = exports[RESOURCE]
    return phone_exports[exportName](phone_exports, appData)
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    SendNUIMessage(data or {})
end

function Sky.Functions.SendPhoneAppNotification(data, source)
    data = data or {}

    if not IsDuplicityVersion() then
        TriggerServerEvent("sky_base:phone:sendAppNotification", data)
        return true
    end

    local target = tonumber(source or data.source or data.src)
    if not target or target <= 0 then
        return false
    end

    local exportName = data.notificationExport or "SendNotify"
    local phone_exports = exports[RESOURCE]
    return phone_exports[exportName](phone_exports, target, {
        app = data.app or data.identifier,
        title = data.title,
        message = data.content or data.message or data.text
    })
end

function Sky.Functions.GetPhoneNumber(source)
    if not IsDuplicityVersion() then return nil end
    local rows = Sky.Query(
        "SELECT `phone_number` FROM `codem_mphone_data` WHERE `owner` = ? LIMIT 1",
        { Sky.FW.GetIdentifier(source) }
    ) or {}
    return rows[1] and rows[1].phone_number or nil
end

function Sky.Functions.GetSourceFromNumber(phoneNumber)
    if not IsDuplicityVersion() or phoneNumber == nil then
        return nil
    end

    local result = Sky.Query(
        'SELECT `owner` FROM `codem_mphone_data` WHERE `phone_number` = ? LIMIT 1',
        { tostring(phoneNumber) }
    ) or {}
    local owner = result[1] and result[1].owner
    if owner == nil then
        return nil
    end

    owner = tostring(owner)
    for _, player in ipairs(GetPlayers()) do
        local source = tonumber(player)
        local identifier = Sky.FW.GetIdentifier(source)
        if identifier ~= nil and tostring(identifier) == owner then
            return source
        end
    end

    return nil
end

function Sky.Functions.HasAirplaneMode(phoneNumber)
    return exports[RESOURCE]:HasAirplaneMode(phoneNumber)
end
