Sky.Housing = {}

-- Housing deliberately supports several providers; registration state belongs to this owner.
local entrance_adapters = {}
local entrance_adapter_order = {}
local ownership_adapters = {}
local ownership_adapter_order = {}

local propertyIdFields = {
    "id",
    "propertyId",
    "property_id",
    "propertyid",
    "houseId",
    "house_id",
    "houseid",
    "house",
    "houseName",
    "house_name",
    "name",
    "propertyName",
    "property_name",
    "propertyname",
    "identifier",
}

function Sky.Housing._PropertyId(property, fallback)
    if type(property) == "table" then
        for _, field in ipairs(propertyIdFields) do
            local value = property[field]
            if (type(value) == "string" and value ~= "") or type(value) == "number" then
                return tostring(value)
            end
        end
    end

    if (type(fallback) == "string" and fallback ~= "") or type(fallback) == "number" then
        return tostring(fallback)
    end
    return nil
end

function Sky.Housing._CountOwnedCollection(properties)
    local valueType = type(properties)
    if valueType == "number" or (valueType == "string" and properties ~= "") then
        return 1
    end
    if valueType ~= "table" then
        return nil
    end
    if next(properties) == nil then
        return 0
    end

    if Sky.Housing._PropertyId(properties) then
        return 1
    end

    local seen = {}
    for key, property in pairs(properties) do
        if property ~= nil and property ~= false then
            local propertyType = type(property)
            local id = Sky.Housing._PropertyId(property)
            if not id and (propertyType == "string" or propertyType == "number") then
                id = tostring(property)
            elseif not id and (propertyType == "table" or property == true) then
                id = Sky.Housing._PropertyId(nil, key)
            end
            if not id then
                return nil
            end
            seen[id] = true
        end
    end

    local count = 0
    for _ in pairs(seen) do
        count = count + 1
    end
    return count
end

function Sky.Housing._PositivePropertyId(value)
    if type(value) == "table" then
        value = Sky.Housing._PropertyId(value)
    end

    local number = tonumber(value)
    if not number or number < 1 or number ~= math.floor(number) then
        return nil
    end
    return tostring(math.floor(number))
end

function Sky.Housing._CountPositivePropertyIds(properties)
    local directId = Sky.Housing._PositivePropertyId(properties)
    if directId then
        return 1
    end
    if type(properties) ~= "table" then
        return nil
    end
    if next(properties) == nil then
        return 0
    end

    local arrayLength = #properties
    local isDenseArray = arrayLength > 0
    if isDenseArray then
        local entries = 0
        for key in pairs(properties) do
            entries = entries + 1
            if type(key) ~= "number"
                or key < 1
                or key ~= math.floor(key)
                or key > arrayLength
            then
                isDenseArray = false
            end
        end
        isDenseArray = isDenseArray and entries == arrayLength
    end

    local seen = {}
    for key, property in pairs(properties) do
        local id = Sky.Housing._PositivePropertyId(property)
        if not id and property == true then
            id = Sky.Housing._PositivePropertyId(key)
        end
        if not id and not isDenseArray and property ~= nil and property ~= false then
            id = Sky.Housing._PositivePropertyId(key)
        end
        if not id then
            return nil
        end
        seen[id] = true
    end

    local count = 0
    for _ in pairs(seen) do
        count = count + 1
    end
    return count
end

function Sky.Housing.NormalizeCoords(coords)
    if not coords or not coords.x or not coords.y or not coords.z then
        return nil
    end

    local x = tonumber(coords.x)
    local y = tonumber(coords.y)
    local z = tonumber(coords.z)
    if not x or not y or not z then
        return nil
    end
    if x == 0.0 and y == 0.0 and z == 0.0 then
        return nil
    end

    return vector3(x, y, z)
end

function Sky.Housing.CoordsChanged(coords, fallbackCoords)
    local normalized = Sky.Housing.NormalizeCoords(coords)
    local fallback = Sky.Housing.NormalizeCoords(fallbackCoords)
    if not normalized then
        return nil
    end
    if not fallback then
        return normalized
    end

    return #(normalized - fallback) > 1.0 and normalized or nil
end

function Sky.Housing.FirstCoords(...)
    for i = 1, select("#", ...) do
        local coords = Sky.Housing.NormalizeCoords(select(i, ...))
        if coords then
            return coords
        end
    end
    return nil
end

function Sky.Housing.FirstDoorCoords(doors)
    if type(doors) ~= "table" then
        return nil
    end

    for _, door in pairs(doors) do
        local coords = Sky.Housing.FirstCoords(
            door and door.coords,
            door and door.door1 and door.door1.coords,
            door and door.door2 and door.door2.coords
        )
        if coords then
            return coords
        end
    end

    return nil
