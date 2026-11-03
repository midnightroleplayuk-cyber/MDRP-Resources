if not IsDuplicityVersion() then return end

local RESOURCE = "RxHousing"

local function get_rx_resource_name()
    if GetResourceState(RESOURCE) == "started" then
        return "RxHousing"
    end
    if GetResourceState("rx_housing") == "started" then
        return "rx_housing"
    end
    return nil
end

Sky.Housing.RegisterAdapter(RESOURCE, function(source)
    local resourceName = get_rx_resource_name()
    if not resourceName then
        return nil
    end

    local ok, properties = pcall(function()
        return exports[resourceName]:GetAllProperties()
    end)
    if not ok or type(properties) ~= "table" then
        return nil
    end

    local sourceNumber = tonumber(source)
    local sourceString = tostring(source)

    for _, property in pairs(properties) do
        local propertyId = property and (property.id or property.propertyId or property.property_id)
        local players = property and (property.players or property.playersinside or property.playersInside)

        if type(players) ~= "table" and propertyId then
            ok, players = pcall(function()
                return exports[resourceName]:GetPlayersInProperty(propertyId)
            end)
            if not ok then
                players = nil
            end
        end

        if type(players) == "table" then
            for _, player in pairs(players) do
                if player == sourceNumber or tostring(player) == sourceString
                    or type(player) == "table" and tonumber(player.source) == sourceNumber
                then
                    return Sky.Housing.ResolvePropertyEntrance(property)
                end
            end
        end
    end

    return nil
end)

local function count_rx_owned_properties(properties)
    local directId = Sky.Housing._PositivePropertyId(properties)
    if directId then
        return 1
    end
    if next(properties) == nil then
        return 0
    end

    local seen = {}
    local isArray = #properties > 0
    for key, value in pairs(properties) do
        local property = value
        if type(value) == "string"
            and not tonumber(value)
            and json
            and type(json.decode) == "function"
        then
            local decodeOk, decoded = pcall(json.decode, value)
            property = decodeOk and type(decoded) == "table" and decoded or value
        end

        local propertyId = Sky.Housing._PositivePropertyId(property)
        if not propertyId and value == true then
            propertyId = Sky.Housing._PositivePropertyId(key)
        end
        if not propertyId and not isArray and value ~= nil and value ~= false then
            propertyId = Sky.Housing._PositivePropertyId(key)
        end
        if not propertyId then
            return nil
        end
        seen[propertyId] = true
    end

    local count = 0
    for _ in pairs(seen) do
        count = count + 1
    end
    return count
end

Sky.Housing.RegisterOwnershipAdapter(RESOURCE, function(source)
    local resourceName = get_rx_resource_name()
    if not resourceName then
        return nil, "provider_unavailable"
    end

    local identifier = Sky.FW.GetIdentifier(source)
    if identifier == nil or tostring(identifier) == "" then
        return nil, "identifier_not_found"
    end

    local ok, properties = pcall(function()
        return exports[resourceName]:GetOwnedProperties(identifier)
    end)
    if not ok then
        Sky.Debug("error", "[housing/%s] GetOwnedProperties failed: %s", resourceName, tostring(properties))
        return nil, "provider_error"
    end
    if type(properties) ~= "table" then
        Sky.Debug("error", "[housing/%s] GetOwnedProperties returned invalid data.", resourceName)
        return nil, "invalid_result"
    end

    local count = count_rx_owned_properties(properties)
    if count == nil then
        Sky.Debug("error", "[housing/%s] GetOwnedProperties returned malformed property identifiers.", resourceName)
        return nil, "invalid_result"
    end
    return count
end)
