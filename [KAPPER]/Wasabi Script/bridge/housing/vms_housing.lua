--[[
    wasabi_mdt v2 — vms_housing property bridge
    https://docs.vames-store.com/assets/vms_housing/developer-api/server-exports
]]

local RESOURCE = 'vms_housing'

local function log(fmt, ...)
    if select('#', ...) > 0 then
        local ok, formatted = pcall(string.format, fmt, ...)
        if ok then fmt = formatted end
    end
    lib.print.debug(('[housing:vms] %s'):format(tostring(fmt)))
end

local TYPE_MAP = {
    shell = 'house',
    mlo = 'house',
    ipl = 'house',
    house = 'house',
    apartment = 'apartment',
    garage = 'garage',
    business = 'business',
    office = 'office',
    warehouse = 'warehouse',
    store = 'store',
}

local function resolveType(raw)
    local mapped = TYPE_MAP[tostring(raw or ''):lower()] or 'other'
    local catalog = Config and Config.PropertyTypes
    if not catalog or #catalog == 0 then return mapped end
    for i = 1, #catalog do
        if catalog[i].type == mapped then return mapped end
    end
    log('type "%s" missing from Config.PropertyTypes; using %s', mapped, catalog[1].type)
    return catalog[1].type
end

local function decodeJson(value, fallback)
    if type(value) ~= 'string' then return value end
    local ok, decoded = pcall(json.decode, value or '')
    if ok and decoded ~= nil then return decoded end
    return fallback
end

local function shallowCopy(tbl)
    local copy = {}
    if type(tbl) ~= 'table' then return copy end
    for key, value in pairs(tbl) do copy[key] = value end
    return copy
end

local function enterCoords(meta)
    local coords = meta.enter
    if type(coords) == 'string' then coords = decodeJson(coords, {}) end
    if type(coords) ~= 'table' then
        return { x = 0.0, y = 0.0, z = 0.0 }
    end
    return {
        x = tonumber(coords.x or coords[1]) or 0.0,
        y = tonumber(coords.y or coords[2]) or 0.0,
        z = tonumber(coords.z or coords[3]) or 0.0,
    }
end

local function buildAddress(row)
    if row.name and row.address and row.region then
        return ('%s - %s, %s'):format(row.name, row.address, row.region)
    end
    if row.name and row.address then
        return ('%s - %s'):format(row.name, row.address)
    end
    return row.name or row.address or 'Unknown Property'
end

local function tryExport(method, ...)
    local ok, result = pcall(function(...)
        return exports[RESOURCE][method](exports[RESOURCE], ...)
    end, ...)
    if ok then return result end
    return nil
end

local function toMdtRecord(row)
    if not row then return nil end

    local metadata = shallowCopy(decodeJson(row.metadata, {}))
    metadata.description = row.description
    metadata.region = row.region
    metadata.rawAddress = row.address
    metadata.ownerName = row.owner_name
    metadata.lastEnter = row.last_enter
    metadata.unpaidBills = row.unpaidBills
    metadata.bills = row.bills
    metadata.permissions = row.permissions
    metadata.keys = type(row.keys) == 'string' and decodeJson(row.keys, {}) or row.keys
    metadata.sale = row.sale
    metadata.rental = row.rental
    metadata.creator = row.creator
    metadata.furniture = row.furniture
    metadata.original_type = row.type
    metadata.fromHousing = true

    local now = os.time()
    return {
        id = row.id,
        address = buildAddress(row),
        property_type = resolveType(row.type),
        owner_id = row.owner,
        coords = enterCoords(metadata),
        metadata = metadata,
        created_at = now,
        updated_at = tonumber(row.last_enter) or now,
    }
end

local function asList(tbl)
    if type(tbl) ~= 'table' then return {} end
    if #tbl > 0 then return tbl end
    local out = {}
    for _, value in pairs(tbl) do out[#out + 1] = value end
    return out
end

local function push(out, row)
    local record = toMdtRecord(row)
    if record then out[#out + 1] = record end
end

local function allProperties()
    return tryExport('GetAllProperties')
end

function GetPropertyFromHousing(id)
    local prop = tryExport('GetProperty', id)
    if prop then return toMdtRecord(prop) end

    local all = allProperties()
    if type(all) ~= 'table' then return nil end
    for _, row in pairs(all) do
        if row and tostring(row.id) == tostring(id) then
            return toMdtRecord(row)
        end
    end
    return nil
end

function GetPropertyByAddress(address)
    local all = allProperties()
    if type(all) ~= 'table' then return nil end
    for _, row in pairs(all) do
        local record = toMdtRecord(row)
        if record and (record.address == address or row.name == address or row.address == address) then
            return record
        end
    end
    return nil
end

function GetAllPropertiesFromHousing(requestedOffset, requestedLimit)
    local offset = math.max(tonumber(requestedOffset) or 0, 0)
    local limit = math.max(tonumber(requestedLimit) or 30, 1)

    local all = allProperties()
    if type(all) ~= 'table' then
        log('GetAllProperties unavailable')
        return {}
    end

    local list = asList(all)
    table.sort(list, function(a, b)
        return (a.name or a.address or '') < (b.name or b.address or '')
    end)

    local out = {}
    for i = offset + 1, math.min(offset + limit, #list) do
        push(out, list[i])
    end
    return out
end

function SearchPropertiesFromHousing(query)
    query = tostring(query or ''):lower()
    local all = allProperties()
    local out = {}
    if type(all) ~= 'table' then return out end

    for _, row in pairs(all) do
        local record = toMdtRecord(row)
        if record then
            local haystack = table.concat({
                tostring(record.address or ''),
                tostring(record.owner_id or ''),
                tostring(row.owner_name or ''),
                tostring(row.region or ''),
                tostring(row.type or ''),
            }, ' '):lower()
            if haystack:find(query, 1, true) then
                out[#out + 1] = record
            end
        end
    end
    return out
end

function GetPropertiesByOwner(identifier)
    local owned = tryExport('GetPlayerProperties', identifier)
    if type(owned) == 'table' then
        local out = {}
        for _, row in pairs(owned) do push(out, row) end
        return out
    end

    local all = allProperties()
    local out = {}
    if type(all) == 'table' then
        for _, row in pairs(all) do
            if tostring(row.owner or '') == tostring(identifier) then
                push(out, row)
            end
        end
    end
    return out
end

function GetPropertiesCountFromHousing()
    local all = allProperties()
    if type(all) ~= 'table' then return 0 end
    local n = 0
    for _ in pairs(all) do n = n + 1 end
    return n
end

log('adapter registered')
