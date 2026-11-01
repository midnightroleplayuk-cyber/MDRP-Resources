local RESOURCE = "vms_housing"

local function resolve_vms_property_entrance(property)
    if type(property) ~= "table" then
        return nil
    end

    if property.object_id then
        local buildingOk, building = pcall(function()
            return exports[RESOURCE]:GetProperty(property.object_id)
        end)
        if buildingOk and type(building) == "table" and building.type == "building" then
            property = building
        end
    end

    return Sky.Housing.ResolvePropertyEntrance(property)
end

Sky.Housing.RegisterAdapter(RESOURCE, function(source)
    if GetResourceState(RESOURCE) ~= "started" then
        return nil
    end

    if IsDuplicityVersion() then
        local ok, playerProperty = pcall(function()
            return exports[RESOURCE]:GetPlayerCurrentProperty(source)
        end)
        if not ok or not playerProperty then
            return nil
        end

        local property
        ok, property = pcall(function()
            return exports[RESOURCE]:GetProperty(playerProperty)
        end)
        if not ok then
            return nil
        end

        return resolve_vms_property_entrance(property)
    end

    local ok, propertyId, property = pcall(function()
        return exports[RESOURCE]:IsPlayerInsideProperty()
    end)
    if not ok or not propertyId then
        return nil
    end
    if type(property) ~= "table" then
        ok, property = pcall(function()
            return exports[RESOURCE]:GetProperty(propertyId)
        end)
        if not ok then
            return nil
        end
    end

    return resolve_vms_property_entrance(property)
end)

if IsDuplicityVersion() then
    local function normalize_vms_property_id(value)
        if type(value) == "table" then
            value = value.id or value.propertyId or value.property_id
        end

        if type(value) == "number" then
            if value < 1 or value ~= math.floor(value) then
                return nil
            end
            return math.floor(value), tostring(math.floor(value))
        end
        if type(value) ~= "string" then
            return nil
        end

        local normalized = value:match("^%s*(.-)%s*$")
        if normalized == "" or #normalized > 128 or normalized:find("%c") then
            return nil
        end
        return normalized, normalized
    end

    local function count_owned_vms_properties(properties, identifier)
        if next(properties) == nil then
            return 0
        end

        local seen = {}
        local count = 0

        local function inspect_property(property, fallbackId)
            local propertyId, propertyKey = normalize_vms_property_id(property)
            if not propertyId then
                propertyId, propertyKey = normalize_vms_property_id(fallbackId)
            end
            if not propertyId then
                return false, "invalid_result"
            end
            if seen[propertyKey] then
                return true
            end

            if type(property) ~= "table"
                or (property.owner == nil and property.Owner == nil)
            then
                local ok, resolved = pcall(function()
                    return exports[RESOURCE]:GetProperty(propertyId)
                end)
                if not ok then
                    Sky.Debug("error", "[housing/vms_housing] GetProperty failed: %s", tostring(resolved))
                    return false, "provider_error"
                end
                if type(resolved) ~= "table" then
                    Sky.Debug("error", "[housing/vms_housing] GetProperty returned invalid data for property %s.", propertyKey)
                    return false, "invalid_result"
                end
                property = resolved
            end

            seen[propertyKey] = true
            local owner = property.owner ~= nil and property.owner or property.Owner
            if owner ~= nil and tostring(owner) == identifier then
                count = count + 1
            end
            return true
        end

        local directId = normalize_vms_property_id(properties)
        if directId then
            local ok, errorCode = inspect_property(properties, directId)
            return ok and count or nil, errorCode
        end

        local isArray = #properties > 0
        for key, property in pairs(properties) do
            local fallbackId = isArray and property or key
            local ok, errorCode = inspect_property(property, fallbackId)
            if not ok then
                return nil, errorCode
            end
        end
        return count
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
            return exports[RESOURCE]:GetPlayerProperties(source)
        end)
        if not ok then
            Sky.Debug("error", "[housing/vms_housing] GetPlayerProperties failed: %s", tostring(properties))
            return nil, "provider_error"
        end
        if type(properties) ~= "table" then
            Sky.Debug("error", "[housing/vms_housing] GetPlayerProperties returned invalid data.")
            return nil, "invalid_result"
        end

        local count, errorCode = count_owned_vms_properties(properties, identifier)
        if count == nil and errorCode == "invalid_result" then
            Sky.Debug("error", "[housing/vms_housing] GetPlayerProperties returned malformed property identifiers.")
        end
        return count, errorCode
    end)
end
