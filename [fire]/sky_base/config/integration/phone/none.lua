if Sky.Config.phone ~= "none" then return end

function Sky.Functions.ValidateNumberChange(source, new_number)
    return false, "unsupported_phone"
end

function Sky.Functions.ChangeNumber(source, new_number)
    return false, "unsupported_phone"
end

function Sky.Functions.IsNumberUsed(phone_number)
    return nil, "unsupported_phone"
end
