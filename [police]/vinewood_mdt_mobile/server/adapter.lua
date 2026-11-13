--[[
    Adapter – where the app's data comes from.

    Each function first tries the matching Vinewood MDT export (Config.MDT.exports).
    If the MDT doesn't provide it, a framework fallback is used so the app still
    works on a fresh install. Keep the return shapes below and the app will render it.

    Person (search row):  { citizenid, name, dob, gender }
    Profile:              { citizenid, name, dob, gender, nationality, phone,
                            licences = { { label, status, points? } },
                            markers  = { 'Violent', 'Carries weapons' },
                            warrants = { warrant... }, vehicles = { { plate, model } } }
    Vehicle:              { plate, model, owner = { citizenid, name },
                            statuses = { { label = 'MOT', value = 'Valid', ok = true } },
                            markers  = { 'Stolen' } }
    Warrant:              { id, citizenid, name, offence, issuedBy, issuedAt }
    BOLO:                 { id, kind = 'person'|'vehicle', title, details, plate?,
                            createdBy, createdAt }
]]

Adapter = {}

local function mdtExport(key, ...)
    local res = Config.MDT.resource
    local fn = Config.MDT.exports[key]
    if not fn or GetResourceState(res) ~= 'started' then return false end
    local ok, result = pcall(function(...) return exports[res][fn](exports[res], ...) end, ...)
    if not ok then
        -- Export missing or errored – fall back quietly unless it's a real error
        if not tostring(result):find('No such export') then
            print(('^3[vinewood_mdt_mobile] %s:%s failed: %s^0'):format(res, fn, result))
        end
        return false
    end
    return true, result
end

local function likeEscape(s)
    return (s:gsub('[%%_\\]', '\\%0'))
end

local isESX = function() return Framework.name == 'esx' end

local function qbPerson(row)
    local ci = Util.DecodeJson(row.charinfo) or {}
    return {
        citizenid   = row.citizenid,
        name        = ('%s %s'):format(ci.firstname or '?', ci.lastname or '?'),
        dob         = ci.birthdate,
        gender      = (ci.gender == 1 or ci.gender == '1') and 'Female' or 'Male',
        nationality = ci.nationality,
        phone       = ci.phone,
    }
end

local function esxPerson(row)
    return {
        citizenid = row.identifier,
        name      = ('%s %s'):format(row.firstname or '?', row.lastname or '?'),
        dob       = row.dateofbirth,
        gender    = (row.sex == 'f' or row.sex == 'F') and 'Female' or 'Male',
        phone     = row.phone_number,
    }
end

-- People ---------------------------------------------------------------

