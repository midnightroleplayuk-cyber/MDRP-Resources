if Sky.Config.phone ~= "esx" then return end

function Sky.Functions.ChangeNumber(src, newNumber)
    Sky.DB.SetValue("users", "phone_number", newNumber, "identifier", Sky.FW.GetIdentifier(src))
    TriggerClientEvent("sky_base:notification", src, "Phone", "Your phone number has been changed. Please relog.", "warn", 10000)
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
    Sky.Debug("error", "[sky_base] custom phone app registration is not supported for esx phone")
    return false, "unsupported_phone"
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    Sky.Debug("error", "[sky_base] custom phone app messages are not supported for esx phone")
end

function Sky.Functions.SendPhoneAppNotification(data)
    Sky.Debug("error", "[sky_base] custom phone app notifications are not supported for esx phone")
    return false, "unsupported_phone"
end

function Sky.Functions.GetSourceFromNumber(phoneNumber)
    Sky.Debug("error", "[sky_base] get source from number is not supported for esx phone")
end

function Sky.Functions.HasAirplaneMode(phoneNumber)
    Sky.Debug("error", "[sky_base] has airplane mode is not supported for esx phone")
end
