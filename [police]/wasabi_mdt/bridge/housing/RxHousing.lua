--[[
    wasabi_mdt v2 — RxHousing property bridge

    Prefers RxHousing exports; falls back to the rx_housing SQL table when needed.
]]

local RESOURCE = 'RxHousing'
local TABLE = 'rx_housing'

local function log(fmt, ...)
    if select('#', ...) > 0 then
        local ok, formatted = pcall(string.format, fmt, ...)
        if ok then fmt = formatted end
    end
    lib.print.debug(('[housing:RxHousing] %s'):format(tostring(fmt)))
end

local function decodeJson(value, fallback)
    if type(value) ~= 'string' then return value or fallback end
    local ok, decoded = pcall(json.decode, value)
    if ok and decoded ~= nil then return decoded end
    return fallback
end

local TYPE_MAP = {
    shell = 'apartment',
    ipl = 'apartment',
    mlo = 'house',
    apartment = 'apartment',
}

local function resolveType(raw)
    local mapped = TYPE_MAP[raw] or 'other'
    local catalog = Config and Config.PropertyTypes
    if not catalog or #catalog == 0 then return mapped end
    for i = 1, #catalog do
        if catalog[i].type == mapped then return mapped end
    end
    log('type "%s" missing from Config.PropertyTypes; using %s', mapped, catalog[1].type)
    return catalog[1].type
end

local function normalizeCoords(raw)
    local coords = type(raw) == 'string' and decodeJson(raw, {}) or raw
    if type(coords) ~= 'table' then
        return { x = 0.0, y = 0.0, z = 0.0 }
    end
    return {
        x = tonumber(coords.x) or 0.0,
        y = tonumber(coords.y) or 0.0,
        z = tonumber(coords.z) or 0.0,
    }
end

local function toMdtRecord(row)
    if not row then return nil end
    local now = os.time()
    return {
        id = row.id,
        address = row.label or 'Unknown Property',
        property_type = resolveType(row.propertyType),
        owner_id = row.owner,
        coords = normalizeCoords(row.coords),
        metadata = {
            shell = row.shell,
            iplName = row.iplName,
            stashGrade = row.stashGrade,
            security = row.security,
            stashId = row.stashId,
            doorModel = row.doorModel,
            isRentable = row.isRentable,
            rentalPrice = row.rentalPrice,
            rentalInterval = row.rentalInterval,
            rentalPaidUntil = row.rentalPaidUntil,
            furnitureLimit = row.furnitureLimit,
            furnishable = row.furnishable,
            apartment = row.apartment,
            keyholders = decodeJson(row.keyholders, {}),
            fromHousing = true,
        },
        created_at = now,
        updated_at = now,
    }
end

local function push(out, row)
    local record = toMdtRecord(row)
    if record then out[#out + 1] = record end
end

local function tryCall(fn)
    local ok, result = pcall(fn)
    if ok then return result end
    return nil
end

local function pageFromSql(offset, limit)
    local rows = MySQL.query.await(
        ('SELECT * FROM %s ORDER BY label LIMIT ? OFFSET ?'):format(TABLE),
        { limit, offset }
    ) or {}
    local out = {}
    for i = 1, #rows do push(out, rows[i]) end
    return out
end

function GetPropertyFromHousing(id)
    local all = tryCall(function()
        return exports[RESOURCE]:GetAllProperties()
    end)
    if type(all) == 'table' then
        local hit = all[id] or all[tostring(id)]
        if hit then return toMdtRecord(hit) end
        for _, prop in pairs(all) do
            if prop and prop.id == id then return toMdtRecord(prop) end
        end
    end
    return toMdtRecord(MySQL.single.await(('SELECT * FROM %s WHERE id = ?'):format(TABLE), { id }))
end

function GetPropertyByAddress(address)
    return toMdtRecord(MySQL.single.await(('SELECT * FROM %s WHERE label = ?'):format(TABLE), { address }))
end

function GetAllPropertiesFromHousing(requestedOffset, requestedLimit)
    local offset = math.max(tonumber(requestedOffset) or 0, 0)
    local limit = math.max(tonumber(requestedLimit) or 30, 1)

    local all = tryCall(function()
        return exports[RESOURCE]:GetAllProperties()
    end)
    if type(all) ~= 'table' then
        return pageFromSql(offset, limit)
    end

    local list = {}
    for _, prop in pairs(all) do list[#list + 1] = prop end
    if #list == 0 then
        return pageFromSql(offset, limit)
    end

    table.sort(list, function(a, b)
        return (a.label or '') < (b.label or '')
    end)

    local out = {}
    for i = offset + 1, math.min(offset + limit, #list) do
        push(out, list[i])
    end
    return out
end

function SearchPropertiesFromHousing(query)
    local like = '%' .. query:upper() .. '%'
    local rows = MySQL.query.await(([[
        SELECT %s.*, wsb_mdt_citizens.firstname, wsb_mdt_citizens.lastname
        FROM %s
        LEFT JOIN wsb_mdt_citizens ON %s.owner = wsb_mdt_citizens.identifier
        WHERE UPPER(%s.label) LIKE ?
           OR UPPER(%s.owner) LIKE ?
           OR UPPER(CONCAT(wsb_mdt_citizens.firstname, ' ', wsb_mdt_citizens.lastname)) LIKE ?
        LIMIT 50
    ]]):format(TABLE, TABLE, TABLE, TABLE, TABLE), { like, like, like }) or {}
    local out = {}
    for i = 1, #rows do push(out, rows[i]) end
    return out
end

function GetPropertiesByOwner(identifier)
    local owned = tryCall(function()
        return exports[RESOURCE]:GetOwnedProperties(identifier)
    end)
    if type(owned) ~= 'table' then
        local rows = MySQL.query.await(('SELECT * FROM %s WHERE owner = ?'):format(TABLE), { identifier }) or {}
        local out = {}
        for i = 1, #rows do push(out, rows[i]) end
        return out
    end

    local out = {}
    for _, row in pairs(owned) do push(out, row) end
    return out
end

function GetPropertiesCountFromHousing()
    local all = tryCall(function()
        return exports[RESOURCE]:GetAllProperties()
    end)
    if type(all) == 'table' then
        local n = 0
        for _ in pairs(all) do n = n + 1 end
        return n
    end
    return MySQL.scalar.await(('SELECT COUNT(*) FROM %s'):format(TABLE)) or 0
end

log('adapter registered')
