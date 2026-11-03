local RESOURCE = "nolag_properties"

Sky.Housing.RegisterAdapter(RESOURCE, function(_, fallbackCoords)
    if IsDuplicityVersion() or GetResourceState(RESOURCE) ~= "started" then
        return nil
    end

    local ok, property = pcall(function()
        return exports[RESOURCE]:GetCurrentProperty()
    end)
    if ok and type(property) == "table" then
        local coords = Sky.Housing.ResolvePropertyEntrance(property)
        if coords then
            return coords
        end
    end

    local coords
    ok, coords = pcall(function()
        return exports[RESOURCE]:GetEntryCoordinates()
    end)
    if not ok then
        return nil
    end

    return Sky.Housing.CoordsChanged(coords, fallbackCoords)
end)

if IsDuplicityVersion() then
    local function collect_no_lag_property_ids(properties)
        local directId = Sky.Housing._PositivePropertyId(properties)
        if directId then
            return { [directId] = true }
        end
        if next(properties) == nil then
            return {}
        end

        local ids = {}
        local isArray = #properties > 0
        for key, property in pairs(properties) do
            local propertyId = Sky.Housing._PositivePropertyId(property)
            if not propertyId and not isArray and property ~= nil and property ~= false then
                propertyId = Sky.Housing._PositivePropertyId(key)
            end
            if not propertyId then
                return nil
            end
            ids[propertyId] = true
        end
        return ids
    end

    Sky.Housing.RegisterOwnershipAdapter(RESOURCE, function(source)
        if GetResourceState(RESOURCE) ~= "started" then
            return nil, "provider_unavailable"
        end

        local identifier = Sky.FW.GetIdentifier(source)
        if identifier == nil or tostring(identifier) == "" then
            return nil, "identifier_not_found"
        end
        identifier = tostring(identifier)

        local ok, properties = pcall(function()
            return exports[RESOURCE]:GetAllProperties(identifier, "user", true)
        end)
        if not ok then
            Sky.Debug("error", "[housing/nolag_properties] GetAllProperties failed: %s", tostring(properties))
            return nil, "provider_error"
        end
        if type(properties) ~= "table" then
            Sky.Debug("error", "[housing/nolag_properties] GetAllProperties returned invalid data.")
            return nil, "invalid_result"
        end

        local propertyIds = collect_no_lag_property_ids(properties)
        if not propertyIds then
            Sky.Debug("error", "[housing/nolag_properties] GetAllProperties returned malformed property identifiers.")
            return nil, "invalid_result"
        end

        local count = 0
        for propertyId in pairs(propertyIds) do
            local detailsOk, details = pcall(function()
                return exports[RESOURCE]:GetPropertyData(tonumber(propertyId))
            end)
            if not detailsOk then
                Sky.Debug("error", "[housing/nolag_properties] GetPropertyData failed: %s", tostring(details))
                return nil, "provider_error"
            end
            if type(details) ~= "table" then
                Sky.Debug("error", "[housing/nolag_properties] GetPropertyData returned invalid data for property %s.", propertyId)
                return nil, "invalid_result"
            end

            local owner = details.owner ~= nil and details.owner or details.Owner
            if owner ~= nil and tostring(owner) == identifier then
                count = count + 1
            end
        end
        return count
    end)
end
