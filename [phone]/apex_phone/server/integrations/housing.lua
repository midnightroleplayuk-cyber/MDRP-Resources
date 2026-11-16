-- ------------------------------------------------------------
-- INTEGRATIONS / HOUSING: known housing resources for the Home app (dispatcher: server/integrations.lua,
-- RPCs: server/house.lua). list(src, cid) returns the PUBLIC shape:
--   { id, label, owner (bool), ownerCid?, ownerName?, coords {x,y,z} (door), garage? {x,y,z}, locked? (nil = unknown),
--     tier?, keyholders? (owned houses: { { cid, name? } }), lockable? (false = this one cannot be locked from
--     the phone), keys? (false = keys cannot be given/removed for this one) }
-- lock(src, cid, id, locked) -> true | false, reason · giveKey(src, cid, id, targetSrc, targetCid) ·
-- removeKey(src, cid, id, targetCid). A resource without one of them simply does not get it: the app then
-- answers "not possible" for locking, and hides "give key" (keyMode 'none').
-- server/house.lua already checks that the house is in the player's own list (and that he OWNS it for
-- keys) before calling lock/giveKey/removeKey, because several of these exports validate nothing.
-- verified = false: written from the public docs (escrowed resource), not against its source code.
--
-- Apartments ADD-ON (PI.housingExtras): qb-apartments / qbx_apartments are not housing systems of their own
-- (one apartment per character, no keys, no lock) and usually run NEXT TO qb-houses or another housing
-- resource, so they are appended to whatever provider is active instead of replacing it.
--   Config.Integrations.apartments = 'auto' (default) | false | 'qb-apartments' | 'qbx_apartments'
-- ------------------------------------------------------------
local PI = PhoneIntegrations
if not PI then return end   -- server/integrations.lua did not load: server/integrations/escrow_check.lua says why in the console

-- a failing query RAISES: the dispatcher catches it, warns once and uses the phone's built-in behaviour
-- (swallowing it here would look like "this player has nothing")
local function q(sql, args)
    local rows = MySQL.query.await(sql, args)
    return type(rows) == 'table' and rows or {}
end

-- citizenid out of a keyholder entry: 'CID' or { citizenid / cid / identifier = 'CID' }
local function keyCid(k)
    if type(k) == 'string' or type(k) == 'number' then return tostring(k) end
    if type(k) == 'table' then
        local v = k.citizenid or k.cid or k.identifier
        if v ~= nil then return tostring(v) end
    end
    return nil
end

