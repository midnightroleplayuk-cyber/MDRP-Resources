if not IsDuplicityVersion() or Sky.Config.phone == "sky" then return end

-- Providers may replace this read-only check with their device/SIM rules.
function Sky.Functions.ValidateNumberChange(source, new_number)
    if type(new_number) ~= "string" or new_number:match("^%s*$") or #new_number > 64 then
        return false, "invalid_phone_number"
    end
    if Sky.Functions.IsNumberUsed(new_number) then
        return false, "phone_number_taken"
    end
    return true
end
