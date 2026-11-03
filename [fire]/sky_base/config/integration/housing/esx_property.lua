if not IsDuplicityVersion() then return end

local RESOURCE = "esx_property"

Sky.Housing.RegisterOwnershipAdapter(RESOURCE, function(source)
    if Sky.Config.framework ~= "esx"
        or GetResourceState(RESOURCE) ~= "started"
    then
        return nil, "provider_unavailable"
    end

    local identifier = Sky.FW.GetIdentifier(source)
    if identifier == nil or tostring(identifier) == "" then
        return nil, "identifier_not_found"
    end
    identifier = tostring(identifier)

    local ok, properties = pcall(function()
        return exports[RESOURCE]:GetProperties()
    end)
    if not ok then
        Sky.Debug("error", "[housing/esx_property] GetProperties failed: %s", tostring(properties))
        return nil, "provider_error"
    end
    if type(properties) ~= "table" then
        Sky.Debug("error", "[housing/esx_property] GetProperties returned invalid data.")
        return nil, "invalid_result"
    end

    local count = 0
    for _, property in pairs(properties) do
        if type(property) ~= "table" then
            Sky.Debug("error", "[housing/esx_property] GetProperties returned a malformed property entry.")
            return nil, "invalid_result"
        end
        if property.Owned == true
            and property.Owner ~= nil
            and tostring(property.Owner) == identifier
        then
            count = count + 1
        end
    end
    return count
end)
