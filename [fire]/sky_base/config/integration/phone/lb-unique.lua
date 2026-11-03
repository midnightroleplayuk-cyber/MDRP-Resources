if Sky.Config.phone ~= "lb-unique" then return end

local RESOURCE = "lb-phone"

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
    local phoneNumber = exports[RESOURCE]:GetEquippedPhoneNumber(src)
    if phoneNumber then
        Sky.Query('UPDATE `phone_phones` SET `phone_number` = ? WHERE `phone_number` = ?', {newNumber, phoneNumber})
        local entity = NetworkGetEntityFromNetworkId(src)
        while not DoesEntityExist(entity) do Wait(0) end
        if entity and DoesEntityExist(entity) then
            local state = Entity(entity).state
            state.set("phoneNumber", newNumber, true)

            local items = exports.ox_inventory:Search(src, 'slots', 'phone')
            for _, phone in pairs(items) do
                if phone and phone.metadata and phone.metadata.lbPhoneNumber == phoneNumber then
                    phone.metadata.lbPhoneNumber = newNumber
                    phone.metadata.lbFormattedNumber = exports[RESOURCE]:FormatNumber(newNumber)

                    exports.ox_inventory:SetMetadata(src, phone.slot, phone.metadata)
                end
            end
        end
    end
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
