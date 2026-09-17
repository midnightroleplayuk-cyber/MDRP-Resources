--[[
    wasabi_mdt v2 — housing adapter template

    Copy this file to bridge/housing/<your_resource>.lua and set
    Config.SyncData.housing = '<your_resource>'. Implement the six globals below
    so properties can sync from your housing script.

    Allowed MDT property_type values: house, apartment, business, warehouse,
    garage, office, store, industrial, land, other (see Config.PropertyTypes).
]]

local RESOURCE = 'YourHousingScript'
local TABLE = 'your_housing_table'

local function log(fmt, ...)
    if select('#', ...) > 0 then
        local ok, formatted = pcall(string.format, fmt, ...)
        if ok then fmt = formatted end
    end
    lib.print.debug(('[housing:template] %s'):format(tostring(fmt)))
end

local TYPE_MAP = {
    small_house = 'house',
    medium_house = 'house',
    large_house = 'house',
    apartment = 'apartment',
    motel = 'apartment',
    office = 'office',
    warehouse = 'warehouse',
    shop = 'store',
}

local function resolveType(raw)
    local mapped = TYPE_MAP[raw] or 'other'
    local catalog = Config and Config.PropertyTypes
    if not catalog or #catalog == 0 then return mapped end
    for i = 1, #catalog do
        if catalog[i].type == mapped then return mapped end
    end
    log('unknown property_type "%s", falling back to %s', mapped, catalog[1].type)
    return catalog[1].type
end

local function normalizeCoords(raw)
    local coords = raw
    if type(coords) == 'string' then
        coords = json.decode(coords or '{}')
    end
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
        address = row.label or row.name or 'Unknown',
        property_type = resolveType(row.type),
        owner_id = row.owner or row.owner_identifier,
        coords = normalizeCoords(row.coords),
        metadata = {
            original_type = row.type,
            price = row.price,
            garage = row.garage,
            fromHousing = true,
        },
        created_at = row.created_at or now,
        updated_at = row.updated_at or now,
    }
end

local function valuesList(tbl)
    if type(tbl) ~= 'table' then return {} end
    if #tbl > 0 then return tbl end
    local out = {}
    for _, value in pairs(tbl) do
        out[#out + 1] = value
    end
    return out
end

local function push(out, row)
    local record = toMdtRecord(row)
    if record then out[#out + 1] = record end
end

local function tryExport(method, ...)
    local ok, result = pcall(function(...)
        return exports[RESOURCE][method](exports[RESOURCE], ...)
    end, ...)
    if ok then return result end
    return nil
end

function GetPropertyFromHousing(id)
    local all = tryExport('GetAllProperties')
    if type(all) == 'table' then
        local hit = all[id] or all[tostring(id)]
        if hit then return toMdtRecord(hit) end
        for _, prop in pairs(all) do
            if prop and (prop.id == id or tostring(prop.id) == tostring(id)) then
                return toMdtRecord(prop)
            end
        end
    end
    return toMdtRecord(MySQL.single.await(('SELECT * FROM %s WHERE id = ?'):format(TABLE), { id }))
end

function GetPropertyByAddress(address)
    return toMdtRecord(MySQL.single.await(
        ('SELECT * FROM %s WHERE label = ? OR name = ?'):format(TABLE),
        { address, address }
    ))
end

function GetAllPropertiesFromHousing(requestedOffset, requestedLimit)
    local offset = math.max(tonumber(requestedOffset) or 0, 0)
    local limit = math.max(tonumber(requestedLimit) or 30, 1)

    local all = tryExport('GetAllProperties')
    if type(all) == 'table' then
        local list = valuesList(all)
        table.sort(list, function(a, b)
            return (a.label or a.name or '') < (b.label or b.name or '')
        end)
        local out = {}
        for i = offset + 1, math.min(offset + limit, #list) do
            push(out, list[i])
        end
        return out
    end

    log('export unavailable; reading %s directly', TABLE)
    local rows = MySQL.query.await(
        ('SELECT * FROM %s ORDER BY label LIMIT ? OFFSET ?'):format(TABLE),
        { limit, offset }
    ) or {}
    local out = {}
    for i = 1, #rows do push(out, rows[i]) end
    return out
end

function SearchPropertiesFromHousing(query)
    local like = '%' .. query:upper() .. '%'
    local rows = MySQL.query.await(([[
        SELECT h.*, c.firstname, c.lastname
        FROM %s h
        LEFT JOIN wsb_mdt_citizens c ON h.owner = c.identifier
        WHERE UPPER(h.label) LIKE ? OR UPPER(h.owner) LIKE ?
           OR UPPER(CONCAT(c.firstname, ' ', c.lastname)) LIKE ?
        LIMIT 50
    ]]):format(TABLE), { like, like, like }) or {}
    local out = {}
    for i = 1, #rows do push(out, rows[i]) end
    return out
end

function GetPropertiesByOwner(identifier)
    local owned = tryExport('GetPlayerProperties', identifier)
    if type(owned) == 'table' then
        local out = {}
        for _, row in pairs(owned) do push(out, row) end
        return out
    end

    log('owner export unavailable; reading %s directly', TABLE)
    local rows = MySQL.query.await(
        ('SELECT * FROM %s WHERE owner = ?'):format(TABLE),
        { identifier }
    ) or {}
    local out = {}
    for i = 1, #rows do push(out, rows[i]) end
    return out
end

function GetPropertiesCountFromHousing()
    local all = tryExport('GetAllProperties')
    if type(all) == 'table' then
        local n = 0
        for _ in pairs(all) do n = n + 1 end
        return n
    end
    return MySQL.scalar.await(('SELECT COUNT(*) FROM %s'):format(TABLE)) or 0
end

log('template adapter ready (replace RESOURCE/TABLE before use)')