function Adapter.SearchPeople(q)
    local ok, res = mdtExport('searchPeople', q)
    if ok and res then return res end

    local like = '%' .. likeEscape(q) .. '%'
    local out = {}
    if isESX() then
        local rows = MySQL.query.await([[
            SELECT identifier, firstname, lastname, dateofbirth, sex FROM users
            WHERE identifier = ? OR CONCAT(firstname, ' ', lastname) LIKE ? LIMIT 25
        ]], { q, like }) or {}
        for _, r in ipairs(rows) do out[#out + 1] = esxPerson(r) end
    else
        local rows = MySQL.query.await([[
            SELECT citizenid, charinfo FROM players
            WHERE citizenid = ?
               OR JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.phone')) = ?
               OR CONCAT(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')), ' ',
                         JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname'))) LIKE ?
            LIMIT 25
        ]], { q, q, like }) or {}
        for _, r in ipairs(rows) do out[#out + 1] = qbPerson(r) end
    end
    return out
end

function Adapter.GetProfile(cid)
    local ok, res = mdtExport('getProfile', cid)
    if ok and res then return res end

    local p, licences, vehicles = nil, {}, {}
    if isESX() then
        local row = MySQL.single.await('SELECT * FROM users WHERE identifier = ?', { cid })
        if not row then return nil end
        p = esxPerson(row)
        local lic = MySQL.query.await('SELECT type FROM user_licenses WHERE owner = ?', { cid }) or {}
        for _, l in ipairs(lic) do licences[#licences + 1] = { label = l.type, status = 'Valid' } end
        local veh = MySQL.query.await('SELECT plate, vehicle FROM owned_vehicles WHERE owner = ?', { cid }) or {}
        for _, v in ipairs(veh) do
            local props = Util.DecodeJson(v.vehicle) or {}
            vehicles[#vehicles + 1] = { plate = v.plate, model = tostring(props.model or 'Unknown') }
        end
    else
        local row = MySQL.single.await('SELECT citizenid, charinfo, metadata FROM players WHERE citizenid = ?', { cid })
        if not row then return nil end
        p = qbPerson(row)
        local meta = Util.DecodeJson(row.metadata) or {}
        for name, has in pairs(meta.licences or {}) do
            licences[#licences + 1] = { label = name:gsub('^%l', string.upper), status = has and 'Valid' or 'None' }
        end
        local veh = MySQL.query.await('SELECT plate, vehicle FROM player_vehicles WHERE citizenid = ?', { cid }) or {}
        for _, v in ipairs(veh) do vehicles[#vehicles + 1] = { plate = v.plate, model = v.vehicle } end
    end

    p.licences = licences
    p.vehicles = vehicles
    p.markers = {}
    p.warrants = {}
    for _, w in ipairs(Adapter.GetWarrants()) do
        if w.citizenid == cid then p.warrants[#p.warrants + 1] = w end
    end
    return p
end

-- Vehicles -------------------------------------------------------------

function Adapter.SearchVehicle(plate)
    local ok, res = mdtExport('searchVehicle', plate)
    if ok and res then return res end

    local out = {}
    if isESX() then
        local rows = MySQL.query.await([[
            SELECT v.plate, v.vehicle, u.identifier, u.firstname, u.lastname
            FROM owned_vehicles v LEFT JOIN users u ON u.identifier = v.owner
            WHERE REPLACE(v.plate, ' ', '') LIKE ? LIMIT 10
        ]], { likeEscape(plate) .. '%' }) or {}
        for _, r in ipairs(rows) do
            local props = Util.DecodeJson(r.vehicle) or {}
            out[#out + 1] = {
                plate = r.plate, model = tostring(props.model or 'Unknown'),
                owner = r.identifier and { citizenid = r.identifier, name = ('%s %s'):format(r.firstname, r.lastname) },
                statuses = {}, markers = {},
            }
        end
    else
        local rows = MySQL.query.await([[
            SELECT v.plate, v.vehicle, p.citizenid, p.charinfo
            FROM player_vehicles v LEFT JOIN players p ON p.citizenid = v.citizenid
            WHERE REPLACE(v.plate, ' ', '') LIKE ? LIMIT 10
        ]], { likeEscape(plate) .. '%' }) or {}
        for _, r in ipairs(rows) do
            local owner = r.citizenid and qbPerson(r) or nil
            out[#out + 1] = {
                plate = r.plate, model = r.vehicle,
                owner = owner and { citizenid = owner.citizenid, name = owner.name },
                statuses = {}, markers = {},
            }
        end
    end

    -- Flag vehicles with an active vehicle BOLO
    for _, b in ipairs(Adapter.GetBolos()) do
        if b.plate then
            local bp = b.plate:gsub('%s', ''):upper()
            for _, v in ipairs(out) do
                if v.plate:gsub('%s', ''):upper() == bp then
                    v.markers[#v.markers + 1] = 'BOLO: ' .. b.title
                end
            end
        end
    end
    return out
end

-- Warrants -------------------------------------------------------------

function Adapter.GetWarrants()
    local ok, res = mdtExport('getWarrants')
    if ok and res then return res end
    return {} -- warrants live in the MDT; nothing to fall back to
end

-- BOLOs ----------------------------------------------------------------

function Adapter.GetBolos()
    local ok, res = mdtExport('getBolos')
    if ok and res then return res end

    local rows = MySQL.query.await([[
        SELECT id, kind, title, details, plate, created_by, UNIX_TIMESTAMP(created_at) AS created_at
        FROM vinewood_mdt_mobile_bolos WHERE active = 1 ORDER BY id DESC LIMIT 50
    ]]) or {}
    local out = {}
    for _, r in ipairs(rows) do
        out[#out + 1] = {
            id = r.id, kind = r.kind, title = r.title, details = r.details, plate = r.plate,
            createdBy = r.created_by, createdAt = r.created_at,
        }
    end
    return out
end

function Adapter.CreateBolo(data, officer)
    local ok, res = mdtExport('createBolo', data, officer)
    if ok then return res end

    local by = officer.callsign and ('%s %s'):format(officer.callsign, officer.name) or officer.name
    local id = MySQL.insert.await([[
        INSERT INTO vinewood_mdt_mobile_bolos (kind, title, details, plate, created_by, created_cid)
        VALUES (?, ?, ?, ?, ?, ?)
    ]], { data.kind, data.title, data.details, data.plate, by, officer.citizenid })
    return { id = id, kind = data.kind, title = data.title, details = data.details,
             plate = data.plate, createdBy = by, createdAt = os.time() }
end
