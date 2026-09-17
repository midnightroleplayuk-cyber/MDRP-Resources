--[[
    wasabi_mdt v2 — bcs_housing property bridge
    https://docs.baguscodestudio.com/paid_scripts/housing/exports/server
]]

local RESOURCE = 'bcs_housing'

local function log(fmt, ...)
    if select('#', ...) > 0 then
        local ok, formatted = pcall(string.format, fmt, ...)
        if ok then fmt = formatted end
    end
    lib.print.debug(('[housing:bcs] %s'):format(tostring(fmt)))
end

local TYPE_MAP = {
    mlo = 'house',
    shell = 'house',
    ipl = 'house',
    house = 'house',
    individual = 'house',
    apartment = 'apartment',
    flat = 'apartment',
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

local function propertyId(row)
    return row.identifier or row.id or row.homeId or row.home_id
end

local function entryCoords(row)
    local coords = row.entry
    if type(coords) ~= 'table' then
        return { x = 0.0, y = 0.0, z = 0.0 }
    end
    return {
        x = tonumber(coords.x or coords[1]) or 0.0,
        y = tonumber(coords.y or coords[2]) or 0.0,
        z = tonumber(coords.z or coords[3]) or 0.0,
    }
end

local function tryExport(method, ...)
    local ok, result = pcall(function(...)
        return exports[RESOURCE][method](exports[RESOURCE], ...)
    end, ...)
    if ok and type(result) == 'table' then return result end
    if ok then return result end
    return nil
end

local function buildAddress(row)
    if row.name and row.realestate and row.realestate ~= '' then
        return ('%s - %s'):format(row.name, row.realestate)
    end
    return row.name or 'Unknown Property'
end

local function toMdtRecord(row)
    if not row then return nil end
    local id = propertyId(row)
    if not id then return nil end

    local keyList = tryExport('GetKeyList', id)
    local keyHolders = tryExport('GetKeyHolders', id)
    local playersInside = tryExport('GetPlayersInside', id)
    local now = os.time()

    return {
        id = id,
        address = buildAddress(row),
        property_type = resolveType(row.type or row.complex),
        owner_id = row.owner,
        coords = entryCoords(row),
        metadata = {
            original_type = row.type,
            complex = row.complex,
            payment = row.payment,
            price = row.price,
            locked = row.locked,
            realestate = row.realestate,
            configuration = row.configuration,
            data = row.data,
            lastPayment = row.lastPayment,
            lastLogin = row.lastLogin,
            keys = row.keys,
            keyList = keyList,
            keyHolders = keyHolders,
            players = row.players,
            playersInside = playersInside,
            furniture = row.furniture,
            mortgages = row.mortgages,
            cctv = row.cctv,
            doors = row.doors,
            wardrobes = row.wardrobes,
            storages = row.storages,
            apartments = row.apartments,
            area = row.area,
            fromHousing = true,
        },
        created_at = now,
        updated_at = tonumber(row.lastLogin or row.lastPayment) or now,
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

local function allHomes()
    return tryExport('GetHomes')
end

function GetPropertyFromHousing(id)
    local home = tryExport('GetHome', id)
    if home then return toMdtRecord(home) end

    local homes = allHomes()
    if type(homes) ~= 'table' then return nil end
    for _, prop in pairs(homes) do
        if tostring(propertyId(prop)) == tostring(id) then
            return toMdtRecord(prop)
        end
    end
    return nil
end

function GetPropertyByAddress(address)
    local homes = allHomes()
    if type(homes) ~= 'table' then return nil end
    for _, prop in pairs(homes) do
        local record = toMdtRecord(prop)
        if record and (record.address == address or prop.name == address) then
            return record
        end
    end
    return nil
end

function GetAllPropertiesFromHousing(requestedOffset, requestedLimit)
    local offset = math.max(tonumber(requestedOffset) or 0, 0)
    local limit = math.max(tonumber(requestedLimit) or 30, 1)

    local homes = allHomes()
    if type(homes) ~= 'table' then
        log('GetHomes unavailable')
        return {}
    end

    local list = asList(homes)
    table.sort(list, function(a, b)
        return (a.name or '') < (b.name or '')
    end)

    local out = {}
    for i = offset + 1, math.min(offset + limit, #list) do
        push(out, list[i])
    end
    return out
end

function SearchPropertiesFromHousing(query)
    query = tostring(query or ''):lower()
    local homes = allHomes()
    local out = {}
    if type(homes) ~= 'table' then return out end

    for _, prop in pairs(homes) do
        local record = toMdtRecord(prop)
        if record then
            local haystack = table.concat({
                tostring(record.address or ''),
                tostring(record.owner_id or ''),
                tostring(prop.realestate or ''),
                tostring(prop.complex or ''),
                tostring(prop.type or ''),
            }, ' '):lower()
            if haystack:find(query, 1, true) then
                out[#out + 1] = record
            end
        end
    end
    return out
end

function GetPropertiesByOwner(identifier)
    local owned = tryExport('GetOwnedHomes', identifier)
    if type(owned) == 'table' then
        local out = {}
        for _, prop in pairs(owned) do push(out, prop) end
        return out
    end

    local homes = allHomes()
    local out = {}
    if type(homes) == 'table' then
        for _, prop in pairs(homes) do
            if tostring(prop.owner or '') == tostring(identifier) then
                push(out, prop)
            end
        end
    end
    return out
end

function GetPropertiesCountFromHousing()
    local homes = allHomes()
    if type(homes) ~= 'table' then return 0 end
    local n = 0
    for _ in pairs(homes) do n = n + 1 end
    return n
end

log('adapter registered')
