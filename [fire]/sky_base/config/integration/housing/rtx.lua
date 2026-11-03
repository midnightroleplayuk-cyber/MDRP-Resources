local RESOURCE = "rtx_housing"

Sky.Housing.RegisterAdapter(RESOURCE, function(source)
    if GetResourceState(RESOURCE) ~= "started" then
        return nil
    end

    local ok, inside, propertyId, _, property = pcall(function()
        if IsDuplicityVersion() then
            return exports[RESOURCE]:IsPlayerInsideProperty(source)
        end
        return exports[RESOURCE]:IsPlayerInsideProperty()
    end)
    if not ok or not inside or not propertyId then
        return nil
    end
    if type(property) ~= "table" then
        ok, property = pcall(function()
            return exports[RESOURCE]:GetPropertyData(propertyId)
        end)
        if not ok then
            return nil
        end
    end
    if type(property) ~= "table" then
        return nil
    end

    local doorCoords = Sky.Housing.FirstDoorCoords(property.doors)
    if doorCoords then
        return doorCoords
    end

    return Sky.Housing.ResolvePropertyEntrance(property)
end)

if IsDuplicityVersion() then
    Sky.Housing.RegisterOwnershipAdapter(RESOURCE, function(source)
        if GetResourceState(RESOURCE) ~= "started" then
            return nil, "provider_unavailable"
        end

        local ok, properties = pcall(function()
            return exports[RESOURCE]:GetPlayerOwnedProperties(source)
        end)
        if not ok then
            Sky.Debug("error", "[housing/rtx_housing] GetPlayerOwnedProperties failed: %s", tostring(properties))
            return nil, "provider_error"
        end
        if type(properties) ~= "table" then
            Sky.Debug("error", "[housing/rtx_housing] GetPlayerOwnedProperties returned invalid data.")
            return nil, "invalid_result"
        end

        local count = Sky.Housing._CountPositivePropertyIds(properties)
        if count == nil then
            Sky.Debug("error", "[housing/rtx_housing] GetPlayerOwnedProperties returned malformed property identifiers.")
            return nil, "invalid_result"
        end
        return count
    end)
end
