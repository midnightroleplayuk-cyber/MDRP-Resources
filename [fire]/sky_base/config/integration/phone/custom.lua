-- Set Config.phone = "custom" to enable this shared phone template.
if Sky.Config.phone ~= "custom" then return end

function Sky.Functions.ChangeNumber(source, new_number)
    error("Custom phone integration: ChangeNumber is not implemented")
end

function Sky.Functions.IsNumberUsed(phone_number)
    -- Return true when the number is assigned.
    error("Custom phone integration: IsNumberUsed is not implemented")
end

function Sky.Functions.RegisterCustomPhoneApp(app)
    -- Register `app` and return the provider result.
    error("Custom phone integration: RegisterCustomPhoneApp is not implemented")
end

function Sky.Functions.SendCustomPhoneAppMessage(identifier, data)
    error("Custom phone integration: SendCustomPhoneAppMessage is not implemented")
end

function Sky.Functions.SendPhoneAppNotification(data, source)
    error("Custom phone integration: SendPhoneAppNotification is not implemented")
end

function Sky.Functions.GetPhoneNumber(source)
    -- Return the source player's active phone number or nil.
    error("Custom phone integration: GetPhoneNumber is not implemented")
end

function Sky.Functions.RegisterCustomPhoneNumber(number, handler)
    -- Register a dialable custom number and call handler(number) when dialed.
    return false, "unsupported_phone"
end

function Sky.Functions.RemoveCustomPhoneNumber(number)
    return false
end

function Sky.Functions.OpenCustomPhoneApp(identifier, data)
    return false
end

function Sky.Functions.GetSourceFromNumber(phone_number)
    -- Return the online server id associated with the phone number or nil.
    error("Custom phone integration: GetSourceFromNumber is not implemented")
end

function Sky.Functions.HasAirplaneMode(phone_number)
    -- Return whether the phone number currently has airplane mode enabled.
    error("Custom phone integration: HasAirplaneMode is not implemented")
end