end

function Sky.Housing.ResolvePropertyEntrance(property)
    if type(property) ~= "table" then
        return nil
    end

    local metadata = type(property.metadata) == "table" and property.metadata or {}
    local coords = type(property.coords) == "table" and property.coords or {}
    local enter = type(property.enter) == "table" and property.enter or {}
    local entry = type(property.entry) == "table" and property.entry or {}
    local entrance = type(property.entrance) == "table" and property.entrance or {}

    return Sky.Housing.FirstCoords(
        metadata.exit,
        metadata.entrance,
        metadata.enter,
        entrance.coords,
        entrance,
        entry.coords,
        entry,
        enter.coords,
        enter,
        coords.entrance,
        coords.entry,
        coords.enter,
        coords,
        property.position,
        property.location,
        property.blip,
        property.sellsign and property.sellsign.coords,
        Sky.Housing.FirstDoorCoords(property.doors)
    )
end

function Sky.Housing.RegisterAdapter(name, handler)
    if type(name) ~= "string" or name == "" or type(handler) ~= "function" then
        return false
    end

    if not entrance_adapters[name] then
        entrance_adapter_order[#entrance_adapter_order + 1] = name
    end
    entrance_adapters[name] = handler
    return true
end

function Sky.Housing.RegisterOwnershipAdapter(name, handler)
    if type(name) ~= "string" or name == "" or type(handler) ~= "function" then
        return false
    end

    if not ownership_adapters[name] then
        ownership_adapter_order[#ownership_adapter_order + 1] = name
    end
    ownership_adapters[name] = handler
    return true
end

---Get the number of properties owned by an online player through the first active housing adapter.
---@param source number
---@return integer? count
---@return string? error_code
function Sky.Housing.GetOwnedPropertyCount(source)
    if not IsDuplicityVersion() then
        return nil, "server_only"
    end

    source = tonumber(source)
    if not source or source <= 0 or source ~= math.floor(source) then
        return nil, "invalid_source"
    end

    for _, name in ipairs(ownership_adapter_order) do
        local handler = ownership_adapters[name]
        local ok, count, errorCode = pcall(handler, source)
        if not ok then
            Sky.Debug("error", "[housing/%s] property ownership lookup failed: %s", tostring(name), tostring(count))
            return nil, "provider_error"
        end

        if count ~= nil then
            local numericCount = tonumber(count)
            if not numericCount or numericCount < 0 or numericCount ~= math.floor(numericCount) then
                Sky.Debug("error", "[housing/%s] property ownership lookup returned an invalid count: %s", tostring(name), tostring(count))
                return nil, "invalid_result"
            end
            return numericCount
        end

        if errorCode ~= "provider_unavailable" then
            return nil, errorCode or "provider_error"
        end
    end

    return nil, "unsupported"
end

function Sky.Housing.GetPlayerEntranceCoords(source, fallbackCoords)
    for _, name in ipairs(entrance_adapter_order) do
        local handler = entrance_adapters[name]
        local ok, result = pcall(handler, source, fallbackCoords)
        local coords = ok and Sky.Housing.NormalizeCoords(result) or nil
        if coords then
            return coords, name
        elseif not ok then
            Sky.Debug("warn", "[housing/%s] entrance lookup failed: %s", tostring(name), tostring(result))
        end
    end

    return Sky.Housing.NormalizeCoords(fallbackCoords), nil
end

function Sky.Housing.GetCurrentEntranceCoords(fallbackCoords)
    if IsDuplicityVersion() then
        return Sky.Housing.NormalizeCoords(fallbackCoords), nil
    end

    local coords, adapter = Sky.Housing.GetPlayerEntranceCoords(GetPlayerServerId(PlayerId()), fallbackCoords)
    if adapter then
        return coords, adapter
    end

    local serverCoords, serverAdapter = Sky.Cb.TriggerWithTimeout("sky_base:housing:getEntranceCoords", 1000, fallbackCoords)
    serverCoords = Sky.Housing.NormalizeCoords(serverCoords)
    if serverCoords and serverAdapter then
        return serverCoords, serverAdapter
    end

    return coords, nil
end

if IsDuplicityVersion() then
    Sky.Cb.Register("sky_base:housing:getEntranceCoords", function(source, fallbackCoords)
        return Sky.Housing.GetPlayerEntranceCoords(source, fallbackCoords)
    end)
end