local function holdersExcept(list, cid)
    local out = {}
    for _, k in ipairs(type(list) == 'table' and list or {}) do
        local c = keyCid(k)
        if c and c ~= '' and c ~= cid then out[#out + 1] = { cid = c, name = type(k) == 'table' and k.name or nil } end
    end
    return out
end

-- map identifier -> data (bcs / nolag / esx_property style) -> { { cid, name? } }
local function holdersFromMap(map, cid)
    local out = {}
    if type(map) ~= 'table' then return out end
    for k, v in pairs(map) do
        local c = type(k) == 'string' and k or keyCid(v)
        if c and c ~= '' and c ~= cid then
            out[#out + 1] = { cid = c, name = type(v) == 'table' and (v.name or v.charName) or (type(v) == 'string' and v ~= c and v or nil) }
        end
    end
    table.sort(out, function(a, b) return a.cid < b.cid end)
    return out
end

local function hasValue(list, v)
    for _, x in ipairs(type(list) == 'table' and list or {}) do if keyCid(x) == v then return true end end
    return false
end

local function isArray(t)
    if type(t) ~= 'table' then return false end
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n == #t
end

-- first usable {x,y,z} among t[key] for the given keys (also one level down: coords.enter, metadata.enter)
local function firstXyz(t, keys)
    if type(t) ~= 'table' then return nil end
    for _, k in ipairs(keys) do
        local v = t[k]
        if type(v) == 'string' then v = PI.decode(v) end
        if v ~= nil then
            local inner = type(v) == 'table' and (rawget(v, 'enter') or rawget(v, 'entrance') or rawget(v, 'door')) or nil
            local c = (inner ~= nil and PI.xyz(inner)) or PI.xyz(v)
            if c then return c end
        end
    end
    return nil
end

local function str(v) if v == nil then return nil end v = tostring(v) return v ~= '' and v or nil end

local function boolOrNil(v)
    if v == true or v == 1 then return true end
    if v == false or v == 0 then return false end
    return nil
end

-- ------------------------------------------------------------
-- Sandboxed read of another resource's (open) config file. Unlike PI.readResourceTable it tolerates files
-- that call exports(...) / define functions at load (ps-housing shared/config.lua) and files that
-- `return { ... }` (qbx_apartments config/shared.lua). Nothing it runs can reach the phone.
-- ------------------------------------------------------------
local cfgFiles = {}
local function noop() end
local function readCfg(res, file, path)
    local key = res .. '|' .. file
    local e = cfgFiles[key]
    if e == nil then
        e = false
        local src = PI.started(res) and LoadResourceFile(res, file) or nil
        if type(src) == 'string' and src ~= '' then
            local sandbox = setmetatable({
                vector2 = vector2, vector3 = vector3, vector4 = vector4, vec2 = vec2, vec3 = vec3, vec4 = vec4,
                math = math, string = string, table = table, tostring = tostring, tonumber = tonumber, pairs = pairs,
                ipairs = ipairs, type = type, next = next, select = select, GetHashKey = GetHashKey, joaat = joaat,
                json = json, print = noop, GetResourceState = GetResourceState, IsDuplicityVersion = function() return true end,
                GetCurrentResourceName = function() return res end, GetConvar = function(_, d) return d end,
                exports = setmetatable({}, { __call = noop, __index = function() return setmetatable({}, { __index = function() return noop end }) end }),
            }, { __index = function() return nil end })
            local chunk = load(src, '@' .. res .. '/' .. file, 't', sandbox)
            if chunk then
                local ok, ret = pcall(chunk)
                if ok then e = { env = sandbox, ret = ret } end
            end
        end
        cfgFiles[key] = e
    end
    if not e then return nil end
    local function walk(t)
        for part in tostring(path):gmatch('[^%.]+') do
            if type(t) ~= 'table' then return nil end
            t = rawget(t, part)
        end
        return t
    end
    local v = type(e.ret) == 'table' and walk(e.ret) or nil
    if v == nil then v = walk(e.env) end
    return v
end
AddEventHandler('onResourceStart', function() cfgFiles = {} end)
AddEventHandler('onResourceStop', function() cfgFiles = {} end)

-- ------------------------------------------------------------
-- Door locks: doors a housing resource registered in a door lock resource under a KNOWN name.
--   ox_doorlock: getDoorFromName(name) -> { id, state (1 locked / 0 open), coords, characters }, setDoorState(id, 0|1)
--     (setDoorState export: ox_doorlock >= 1.13, no permission check from an export since 1.14)
--   qb-doorlock: upstream has no server exports; the copy that ps-housing ships adds getDoor(id) / updateDoor(id, data),
--     and the state goes through its own server event with sentSource = the player and unlockAnyway = true
--     (house.lua has already checked the player has a key). Without getDoor the door id cannot be confirmed: not used.
-- doors_creator / nui_doorlock: no housing resource below names its doors there in a predictable way, so they
-- are not used (nui_doorlock cannot even be driven from the server without a player check crash).
-- ------------------------------------------------------------
local Doors = {}

function Doors.get(name)
    if PI.started('ox_doorlock') then
        local ok, d = PI.callExport('ox_doorlock', 'getDoorFromName', name)
        if ok and type(d) == 'table' and d.id ~= nil then
            return { kind = 'ox', id = d.id, coords = PI.xyz(d.coords), locked = boolOrNil(d.state), raw = d }
        end
    end
    if PI.started('qb-doorlock') then
        local ok, d = PI.callExport('qb-doorlock', 'getDoor', name)
        if ok and type(d) == 'table' then
            local c = d.objCoords or d.textCoords or (type(d.doors) == 'table' and type(d.doors[1]) == 'table' and d.doors[1].objCoords) or nil
            return { kind = 'qb', id = name, coords = PI.xyz(c), locked = boolOrNil(d.locked), raw = d }
        end
    end
    return nil
end

function Doors.set(door, locked, src)
    if door.kind == 'ox' then
        local ok, r = PI.callExport('ox_doorlock', 'setDoorState', door.id, locked and 1 or 0)
        return ok and r ~= false
    elseif door.kind == 'qb' then
        if not (src and FW.GetPlayer(src)) then return false end
        TriggerEvent('qb-doorlock:server:updateState', door.id, locked == true, false, false, true, true, true, src)
        return true
    end
    return false
end

-- add / remove a citizenid on the door's own access list (what ps-housing's addMloDoorsAccess does)
function Doors.access(door, cid, add)
    if door.kind == 'ox' then
        local list = {}
        for _, c in ipairs(type(door.raw.characters) == 'table' and door.raw.characters or {}) do if c ~= cid then list[#list + 1] = c end end
        if add then list[#list + 1] = cid end
        PI.callExport('ox_doorlock', 'editDoor', door.id, { characters = list })
    elseif door.kind == 'qb' then
        local map = {}
        for k, v in pairs(type(door.raw.authorizedCitizenIDs) == 'table' and door.raw.authorizedCitizenIDs or {}) do map[k] = v end
        map[cid] = add and true or nil
        PI.callExport('qb-doorlock', 'updateDoor', door.id, { authorizedCitizenIDs = map })
    end
end

PI.Doors = Doors

-- ------------------------------------------------------------
-- qb-houses: the builtin already speaks to it
-- ------------------------------------------------------------
PI.define('housing', 'qb-houses', { label = 'qb-houses', resources = { 'qb-houses' }, aliasBuiltin = true })

-- ------------------------------------------------------------
-- ps-housing (VERIFIED against ps-housing 2.0.8 source)
--   properties (property_id, owner_citizenid, street, region, apartment, shell, has_access JSON, door_data JSON,
--   garage_data JSON). The resource caches every property in memory: keys only through its server-local
--   'ps-housing:server:updateProperty' 'UpdateHas_access' (memory + DB + clients), never by SQL.
--   Door coords: shell = door_data {x,y,z,h}; apartment = Config.Apartments[apartment].door (shared/config.lua);
--   MLO = door_data { count = N } and the doors 'ps_mloproperty<id>_<n>' in ox_doorlock / qb-doorlock.
--   Lock: only MLO doors (shells and apartments have no lock in ps-housing). Keys on an MLO also update the
--   doors' access lists, like ps-housing's own addAccess / removeAccess do.
-- ------------------------------------------------------------
local function psRow(id)
    return q('SELECT property_id, owner_citizenid, shell, has_access, door_data FROM properties WHERE property_id = ? LIMIT 1', { id })[1]
end

local function psDoors(id, door)
    local n = tonumber(type(door) == 'table' and door.count or nil)
    local out = {}
    if not n or n < 1 then return out end
    for i = 1, math.min(n, 32) do
        local d = Doors.get(('ps_mloproperty%s_%s'):format(id, i))
        if d then out[#out + 1] = d end
    end
    return out
end

local function psSetAccess(id, row, list, cid, add)
    TriggerEvent('ps-housing:server:updateProperty', 'UpdateHas_access', tostring(id), list)
    if row.shell == 'mlo' then
        for _, d in ipairs(psDoors(id, PI.decode(row.door_data))) do Doors.access(d, cid, add) end
    end
end

PI.define('housing', 'ps-housing', {
    label = 'ps-housing', resources = { 'ps-housing' },
    list = function(src, cid)
        local out = {}
        for _, r in ipairs(q('SELECT property_id, owner_citizenid, street, region, apartment, shell, has_access, door_data, garage_data FROM properties WHERE owner_citizenid = ? OR has_access LIKE ?', { cid, '%"' .. cid .. '"%' })) do
            local access = PI.decode(r.has_access)
            local mine = r.owner_citizenid == cid
            if mine or hasValue(access, cid) then
                local door = PI.decode(r.door_data)
                local apt = (r.apartment and r.apartment ~= '') and tostring(r.apartment) or nil
                local coords, locked, lockable = nil, nil, false
                if apt then
                    local a = readCfg('ps-housing', 'shared/config.lua', 'Config.Apartments')
                    coords = type(a) == 'table' and type(a[apt]) == 'table' and PI.xyz(a[apt].door) or nil
                elseif r.shell == 'mlo' or door.count then
                    local doors = psDoors(r.property_id, door)
                    if doors[1] then
                        coords, locked, lockable = doors[1].coords, doors[1].locked, true
                    end
                else
                    coords = PI.xyz(door)
                end
                local label = apt and (apt .. ' ' .. tostring(r.property_id))
                    or (tostring(r.street or 'Casa') .. ((r.region and r.region ~= '') and (', ' .. tostring(r.region)) or ''))
                out[#out + 1] = {
                    id = tostring(r.property_id), label = label, owner = mine, ownerCid = r.owner_citizenid,
                    coords = coords, garage = PI.xyz(r.garage_data), tier = apt and 1 or 3, locked = locked, lockable = lockable,
                    keyholders = mine and holdersExcept(access, cid) or nil,
                }
            end
        end
        return out
    end,
    lock = function(src, cid, id, locked)
        local r = psRow(id)
        local doors = r and psDoors(id, PI.decode(r.door_data)) or {}
        if not doors[1] then return false, 'nolock' end
        local any = false
        for _, d in ipairs(doors) do if Doors.set(d, locked, src) then any = true end end
        return any, any and nil or 'nolock'
    end,
    giveKey = function(src, cid, id, targetSrc, targetCid)
        local r = psRow(id)
        if not r or r.owner_citizenid ~= cid then return false, 'nokey' end
        local access = {}
        for _, k in ipairs(PI.decode(r.has_access)) do access[#access + 1] = k end
        if not hasValue(access, targetCid) then access[#access + 1] = targetCid end   -- re-sent anyway: idempotent
        psSetAccess(id, r, access, targetCid, true)
        return true
    end,
    removeKey = function(src, cid, id, targetCid)
        local r = psRow(id)
        if not r or r.owner_citizenid ~= cid then return false, 'nokey' end
        local access = {}
        for _, k in ipairs(PI.decode(r.has_access)) do if k ~= targetCid then access[#access + 1] = k end end
        psSetAccess(id, r, access, targetCid, false)
        return true
    end,
})

-- ------------------------------------------------------------
-- qbx_properties (VERIFIED against Qbox source): properties (id, property_name, coords JSON, owner, keyholders JSON,
-- garage JSON). No lock concept and no exports; its own key events need the owner INSIDE the property. Keys are a
-- column the resource re-reads on every check (no cache), so the phone writes it the same way qbx_properties does.
-- Apartments are ordinary rows here (shown with the others).
-- ------------------------------------------------------------
PI.define('housing', 'qbx_properties', {
    label = 'qbx_properties', resources = { 'qbx_properties' },
    list = function(src, cid)
        local out = {}
        for _, r in ipairs(q('SELECT id, property_name, coords, owner, keyholders, garage FROM properties WHERE owner = ? OR keyholders LIKE ?', { cid, '%"' .. cid .. '"%' })) do
            local keys = PI.decode(r.keyholders)
            local mine = r.owner == cid
            if mine or hasValue(keys, cid) then
                out[#out + 1] = { id = tostring(r.id), label = r.property_name or ('#' .. tostring(r.id)), owner = mine, ownerCid = r.owner,
                    coords = PI.xyz(r.coords), garage = PI.xyz(r.garage), tier = 3, lockable = false, keyholders = mine and holdersExcept(keys, cid) or nil }
            end
        end
        return out
    end,
    giveKey = function(src, cid, id, targetSrc, targetCid)
        local r = q('SELECT keyholders FROM properties WHERE id = ? AND owner = ? LIMIT 1', { id, cid })[1]
        if not r then return false, 'nokey' end
        local keys = {}
        for _, k in ipairs(PI.decode(r.keyholders)) do keys[#keys + 1] = k end
        if not hasValue(keys, targetCid) then keys[#keys + 1] = targetCid end
        MySQL.update.await('UPDATE properties SET keyholders = ? WHERE id = ? AND owner = ?', { json.encode(keys), id, cid })
        return true
    end,
    removeKey = function(src, cid, id, targetCid)
        local r = q('SELECT keyholders FROM properties WHERE id = ? AND owner = ? LIMIT 1', { id, cid })[1]
        if not r then return false, 'nokey' end
        local keys = {}
        for _, k in ipairs(PI.decode(r.keyholders)) do if k ~= targetCid then keys[#keys + 1] = k end end
        MySQL.update.await('UPDATE properties SET keyholders = ? WHERE id = ? AND owner = ?', { (#keys > 0) and json.encode(keys) or '[]', id, cid })
        return true
    end,
})

-- ------------------------------------------------------------
-- esx_property
--   2.x (VERIFIED against ESX-Legacy-Addons esx_property 2.0): data lives in properties.json; the exports are
--   READ-ONLY (lock and keys are player callbacks inside esx_property), so the app lists the houses with GPS,
--   garage and the real lock state, and cannot lock or give keys from the phone.
--   1.x legacy (VERIFIED against the old esx_property: owned_properties + properties tables, no exports, no keys,
--   no lock): used automatically when the 2.x export does not exist.
-- ------------------------------------------------------------
local function esxLegacyList(cid)
    local out = {}
    for _, r in ipairs(q('SELECT o.id, o.name, o.rented, p.label, p.entering, p.gateway FROM owned_properties o LEFT JOIN properties p ON p.name = o.name WHERE o.owner = ?', { cid })) do
        local coords = PI.xyz(r.entering)
        if not coords and r.gateway and r.gateway ~= '' then
            local g = q('SELECT entering FROM properties WHERE name = ? LIMIT 1', { r.gateway })[1]
            coords = g and PI.xyz(g.entering) or nil
        end
        out[#out + 1] = { id = tostring(r.name), label = r.label or tostring(r.name), owner = true, coords = coords, tier = 3,
            lockable = false, keys = false, keyholders = {} }
    end
    return out
end

PI.define('housing', 'esx_property', {
    label = 'esx_property (read-only)', resources = { 'esx_property' },
    list = function(src, cid)
        local ok, all = PI.callExport('esx_property', 'GetProperties')
        if not ok then
            if tostring(all):find('No such export', 1, true) then return esxLegacyList(cid) end
            error('esx_property:GetProperties failed: ' .. tostring(all))
        end
        if type(all) ~= 'table' then error('esx_property:GetProperties returned ' .. type(all)) end
        local out = {}
        for i, h in pairs(all) do
            if type(h) == 'table' then
                local keys = type(h.Keys) == 'table' and h.Keys or {}
                local mine = h.Owner == cid
                if mine or keys[cid] ~= nil then
                    local g = type(h.garage) == 'table' and h.garage.enabled and PI.xyz(h.garage.pos) or nil
                    out[#out + 1] = { id = tostring(i), label = h.setName ~= nil and h.setName ~= '' and h.setName or h.Name or ('#' .. tostring(i)),
                        owner = mine, ownerCid = h.Owner, coords = PI.xyz(h.Entrance), garage = g or nil, locked = h.Locked == true, tier = 3,
                        keyholders = mine and holdersFromMap(keys, cid) or nil }
                end
            end
        end
        return out
    end,
})

-- ------------------------------------------------------------
-- qs-housing (Quasar, escrowed; verified = false): houselocations (name, label, coords JSON {enter}, garage JSON,
-- tier) + player_houses (house, citizenid, keyholders JSON), the qb-houses lineage (table layout from Quasar's
-- install SQL). Lock state and keys live in the resource's memory and the documented server exports cover
-- neither (only physical key ITEMS), so the app lists houses only.
-- ------------------------------------------------------------
PI.define('housing', 'qs-housing', {
    label = 'qs-housing (list only)', resources = { 'qs-housing' }, verified = false,
    list = function(src, cid)
        local rows = q('SELECT house, citizenid, keyholders FROM player_houses WHERE citizenid = ? OR keyholders LIKE ?', { cid, '%"' .. cid .. '"%' })
        if #rows == 0 then return {} end
        local names, info, marks = {}, {}, {}
        for _, r in ipairs(rows) do
            local keys = PI.decode(r.keyholders)
            local mine = r.citizenid == cid
            if r.house and (mine or hasValue(keys, cid)) and not info[r.house] then
                names[#names + 1] = r.house info[r.house] = { mine = mine, owner = r.citizenid, keys = keys } marks[#marks + 1] = '?'
            end
        end
        if #names == 0 then return {} end
        local out = {}
        for _, l in ipairs(q(('SELECT name, label, coords, garage, tier FROM houselocations WHERE name IN (%s)'):format(table.concat(marks, ',')), names)) do
            local h = info[l.name]
            if h then
                local c = PI.decode(l.coords)
                out[#out + 1] = { id = l.name, label = l.label or l.name, owner = h.mine, ownerCid = h.owner, coords = PI.xyz(c.enter or c),
                    garage = PI.xyz(l.garage), tier = tonumber(l.tier), lockable = false, keyholders = h.mine and holdersExcept(h.keys, cid) or nil }
            end
        end
        return out
    end,
})

-- ------------------------------------------------------------
-- bcs_housing (DOCS, verified = false; docs.baguscodestudio.com, server exports + Home object):
--   GetOwnedHomeKeys(identifier) (owned + keyed), GetKeyHolders(id) map identifier -> { name, key },
--   isLocked(id) / LockHome(id) (a TOGGLE, "only for IPL or Shell type"), GetKeyList(id), AddKeyHolder(id,
--   targetSrc, keyName), RemoveKeyHolder(id, identifier). Home: identifier, name, type, entry, locked, owner,
--   data.garage. The exports validate nothing: house.lua does.
-- ------------------------------------------------------------
PI.define('housing', 'bcs_housing', {
    label = 'bcs_housing', resources = { 'bcs_housing' }, verified = false,
    list = function(src, cid)
        local ok, homes = PI.callExport('bcs_housing', 'GetOwnedHomeKeys', cid)
        if not ok or type(homes) ~= 'table' then error('bcs_housing:GetOwnedHomeKeys failed: ' .. tostring(homes)) end
        local out = {}
        for k, h in pairs(homes) do
            h = type(h) == 'table' and (type(h.properties) == 'table' and h.properties or h) or nil
            local id = h and str(h.identifier or h.id or (type(k) == 'string' and k or nil))
            if id then
                local mine = h.owner == cid
                local holders
                if mine then
                    local okK, kh = PI.callExport('bcs_housing', 'GetKeyHolders', id)
                    holders = holdersFromMap(okK and kh or nil, cid)
                end
                local g = type(h.data) == 'table' and h.data.garage or nil
                out[#out + 1] = { id = id, label = h.name or id, owner = mine, ownerCid = h.owner, coords = PI.xyz(h.entry),
                    garage = PI.xyz(g), locked = boolOrNil(h.locked), tier = (h.complex == 'Apartment' or h.complex == 'Flat') and 1 or 3,
                    lockable = h.type ~= 'mlo', keyholders = holders }
            end
        end
        return out
    end,
    lock = function(src, cid, id, locked)
        local ok, cur = PI.callExport('bcs_housing', 'isLocked', id)
        if ok and type(cur) == 'boolean' and cur == (locked == true) then return true end
        -- no read-back after the toggle: if bcs updated the state later, a "failed" answer would make the player
        -- tap again and toggle it back (MLO homes, where LockHome does nothing, are lockable = false in the list)
        local okT = PI.callExport('bcs_housing', 'LockHome', id)
        if not okT then return false, 'failed' end
        return true
    end,
    giveKey = function(src, cid, id, targetSrc, targetCid)
        local okL, list = PI.callExport('bcs_housing', 'GetKeyList', id)
        local keyName
        if okL and type(list) == 'table' then
            local names = {}
            for name, v in pairs(list) do
                if type(name) == 'string' then names[#names + 1] = name
                elseif type(v) == 'table' and (v.name or v.label) then names[#names + 1] = tostring(v.name or v.label)
                elseif type(v) == 'string' then names[#names + 1] = v end
            end
            table.sort(names)
            keyName = names[1]
        end
        if keyName == nil then return false, 'nokeyname' end
        local ok, r = PI.callExport('bcs_housing', 'AddKeyHolder', id, targetSrc, keyName)
        return ok and r ~= false
    end,
    removeKey = function(src, cid, id, targetCid)
        local ok, r = PI.callExport('bcs_housing', 'RemoveKeyHolder', id, targetCid)
        return ok and r ~= false
    end,
})

-- ------------------------------------------------------------
-- nolag_properties (DOCS, verified = false; teamsgg.dev server exports): GetAllProperties(owner, 'user', true)
-- (id, label, doorLocked, coords, hasKey), GetPropertyData(id) (owner, keyHolders...), GetKeyHolders(id) map
-- identifier -> locks, ToggleDoorlock(src, id, locked) (sets the given state), AddKey / RemoveKey(src, id,
-- identifier). Passing the player's src lets the resource apply its own permission checks.
-- The list export does not return the owner: GetPropertyData tells owned from keyed.
-- ------------------------------------------------------------
PI.define('housing', 'nolag_properties', {
    label = 'nolag_properties', resources = { 'nolag_properties' }, verified = false,
    list = function(src, cid)
        local ok, props = PI.callExport('nolag_properties', 'GetAllProperties', cid, 'user', true)
        if not ok or type(props) ~= 'table' then error('nolag_properties:GetAllProperties failed: ' .. tostring(props)) end
        local out = {}
        for _, h in pairs(props) do
            if type(h) == 'table' and h.id ~= nil then
                local okD, data = PI.callExport('nolag_properties', 'GetPropertyData', h.id)
                local owner = okD and type(data) == 'table' and data.owner or nil
                local mine
                if owner ~= nil then mine = tostring(owner) == cid else mine = h.hasKey ~= true end
                local holders
                if mine then
                    local okK, kh = PI.callExport('nolag_properties', 'GetKeyHolders', h.id)
                    holders = holdersFromMap(okK and kh or nil, cid)
                end
                out[#out + 1] = { id = tostring(h.id), label = h.label or ('#' .. tostring(h.id)), owner = mine, ownerCid = owner and tostring(owner) or nil,
                    coords = PI.xyz(h.coords), locked = boolOrNil(h.doorLocked), tier = 3, keyholders = holders }
            end
        end
        return out
    end,
    lock = function(src, cid, id, locked)
        local ok, r = PI.callExport('nolag_properties', 'ToggleDoorlock', src, tonumber(id) or id, locked == true)
        return ok and r ~= false
    end,
    giveKey = function(src, cid, id, targetSrc, targetCid)
        local ok, r = PI.callExport('nolag_properties', 'AddKey', src, tonumber(id) or id, targetCid)
        return ok and r ~= false
    end,
    removeKey = function(src, cid, id, targetCid)
        local ok, r = PI.callExport('nolag_properties', 'RemoveKey', src, tonumber(id) or id, targetCid)
        return ok and r ~= false
    end,
})

-- ------------------------------------------------------------
-- kartik-properties (DOCS, verified = false; kartik-scripts.gitbook.io server exports, made for phones):
--   GetPlayerHousingData(cid) -> { houseId, label, coords {x,y,z}, keyholders { name, identifier, isowner }, owner, locked }
--   (owned + rented + keyed), SetPropertyLocked(id, locked) -> { success }, GrantHousingKey(id, targetCid, byCid)
--   -> { success, data, msg }, RevokeHousingKey(id, targetCid, byCid) -> { success }.
-- ------------------------------------------------------------
local function kpOk(ok, r)
    if not ok then return false, 'failed' end
    if type(r) == 'table' then return r.success == true, (r.success ~= true) and 'failed' or nil end
    return r ~= false
end

PI.define('housing', 'kartik-properties', {
    label = 'kartik-properties', resources = { 'kartik-properties' }, verified = false,
    list = function(src, cid)
        local ok, rows = PI.callExport('kartik-properties', 'GetPlayerHousingData', cid)
        if not ok or type(rows) ~= 'table' then error('kartik-properties:GetPlayerHousingData failed: ' .. tostring(rows)) end
        local out = {}
        for _, h in ipairs(rows) do
            local id = type(h) == 'table' and str(h.houseId or h.id) or nil
            if id then
                local mine = h.owner ~= nil and tostring(h.owner) == cid
                local holders
                if mine then
                    holders = {}
                    for _, k in ipairs(type(h.keyholders) == 'table' and h.keyholders or {}) do
                        local c = type(k) == 'table' and str(k.identifier) or nil
                        if c and c ~= cid and not k.isowner then holders[#holders + 1] = { cid = c, name = k.name } end
                    end
                end
                out[#out + 1] = { id = id, label = h.label or ('#' .. id), owner = mine, ownerCid = h.owner and tostring(h.owner) or nil,
                    coords = PI.xyz(h.coords), locked = boolOrNil(h.locked), tier = 3, keyholders = holders }
            end
        end
        return out
    end,
    lock = function(src, cid, id, locked)
        return kpOk(PI.callExport('kartik-properties', 'SetPropertyLocked', tonumber(id) or id, locked == true))
    end,
    giveKey = function(src, cid, id, targetSrc, targetCid)
        return kpOk(PI.callExport('kartik-properties', 'GrantHousingKey', tonumber(id) or id, targetCid, cid))
    end,
    removeKey = function(src, cid, id, targetCid)
        return kpOk(PI.callExport('kartik-properties', 'RevokeHousingKey', tonumber(id) or id, targetCid, cid))
    end,
})

-- ------------------------------------------------------------
-- tk_housing v2 (DOCS, verified = false; tk-scripts.gitbook.io server exports):
--   getPropertiesByIdentifier(identifier) / getProperties() -> { id, address, name?, owner?, coords (vector3), type },
--   getPropertyKeyholders(id) -> { { identifier, name, permissions } }, isPropertyLocked(id),
--   setPropertyLocked(id, locked) -> bool, addPropertyKeyholder / removePropertyKeyholder(id, identifier) -> bool.
--   Keyed properties: there is no "by keyholder" export, so the other OWNED properties are scanned (capped).
-- ------------------------------------------------------------
local TK_SCAN_MAX = 600

local function tkHouse(p, cid, mine)
    local id = str(p.id)
    local okL, lk = PI.callExport('tk_housing', 'isPropertyLocked', p.id)
    local locked = nil
    if okL then locked = boolOrNil(lk) end
    local holders
    if mine then
        local okK, kh = PI.callExport('tk_housing', 'getPropertyKeyholders', p.id)
        holders = (okK and isArray(kh)) and holdersExcept(kh, cid) or holdersFromMap(okK and kh or nil, cid)
    end
    return { id = id, label = p.name or p.address or ('#' .. id), owner = mine, ownerCid = p.owner and tostring(p.owner) or nil,
        coords = PI.xyz(p.coords), locked = locked, tier = 3, keyholders = holders }
end

PI.define('housing', 'tk_housing', {
    label = 'tk_housing', resources = { 'tk_housing' }, verified = false,
    list = function(src, cid)
        local ok, own = PI.callExport('tk_housing', 'getPropertiesByIdentifier', cid)
        if not ok or type(own) ~= 'table' then error('tk_housing:getPropertiesByIdentifier failed: ' .. tostring(own)) end
        local out, seen = {}, {}
        for _, p in pairs(own) do
            if type(p) == 'table' and p.id ~= nil and not seen[tostring(p.id)] then
                seen[tostring(p.id)] = true
                out[#out + 1] = tkHouse(p, cid, true)
            end
        end
        local okA, all = PI.callExport('tk_housing', 'getProperties')
        if okA and type(all) == 'table' then
            local n = 0
            for _, p in pairs(all) do
                if type(p) == 'table' and p.id ~= nil and p.owner ~= nil and not seen[tostring(p.id)] then
                    n = n + 1
                    if n > TK_SCAN_MAX then break end
                    local okK, kh = PI.callExport('tk_housing', 'getPropertyKeyholders', p.id)
                    if okK and type(kh) == 'table' then
                        local has = false
                        for k, v in pairs(kh) do if keyCid(v) == cid or k == cid then has = true break end end
                        if has then seen[tostring(p.id)] = true out[#out + 1] = tkHouse(p, cid, false) end
                    end
                end
            end
        end
        return out
    end,
    lock = function(src, cid, id, locked)
        local ok, r = PI.callExport('tk_housing', 'setPropertyLocked', tonumber(id) or id, locked == true)
        return ok and r ~= false
    end,
    giveKey = function(src, cid, id, targetSrc, targetCid)
        local ok, r = PI.callExport('tk_housing', 'addPropertyKeyholder', tonumber(id) or id, targetCid)
        return ok and r ~= false
    end,
    removeKey = function(src, cid, id, targetCid)
        local ok, r = PI.callExport('tk_housing', 'removePropertyKeyholder', tonumber(id) or id, targetCid)
        return ok and r ~= false
    end,
})

-- ------------------------------------------------------------
-- vms_housing (DOCS, verified = false; docs.vames-store.com server exports + its documented example object):
--   GetPlayerProperties(identifier) (owned / rented), GetAllProperties(), GetProperty(id), HasKeys(src, identifier, id).
--   Property: id, name, address, owner, owner_name, renter, object_id (apartment -> building), keys (JSON:
--   serials when keys are items (default), or identifier -> name), metadata { enter, garage, locked }.
--   No server export to lock or to give / remove keys (its own key events are player events): list only.
--   The resource caches everything in memory: never written by SQL.
-- ------------------------------------------------------------
local VMS_SCAN_MAX = 600

local function vmsMeta(p) return PI.decode(p.metadata) end

local function vmsHouse(p, cid, mine, buildings)
    local id = str(p.id)
    local m = vmsMeta(p)
    local coords = PI.xyz(m.enter)
    if p.object_id ~= nil and tostring(p.object_id) ~= '' then
        local key = tostring(p.object_id)
        if buildings[key] == nil then
            local okB, b = PI.callExport('vms_housing', 'GetProperty', p.object_id)
            buildings[key] = (okB and type(b) == 'table') and b or false
        end
        local b = buildings[key]
        if b then coords = PI.xyz(vmsMeta(b).enter) or coords end
    end
    local holders
    if mine then
        local keys = PI.decode(p.keys)
        holders = isArray(keys) and {} or holdersFromMap(keys, cid)   -- serial numbers say nothing about people
    end
    return { id = id, label = (p.name and p.name ~= '') and p.name or p.address or ('#' .. id), owner = mine,
        ownerCid = p.owner and tostring(p.owner) or nil, ownerName = (not mine) and str(p.owner_name) or nil,
        coords = coords or PI.xyz(m.menu), garage = PI.xyz(m.garage), locked = boolOrNil(m.locked),
        tier = p.object_id and 1 or 3, keyholders = holders }
end

PI.define('housing', 'vms_housing', {
    label = 'vms_housing (list only)', resources = { 'vms_housing' }, verified = false,
    list = function(src, cid)
        local ok, own = PI.callExport('vms_housing', 'GetPlayerProperties', cid)
        if not ok or type(own) ~= 'table' then error('vms_housing:GetPlayerProperties failed: ' .. tostring(own)) end
        if own.id ~= nil then own = { own } end
        local out, seen, buildings = {}, {}, {}
        for _, p in pairs(own) do
            if type(p) == 'table' and p.id ~= nil and not seen[tostring(p.id)] then
                seen[tostring(p.id)] = true
                out[#out + 1] = vmsHouse(p, cid, p.owner ~= nil and tostring(p.owner) == cid, buildings)
            end
        end
        -- keyed: keys stored as identifiers, or (keys as items) HasKeys on the player
        local okA, all = PI.callExport('vms_housing', 'GetAllProperties')
        if okA and type(all) == 'table' then
            local n = 0
            for _, p in pairs(all) do
                if type(p) == 'table' and p.id ~= nil and p.owner ~= nil and tostring(p.owner) ~= '' and not seen[tostring(p.id)] then
                    n = n + 1
                    if n > VMS_SCAN_MAX then break end
                    local keys = PI.decode(p.keys)
                    local has = false
                    if not isArray(keys) then has = keys[cid] ~= nil
                    elseif #keys > 0 and src then
                        local okH, r = PI.callExport('vms_housing', 'HasKeys', src, cid, p.id)
                        has = okH and r == true
                    end
                    if has then seen[tostring(p.id)] = true out[#out + 1] = vmsHouse(p, cid, false, buildings) end
                end
            end
        end
        return out
    end,
})

-- ------------------------------------------------------------
-- RxHousing (DOCS, verified = false; docs.rxscripts.xyz server exports): GetOwnedProperties(identifier),
-- GetAllProperties(), GetPropertyKeyholders(id), HasKey(id, identifier), AddKeyholder / RemoveKeyholder(id,
-- identifier) -> bool. No lock export. Property field names are not documented: read defensively.
-- ------------------------------------------------------------
local RX_SCAN_MAX = 600

local function rxHouse(p, key, cid, mine)
    local id = str(p.id or p.propertyId or p.property_id or (type(key) ~= 'number' and key or nil))
    if not id then return nil end
    local holders
    if mine then
        local okK, kh = PI.callExport('RxHousing', 'GetPropertyKeyholders', tonumber(id) or id)
        holders = (okK and isArray(kh)) and holdersExcept(kh, cid) or holdersFromMap(okK and kh or nil, cid)
    end
    return { id = id, label = p.label or p.name or p.address or ('#' .. id), owner = mine, ownerCid = p.owner and tostring(p.owner) or nil,
        coords = firstXyz(p, { 'entrance', 'enter', 'coords', 'door', 'entry', 'position' }), garage = firstXyz(p, { 'garage', 'garageCoords' }),
        locked = boolOrNil(p.locked), lockable = false, tier = 3, keyholders = holders }
end

PI.define('housing', 'RxHousing', {
    label = 'RxHousing', resources = { 'RxHousing' }, verified = false,
    list = function(src, cid)
        local ok, own = PI.callExport('RxHousing', 'GetOwnedProperties', cid)
        if not ok or type(own) ~= 'table' then error('RxHousing:GetOwnedProperties failed: ' .. tostring(own)) end
        local out, seen = {}, {}
        for k, p in pairs(own) do
            local h = type(p) == 'table' and rxHouse(p, k, cid, true) or nil
            if h and not seen[h.id] then seen[h.id] = true out[#out + 1] = h end
        end
        local okA, all = PI.callExport('RxHousing', 'GetAllProperties')
        if okA and type(all) == 'table' then
            local n = 0
            for k, p in pairs(all) do
                if type(p) == 'table' and p.owner ~= nil then
                    local id = str(p.id or p.propertyId or p.property_id or (type(k) ~= 'number' and k or nil))
                    if id and not seen[id] and tostring(p.owner) ~= cid then
                        n = n + 1
                        if n > RX_SCAN_MAX then break end
                        local okH, has = PI.callExport('RxHousing', 'HasKey', tonumber(id) or id, cid)
                        if okH and has == true then
                            local h = rxHouse(p, k, cid, false)
                            if h then seen[id] = true out[#out + 1] = h end
                        end
                    end
                end
            end
        end
        return out
    end,
    giveKey = function(src, cid, id, targetSrc, targetCid)
        local ok, r = PI.callExport('RxHousing', 'AddKeyholder', tonumber(id) or id, targetCid)
        return ok and r ~= false
    end,
    removeKey = function(src, cid, id, targetCid)
        local ok, r = PI.callExport('RxHousing', 'RemoveKeyholder', tonumber(id) or id, targetCid)
        return ok and r ~= false
    end,
})

-- ------------------------------------------------------------
-- origen_housing (DOCS, verified = false; docs.origennetwork.com): getOwnedHouses(citizenid). No server export
-- for keys, and its door exports need door ids the phone does not know: owned houses only, list only.
-- ------------------------------------------------------------
PI.define('housing', 'origen_housing', {
    label = 'origen_housing (list only)', resources = { 'origen_housing' }, verified = false,
    list = function(src, cid)
        local ok, own = PI.callExport('origen_housing', 'getOwnedHouses', cid)
        if not ok or type(own) ~= 'table' then error('origen_housing:getOwnedHouses failed: ' .. tostring(own)) end
        local out = {}
        for k, p in pairs(own) do
            if type(p) == 'table' then
                local id = str(p.id or p.houseID or p.houseId or (type(k) ~= 'number' and k or nil))
                if id then
                    out[#out + 1] = { id = id, label = p.label or p.name or p.address or ('#' .. id), owner = true,
                        coords = firstXyz(p, { 'entrance', 'enter', 'coords', 'door', 'entry', 'position' }),
                        garage = firstXyz(p, { 'garage', 'garageCoords' }), locked = boolOrNil(p.locked), lockable = false, keys = false,
                        tier = 3, keyholders = {} }
                end
            end
        end
        return out
    end,
})

-- ------------------------------------------------------------
-- ak47_housing (ESX) / ak47_qb_housing (QB) (DOCS, verified = false; docs.menanak47.com integration pages):
-- table named after the resource with id, owner (citizenid / ESX identifier), enter JSON {x,y,z}. No server
-- exports: owned houses, list only.
-- ------------------------------------------------------------
for _, res in ipairs({ 'ak47_qb_housing', 'ak47_housing' }) do
    PI.define('housing', res, {
        label = res .. ' (list only)', resources = { res }, verified = false,
        list = function(src, cid)
            local out = {}
            for _, r in ipairs(q(('SELECT id, enter FROM `%s` WHERE owner = ?'):format(res), { cid })) do
                out[#out + 1] = { id = tostring(r.id), label = 'Casa ' .. tostring(r.id), owner = true, coords = PI.xyz(r.enter),
                    tier = 3, lockable = false, keys = false, keyholders = {} }
            end
            return out
        end,
    })
end

-- ------------------------------------------------------------
-- loaf_housing (verified = false): loaf_properties (owner, propertyid) + loaf_houses (id, label, entrance JSON,
-- garage_entrance JSON) (columns from loaf's own convert script). Keys and locks go through loaf_keysystem
-- items whose key ids are not documented: list only.
-- ------------------------------------------------------------
PI.define('housing', 'loaf_housing', {
    label = 'loaf_housing (list only)', resources = { 'loaf_housing' }, verified = false,
    list = function(src, cid)
        local out = {}
        for _, r in ipairs(q('SELECT p.propertyid, h.label, h.entrance, h.garage_entrance FROM loaf_properties p LEFT JOIN loaf_houses h ON h.id = p.propertyid WHERE p.owner = ?', { cid })) do
            out[#out + 1] = { id = tostring(r.propertyid), label = r.label or ('#' .. tostring(r.propertyid)), owner = true,
                coords = PI.xyz(r.entrance), garage = PI.xyz(r.garage_entrance), tier = 3, lockable = false, keys = false, keyholders = {} }
        end
        return out
    end,
})

-- 'auto' order: the dedicated housing resources first; the framework defaults (qb-houses, esx_property) last,
-- because they are often left running next to the real one
PI.order.housing = { 'ps-housing', 'kartik-properties', 'tk_housing', 'nolag_properties', 'bcs_housing', 'vms_housing', 'qs-housing',
    'RxHousing', 'origen_housing', 'ak47_qb_housing', 'ak47_housing', 'loaf_housing', 'qbx_properties', 'qb-houses', 'esx_property' }

-- ------------------------------------------------------------
-- Apartments add-on (appended to any provider's list by server/house.lua). Ids are prefixed 'apt:' so they never
-- collide with a house id; they have no lock and no keys in these resources.
--   qb-apartments (VERIFIED against qbcore-framework/qb-apartments): apartments (name, type, label, citizenid),
--     door = Apartments.Locations[type].coords.enter (config.lua)
--   qbx_apartments (VERIFIED against Qbox-project/qbx_apartments, archived): same table,
--     door = (config/shared.lua return).locations[type].enter
-- ------------------------------------------------------------
local APT_PREFIX = 'apt:'
local APTS = {
    { id = 'qb-apartments', res = 'qb-apartments', door = function(t)
        local l = readCfg('qb-apartments', 'config.lua', 'Apartments.Locations')
        local e = type(l) == 'table' and type(l[t]) == 'table' and l[t] or nil
        return e and type(e.coords) == 'table' and PI.xyz(e.coords.enter) or nil
    end },
    { id = 'qbx_apartments', res = 'qbx_apartments', door = function(t)
        local l = readCfg('qbx_apartments', 'config/shared.lua', 'locations')
        local e = type(l) == 'table' and type(l[t]) == 'table' and l[t] or nil
        return e and PI.xyz(e.enter) or nil
    end },
}

function PI.isExtraHouse(id) return type(id) == 'string' and id:sub(1, #APT_PREFIX) == APT_PREFIX end

-- public-shape list of the player's apartments (never raises: a failure only drops the add-on, with a warning)
function PI.housingExtras(src, cid)
    local want = type(Config) == 'table' and type(Config.Integrations) == 'table' and Config.Integrations.apartments
    if want == false or want == 'off' or want == 'none' or cid == nil then return {} end
    local out = {}
    for _, a in ipairs(APTS) do
        if (want == nil or want == 'auto' or want == true or want == a.id) and PI.started(a.res) then
            local ok, err = pcall(function()
                for _, r in ipairs(q('SELECT name, type, label FROM apartments WHERE citizenid = ?', { cid })) do
                    if r.name then
                        out[#out + 1] = { id = APT_PREFIX .. tostring(r.name), label = r.label or tostring(r.name), owner = true,
                            coords = a.door(r.type), tier = 1, lockable = false, keys = false, keyholders = {} }
                    end
                end
            end)
            if not ok then PI.warnOnce('apt_' .. a.id, ('apartments add-on %s failed (%s): apartments are not shown'):format(a.id, tostring(err))) end
            break   -- both resources share the `apartments` table: read it once
        end
    end
    return out
end
