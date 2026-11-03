if Sky.Config.phone ~= "d" then return end

function Sky.Functions.ChangeNumber(src, newNumber)
    TriggerClientEvent("d-phone:client:changenumber", src, newNumber)
end

function Sky.Functions.IsNumberUsed(phoneNumber)
    return false
end

function Sky.Functions.RegisterCustomPhoneApp(app)
    Sky.Debug("error", "[sky_base] custom phone app registration is not supported for d-phone")
    return false, "unsupported_phone"
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    Sky.Debug("error", "[sky_base] custom phone app messages are not supported for d-phone")
end

function Sky.Functions.SendPhoneAppNotification(data)
    Sky.Debug("error", "[sky_base] custom phone app notifications are not supported for d-phone")
    return false, "unsupported_phone"
end

function Sky.Functions.GetSourceFromNumber(phoneNumber)
    Sky.Debug("error", "[sky_base] get source from number is not supported for d-phone")
end

function Sky.Functions.HasAirplaneMode(phoneNumber)
    Sky.Debug("error", "[sky_base] has airplane mode is not supported for d-phone")
end
