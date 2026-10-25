-- Property lookups across several housing scripts.
-- Every result: { source, label, address, role, coords = {x,y,z} | nil }
Housing = {}

local function safe(fn, ...)
    local ok, r = pcall(fn, ...)
    if ok then return r end
    print(('[vinewood-mdt] housing lookup error: %s'):format(r))
end

local decode = function(v) return Bridge.Decode(v) end

local function toCoords(c)
    c = decode(c)
    if type(c) ~= 'table' and type(c) ~= 'vector3' and type(c) ~= 'vector4' then return nil end
    if type(c) == 'table' then
        c = c.enter or c.entrance or c.door or c.coords or c
        if type(c) == 'string' then c = decode(c) end
    end
    local x, y, z = tonumber(c.x or c[1]), tonumber(c.y or c[2]), tonumber(c.z or c[3])
    if not x or not y then return nil end
    return { x = x, y = y, z = z or 0.0 }
end

local function isKeyholder(list, cid)
    for _, v in pairs(decode(list)) do
        if v == cid or (type(v) == 'table' and (v.citizenid == cid or v.identifier == cid)) then return true end
    end
    return false
end

---------------------------------------------------------------------------
-- RX Housing (export)
---------------------------------------------------------------------------
local function rxhousing(cid, src)
    local cfg = Config.Housing.rxhousing
    if not cfg or not cfg.enabled or not Schema.Running(cfg.resource) then return nil end
    local res = exports[cfg.resource]
    local props
    local ids = { cid }
    if src then
        for _, id in ipairs(GetPlayerIdentifiers(src)) do
            if id:find('^license:') then ids[#ids + 1] = id; ids[#ids + 1] = id:sub(9) end
        end
    end
    for _, id in ipairs(ids) do
        local r = safe(function() return res:GetOwnedProperties(id) end)
        if type(r) == 'table' and next(r) then props = r break end
    end
    if not props then return nil end

    local out = {}
    for key, p in pairs(props) do
        if type(p) == 'table' then
            out[#out + 1] = {
                source = 'RX Housing',
                label = p.label or p.name or p.id or tostring(key),
                address = p.address or p.street,
                role = 'Owner',
                coords = toCoords(p.coords or p.entrance or p.door),
            }
        elseif type(p) == 'string' or type(p) == 'number' then
            out[#out + 1] = { source = 'RX Housing', label = tostring(p), role = 'Owner' }
        end
    end
    return out
end

---------------------------------------------------------------------------
-- qbx_properties (properties table, owner = citizenid)
---------------------------------------------------------------------------
local function qbxProperties(cid)
    local cfg = Config.Housing.qbx_properties
    if not cfg or not cfg.enabled or not Schema.Running(cfg.resource) then return nil end
    if not Schema.Has('properties', 'property_name', 'owner') then return nil end
    local hasKeys = Schema.Has('properties', 'keyholders')
    local rows = MySQL.query.await(('SELECT property_name, owner, coords%s FROM properties WHERE owner = ?%s'):format(
        hasKeys and ', keyholders' or '', hasKeys and ' OR keyholders LIKE ?' or ''),
        hasKeys and { cid, '%' .. cid .. '%' } or { cid }) or {}
    local out = {}
    for _, r in ipairs(rows) do
        out[#out + 1] = {
            source = 'Properties',
            label = r.property_name,
            role = r.owner == cid and 'Owner' or (hasKeys and isKeyholder(r.keyholders, cid) and 'Keyholder' or 'Owner'),
            coords = toCoords(r.coords),
        }
    end
    return out
end

---------------------------------------------------------------------------
-- ps-housing (properties table, owner_citizenid)
---------------------------------------------------------------------------
local function psHousing(cid)
    local cfg = Config.Housing.ps_housing
    if not cfg or not cfg.enabled or not Schema.Running(cfg.resource) then return nil end
    if not Schema.Has('properties', 'property_id', 'owner_citizenid') then return nil end
    local cols = Schema.Columns('properties')
    local hasAccess = cols.has_access
    local rows = MySQL.query.await(('SELECT * FROM properties WHERE owner_citizenid = ?%s'):format(
        hasAccess and ' OR has_access LIKE ?' or ''), hasAccess and { cid, '%' .. cid .. '%' } or { cid }) or {}
    local out = {}
    for _, r in ipairs(rows) do
        local addr = {}
        if r.apartment and r.apartment ~= '' then addr[#addr + 1] = ('Flat %s, %s'):format(r.property_id, r.apartment) end
        if r.street and r.street ~= '' then addr[#addr + 1] = ('%s %s'):format(r.property_id, r.street) end
        if r.region and r.region ~= '' then addr[#addr + 1] = r.region end
        out[#out + 1] = {
            source = 'PS Housing',
            label = r.apartment and r.apartment ~= '' and ('Flat %s'):format(r.property_id) or ('Property %s'):format(r.property_id),
            address = table.concat(addr, ', '),
            role = r.owner_citizenid == cid and 'Owner' or 'Keyholder',
            coords = toCoords(r.door_data),
        }
    end
    return out
end

---------------------------------------------------------------------------
-- qb-houses / qs-housing (player_houses + houselocations)
---------------------------------------------------------------------------
local function playerHouses(cid, label, cfg)
    if not cfg or not cfg.enabled or not Schema.Running(cfg.resource) then return nil end
    if not Schema.Has('player_houses', 'house') then return nil end
    local cols = Schema.Columns('player_houses')
    local where, args = {}, {}
    if cols.citizenid then where[#where + 1] = 'ph.citizenid = ?'; args[#args + 1] = cid end
    if cols.identifier then where[#where + 1] = 'ph.identifier = ?'; args[#args + 1] = cid end
    if cols.keyholders then where[#where + 1] = 'ph.keyholders LIKE ?'; args[#args + 1] = '%' .. cid .. '%' end
    if #where == 0 then return nil end

    local join = Schema.Has('houselocations', 'name', 'label') and
        ' LEFT JOIN houselocations hl ON hl.name = ph.house' or nil
    local q = ('SELECT ph.*%s FROM player_houses ph%s WHERE %s'):format(
        join and ', hl.label AS house_label, hl.coords AS house_coords' or '', join or '', table.concat(where, ' OR '))
    local rows = MySQL.query.await(q, args) or {}
    local out = {}
    for _, r in ipairs(rows) do
        local owner = r.citizenid == cid or r.identifier == cid
        out[#out + 1] = {
            source = label,
            label = r.house_label or r.house,
            role = owner and 'Owner' or 'Keyholder',
            coords = r.house_coords and toCoords(r.house_coords) or nil,
        }
    end
    return out
end

---------------------------------------------------------------------------
-- Next Housing (Nextcore): server export GetPlayerHouses(identifier, { includeKeyAccess })
-- Owned houses and houses the player has a key to. The identifier is tried as the
-- framework character id first, then the player's licence.
---------------------------------------------------------------------------
local function nextHousing(cid, src)
    local cfg = Config.Housing.next_housing
    if not cfg or not cfg.enabled or not Schema.Running(cfg.resource) then return nil end
    local res = exports[cfg.resource]
    local ready = safe(function() return res:IsApiReady() end)
    if ready == false then return nil end

    local ids = { cid }
    if src then
        for _, id in ipairs(GetPlayerIdentifiers(src)) do
            if id:find('^license:') then ids[#ids + 1] = id end
        end
    elseif Bridge.Framework() ~= 'esx' and Schema.Has('players', 'citizenid', 'license') then
        -- Offline on Qbox/QBCore: the licence is saved with the character.
        local lic = MySQL.scalar.await('SELECT license FROM players WHERE citizenid = ?', { cid })
        if lic then ids[#ids + 1] = lic end
    end

    local houses, usedId
    for _, id in ipairs(ids) do
        local r = safe(function() return res:GetPlayerHouses(id, { includeKeyAccess = true }) end)
        -- Accept a plain list, or a wrapper like { houses = {...} } / { data = {...} }.
        if type(r) == 'table' and (r.houses or r.data) then r = r.houses or r.data end
        if type(r) == 'table' and next(r) then houses, usedId = r, id break end
    end
    if not houses then return nil end

    local mine = {}
    for _, id in ipairs(ids) do mine[id] = true end
    local out = {}
    for key, h in pairs(houses) do
        if type(h) == 'table' then
            local owner = h.ownerIdentifier or h.owner_identifier or h.owner or h.identifier
            local isOwner = owner ~= nil and mine[owner] == true
            local access = tostring(h.accessType or h.access or h.role or ''):lower()
            local role = isOwner and 'Owner'
                or (access:find('rent') or access:find('tenant')) and 'Tenant'
                or owner == nil and 'Has access'
                or 'Keyholder'
            out[#out + 1] = {
                source = 'Next Housing',
                label = h.name or h.label or h.title or (h.id and ('Property %s'):format(h.id)) or tostring(key),
                address = h.address or h.street or h.zone or h.location,
                role = role,
                coords = toCoords(h.entrance or h.entry or h.enter or h.coords or h.door or h.position),
            }
        end
    end
    return out
end

function Housing.Get(cid)
    local src = Bridge.GetSource(cid)
    local all, seen = {}, {}
    local function add(list)
        for _, p in ipairs(list or {}) do
            local key = (p.source or '') .. ':' .. tostring(p.label)
            if not seen[key] then seen[key] = true; all[#all + 1] = p end
        end
    end
    add(safe(rxhousing, cid, src))
    add(safe(nextHousing, cid, src))
    add(safe(qbxProperties, cid))
    add(safe(psHousing, cid))
    add(safe(playerHouses, cid, 'QB Houses', Config.Housing.qb_houses))
    add(safe(playerHouses, cid, 'Quasar Housing', Config.Housing.qs_housing))
    if type(Config.Housing.custom) == 'function' then add(safe(Config.Housing.custom, cid, src)) end
    return all
end
