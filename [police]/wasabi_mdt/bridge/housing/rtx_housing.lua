--[[
    wasabi_mdt v2 — rtx_housing property bridge
    https://rtx-dev.gitbook.io/rtxdev/rtx-housing-system/exports-events/server-exports
]]

local RESOURCE = 'rtx_housing'

local function log(fmt, ...)
    if select('#', ...) > 0 then
        local ok, formatted = pcall(string.format, fmt, ...)
        if ok then fmt = formatted end
    end
    lib.print.debug(('[housing:rtx] %s'):format(tostring(fmt)))
end

local TYPE_MAP = {
    mlo = 'house',
    shell = 'house',
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

local function propertyId(row)
    return row.houseid or row.id or row.propertyid or row.propertyId
end

local function pickCoords(row)
    local coords = row.enter and row.enter.coords
        or row.managment and row.managment.coords
        or row.garage and row.garage.coords
        or row.sellsign and row.sellsign.coords
        or row.storage and row.storage.coords

    if type(coords) ~= 'table' then
        return { x = 0.0, y = 0.0, z = 0.0 }
    end
    return {
        x = tonumber(coords.x or coords[1]) or 0.0,
        y = tonumber(coords.y or coords[2]) or 0.0,
        z = tonumber(coords.z or coords[3]) or 0.0,
    }
end

local function displayAddress(row)
    return row.adress or row.address or row.propertyname or row.description or 'Unknown Property'
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
    local id = propertyId(row)
    if not id then return nil end
    local now = os.time()

    return {
        id = id,
        address = displayAddress(row),
        property_type = resolveType(row.propertytype),
        owner_id = row.owner,
        coords = pickCoords(row),
        metadata = {
            original_type = row.propertytype,
            propertyName = row.propertyname,
            description = row.description,
            ownerName = row.ownername,
            owned = row.owned,
            rented = row.rented,
            rentable = row.rentable,
            purchasable = row.purchasable,
            purchasePrice = row.purchaseprice,
            rentPrice = row.rentprice,
            permissions = row.permissions,
            playersInside = row.playersinside,
            tenants = row.tenants,
            tenantsRequests = row.tenantsrequests,
            keys = row.keys,
            bills = row.bills,
            services = row.services,
            financeData = row.financedata,
            settings = row.settings,
            garage = row.garage,
            storage = row.storage,
            wardrobe = row.wardrobe,
            management = row.managment,
            doors = row.doors,
            images = row.images,
            furniture = row.furniture,
            furnitureData = row.furnituredata,
            propertyZone = row.propertyzone,
            list = row.list,
            upgrades = row.upgrades,
            visitorLog = row.visitorlog,
            starter = row.starter,
            showBlip = row.showblip,
            shellPreset = row.shellpreset,
            iplPreset = row.iplpreset,
            iplTheme = row.ipltheme,
            partOfComplex = row.partofcomplex,
            fromHousing = true,
        },
        created_at = now,
        updated_at = now,
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
    local data = tryExport('GetPropertyData', id)
    if data then return toMdtRecord(data) end

    local all = allProperties()
    if type(all) ~= 'table' then return nil end
    for _, prop in pairs(all) do
        if tostring(propertyId(prop)) == tostring(id) then
            return toMdtRecord(prop)
        end
    end
    return nil
end

function GetPropertyByAddress(address)
    local all = allProperties()
    if type(all) ~= 'table' then return nil end
    for _, prop in pairs(all) do
        local record = toMdtRecord(prop)
        if record and (
            record.address == address
            or prop.adress == address
            or prop.address == address
            or prop.propertyname == address
        ) then
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
        local left = a.adress or a.address or a.propertyname or ''
        local right = b.adress or b.address or b.propertyname or ''
        return left < right
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

    for _, prop in pairs(all) do
        local record = toMdtRecord(prop)
        if record then
            local haystack = table.concat({
                tostring(record.address or ''),
                tostring(record.owner_id or ''),
                tostring(prop.ownername or ''),
                tostring(prop.propertyname or ''),
                tostring(prop.propertytype or ''),
            }, ' '):lower()
            if haystack:find(query, 1, true) then
                out[#out + 1] = record
            end
        end
    end
    return out
end

function GetPropertiesByOwner(identifier)
    local owned = tryExport('GetPlayerOwnedProperties', identifier)
    if type(owned) == 'table' then
        local out = {}
        for _, prop in pairs(owned) do push(out, prop) end
        return out
    end

    local all = allProperties()
    local out = {}
    if type(all) == 'table' then
        for _, prop in pairs(all) do
            if tostring(prop.owner or '') == tostring(identifier) then
                push(out, prop)
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
