if Sky.Config.phone ~= "npwd" then return end

local RESOURCE = "npwd"

-- NPWD's framework bridge owns character load/unload and its active phone cache.
function Sky.Functions.GetPhoneNumber(source)
    if IsDuplicityVersion() then
        local player = exports[RESOURCE]:getPlayerData({ source = source })
        return player and player.phoneNumber or nil
    end
    return exports[RESOURCE]:getPhoneNumber()
end

function Sky.Functions.GetSourceFromNumber(phone_number)
    if not IsDuplicityVersion() then return nil, "server_only" end
    local player = exports[RESOURCE]:getPlayerData({ phoneNumber = phone_number })
    return player and player.source or nil
end

-- No public NPWD export changes a number in both persistent and loaded state.
-- Reject the preflight too, so a shop cannot charge for an unsupported change.
function Sky.Functions.ValidateNumberChange(source, new_number)
    return false, "unsupported_phone"
end

function Sky.Functions.ChangeNumber(source, new_number)
    return false, "unsupported_phone"
end

function Sky.Functions.IsNumberUsed(phone_number)
    return nil, "unsupported_phone"
end

-- NPWD external apps use configured federation resources, not dynamic iframe apps.
function Sky.Functions.RegisterCustomPhoneApp(app)
    return false, "unsupported_phone"
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    return false, "unsupported_phone"
end

function Sky.Functions.SendPhoneAppNotification(data, source)
    return false, "unsupported_phone"
end
