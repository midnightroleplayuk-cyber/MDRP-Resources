Bridge = {}

local fw, QBCore, ESX

function Bridge.Framework()
    if fw then return fw end
    if Config.Framework ~= 'auto' then
        fw = Config.Framework
    elseif GetResourceState('qbx_core') == 'started' then
        fw = 'qbx'
    elseif GetResourceState('qb-core') == 'started' then
        fw = 'qb'
    elseif GetResourceState('es_extended') == 'started' then
        fw = 'esx'
    else
        fw = 'none'
    end
    if fw == 'qb' then QBCore = exports['qb-core']:GetCoreObject() end
    if fw == 'esx' then ESX = exports.es_extended:getSharedObject() end
    return fw
end

local function decode(v)
    if type(v) == 'string' then
        local ok, t = pcall(json.decode, v)
        if ok and type(t) == 'table' then return t end
        return {}
    end
    return v or {}
end
Bridge.Decode = decode

local function qbPlayer(src)
    local f = Bridge.Framework()
    if f == 'qbx' then return exports.qbx_core:GetPlayer(src) end
    if f == 'qb' then return QBCore.Functions.GetPlayer(src) end
end

local function qbPlayerByCid(cid)
    local f = Bridge.Framework()
    if f == 'qbx' then return exports.qbx_core:GetPlayerByCitizenId(cid) end
    if f == 'qb' then return QBCore.Functions.GetPlayerByCitizenId(cid) end
end

--- Character id: citizenid (qb/qbx) or identifier (esx)
function Bridge.GetCid(src)
    local f = Bridge.Framework()
    if f == 'esx' then
        local x = ESX.GetPlayerFromId(src)
        return x and x.identifier
    end
    local p = qbPlayer(src)
    return p and p.PlayerData.citizenid
end

--- Server id of an online character, or nil.
function Bridge.GetSource(cid)
    if not cid then return nil end
    local f = Bridge.Framework()
    if f == 'esx' then
        local x = ESX.GetPlayerFromIdentifier(cid)
        return x and x.source
    end
    local p = qbPlayerByCid(cid)
    return p and p.PlayerData.source
end

function Bridge.GetName(src)
    local f = Bridge.Framework()
    if f == 'esx' then
        local x = ESX.GetPlayerFromId(src)
        if not x then return GetPlayerName(src) end
        return (('%s %s'):format(x.get('firstName') or '', x.get('lastName') or ''):gsub('^%s+', ''))
    end
    local p = qbPlayer(src)
    if not p then return GetPlayerName(src) end
    local ci = p.PlayerData.charinfo or {}
    return ('%s %s'):format(ci.firstname or '', ci.lastname or '')
end

-- vinewood-dispatch saves callsigns per character; prefer it when it's running
local function dispatchCallsign(src)
    if GetResourceState('vinewood-dispatch') ~= 'started' then return nil end
    local ok, cs = pcall(function() return exports['vinewood-dispatch']:GetStoredCallsign(src) end)
    return ok and cs or nil
end

--- { name, label, grade, gradeLabel, onduty, callsign }
function Bridge.GetJob(src)
    local f = Bridge.Framework()
    if f == 'esx' then
        local x = ESX.GetPlayerFromId(src)
        if not x then return nil end
        return { name = x.job.name, label = x.job.label, grade = x.job.grade, gradeLabel = x.job.grade_label, onduty = true,
            callsign = dispatchCallsign(src) }
    end
    local p = qbPlayer(src)
    if not p then return nil end
    local j = p.PlayerData.job or {}
    local grade = type(j.grade) == 'table' and (j.grade.level or 0) or (j.grade or 0)
    local gradeLabel = type(j.grade) == 'table' and j.grade.name or tostring(grade)
    return {
        name = j.name, label = j.label, grade = grade, gradeLabel = gradeLabel,
        onduty = j.onduty ~= false,
        callsign = dispatchCallsign(src) or (p.PlayerData.metadata and p.PlayerData.metadata.callsign),
    }
end

--- Metadata of an online qb/qbx character.
function Bridge.GetMetadata(src)
    local p = qbPlayer(src)
    return p and p.PlayerData.metadata or {}
end

--- Turns a players/users row into a person summary.
local function personFromRow(row)
    local f = Bridge.Framework()
    if f == 'esx' then
        return {
            cid = row.identifier,
            firstname = row.firstname or '',
            lastname = row.lastname or '',
            dob = row.dateofbirth,
            sex = (row.sex == 'm' or row.sex == 'M') and 'Male' or ((row.sex == 'f' or row.sex == 'F') and 'Female' or row.sex),
            phone = row.phone_number,
        }
    end
    local ci = decode(row.charinfo)
    return {
        cid = row.citizenid,
        firstname = ci.firstname or '',
        lastname = ci.lastname or '',
        dob = ci.birthdate,
        sex = ci.gender == 0 and 'Male' or (ci.gender == 1 and 'Female' or nil),
        nationality = ci.nationality,
        phone = ci.phone,
        metadata = decode(row.metadata),
    }
end

--- Name search. Every word must match the first or last name, case-insensitive,
--- so "james", "smith", "Smith James" and "jam smi" all find James Smith.
--- A reference number or phone number also matches exactly.
--- Characters in the city are always included, even if their row hasn't been saved yet.
local function words(q)
    local out = {}
    for w in tostring(q or ''):lower():gmatch('%S+') do
        if #out < 4 then out[#out + 1] = w end
    end
    return out
end

local function onlineMatches(q)
    local ws, out = words(q), {}
    if #ws == 0 then return out end
    for _, id in ipairs(GetPlayers()) do
        local src = tonumber(id)
        local cid = Bridge.GetCid(src)
        if cid then
            local name = (Bridge.GetName(src) or ''):lower()
            local hit = cid:lower() == tostring(q):lower()
            if not hit then
                hit = true
                for _, w in ipairs(ws) do if not name:find(w, 1, true) then hit = false break end end
            end
            if hit then out[cid] = true end
        end
    end
    return out
end

function Bridge.SearchPeople(q, limit)
    limit = limit or 25
    q = tostring(q or ''):gsub('^%s+', ''):gsub('%s+$', '')
    local ws = words(q)
    local esx = Bridge.Framework() == 'esx'

    local fn = esx and 'LOWER(firstname)' or "LOWER(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')))"
    local ln = esx and 'LOWER(lastname)' or "LOWER(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname')))"
    local idCol = esx and 'identifier' or 'citizenid'
    local phone = esx and 'phone_number' or "JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.phone'))"

    local nameParts, args = {}, {}
    for _, w in ipairs(ws) do
        nameParts[#nameParts + 1] = ('(%s LIKE ? OR %s LIKE ?)'):format(fn, ln)
        args[#args + 1] = '%' .. w .. '%'
        args[#args + 1] = '%' .. w .. '%'
    end
    local where = ('%s = ? OR %s = ?'):format(idCol, phone)
    local whereArgs = { q, q }
    if #nameParts > 0 then
        where = ('(%s) OR %s'):format(table.concat(nameParts, ' AND '), where)
        for i = #args, 1, -1 do table.insert(whereArgs, 1, args[i]) end
    end

    local online = onlineMatches(q)
    local onlineIds = {}
    for cid in pairs(online) do onlineIds[#onlineIds + 1] = cid end
    if #onlineIds > 0 then
        where = ('%s OR %s IN (%s)'):format(where, idCol, string.rep('?', #onlineIds, ','))
        for _, c in ipairs(onlineIds) do whereArgs[#whereArgs + 1] = c end
    end
    whereArgs[#whereArgs + 1] = limit

    local sql = esx
        and ('SELECT identifier, firstname, lastname, dateofbirth, sex, phone_number FROM users WHERE %s LIMIT ?'):format(where)
        or ('SELECT citizenid, charinfo FROM players WHERE %s LIMIT ?'):format(where)
    local rows = MySQL.query.await(sql, whereArgs) or {}

    local out, seen = {}, {}
    for _, r in ipairs(rows) do
        local p = personFromRow(r)
        seen[p.cid] = true
        out[#out + 1] = p
    end
    -- In the city but not in the database yet (brand new character): build from live data.
    for _, cid in ipairs(onlineIds) do
        if not seen[cid] then
            local src = Bridge.GetSource(cid)
            local name = src and Bridge.GetName(src) or ''
            local first, last = name:match('^(%S+)%s*(.*)$')
            out[#out + 1] = { cid = cid, firstname = first or name, lastname = last or '' }
        end
    end
    -- People in the city first, then alphabetical.
    table.sort(out, function(a, b)
        local ao, bo = online[a.cid] and 1 or 0, online[b.cid] and 1 or 0
        if ao ~= bo then return ao > bo end
        return (a.lastname .. a.firstname):lower() < (b.lastname .. b.firstname):lower()
    end)
    return out
end

--- Characters in the city, nearest to the officer first.
function Bridge.NearbyPeople(officerSrc, limit)
    local me = GetEntityCoords(GetPlayerPed(officerSrc))
    local out = {}
    for _, id in ipairs(GetPlayers()) do
        local src = tonumber(id)
        if src ~= officerSrc then
            local cid = Bridge.GetCid(src)
            if cid then
                local ped = GetPlayerPed(src)
                local dist = ped ~= 0 and #(GetEntityCoords(ped) - me) or 99999.0
                local name = Bridge.GetName(src) or ''
                local first, last = name:match('^(%S+)%s*(.*)$')
                out[#out + 1] = { cid = cid, firstname = first or name, lastname = last or '', distance = math.floor(dist), online = true }
            end
        end
    end
    table.sort(out, function(a, b) return a.distance < b.distance end)
    while #out > (limit or 8) do table.remove(out) end
    return out
end

function Bridge.GetPerson(cid)
    if Bridge.Framework() == 'esx' then
        local row = MySQL.single.await('SELECT identifier, firstname, lastname, dateofbirth, sex, phone_number FROM users WHERE identifier = ?', { cid })
        return row and personFromRow(row)
    end
    local row = MySQL.single.await('SELECT citizenid, charinfo, metadata FROM players WHERE citizenid = ?', { cid })
    return row and personFromRow(row)
end

function Bridge.GetVehiclesByOwner(cid)
    if Bridge.Framework() == 'esx' then
        local rows = MySQL.query.await('SELECT plate, vehicle FROM owned_vehicles WHERE owner = ?', { cid }) or {}
        local out = {}
        for _, r in ipairs(rows) do
            local v = decode(r.vehicle)
            out[#out + 1] = { plate = r.plate, model = v.model, owner = cid }
        end
        return out
    end
    local rows = MySQL.query.await('SELECT plate, vehicle FROM player_vehicles WHERE citizenid = ?', { cid }) or {}
    local out = {}
    for _, r in ipairs(rows) do out[#out + 1] = { plate = r.plate, model = r.vehicle, owner = cid } end
    return out
end

function Bridge.SearchVehicles(q)
    local like = '%' .. q:gsub('%s+', '') .. '%'
    if Bridge.Framework() == 'esx' then
        local rows = MySQL.query.await([[SELECT plate, vehicle, owner FROM owned_vehicles WHERE REPLACE(plate, ' ', '') LIKE ? LIMIT 25]], { like }) or {}
        local out = {}
        for _, r in ipairs(rows) do
            local v = decode(r.vehicle)
            out[#out + 1] = { plate = r.plate, model = v.model, owner = r.owner }
        end
        return out
    end
    local rows = MySQL.query.await([[SELECT plate, vehicle, citizenid FROM player_vehicles WHERE REPLACE(plate, ' ', '') LIKE ? LIMIT 25]], { like }) or {}
    local out = {}
    for _, r in ipairs(rows) do out[#out + 1] = { plate = r.plate, model = r.vehicle, owner = r.citizenid } end
    return out
end

function Bridge.GetVehicle(plate)
    if Bridge.Framework() == 'esx' then
        local r = MySQL.single.await('SELECT plate, vehicle, owner FROM owned_vehicles WHERE plate = ?', { plate })
        if not r then return nil end
        return { plate = r.plate, model = decode(r.vehicle).model, owner = r.owner }
    end
    local r = MySQL.single.await('SELECT plate, vehicle, citizenid FROM player_vehicles WHERE plate = ?', { plate })
    if not r then return nil end
    return { plate = r.plate, model = r.vehicle, owner = r.citizenid }
end

--- Money. account: 'bank' or 'cash'.
function Bridge.GetMoney(src, account)
    if Bridge.Framework() == 'esx' then
        local x = ESX.GetPlayerFromId(src)
        if not x then return 0 end
        if account == 'cash' then return x.getMoney() end
        local a = x.getAccount(account)
        return a and a.money or 0
    end
    local p = qbPlayer(src)
    return p and (p.PlayerData.money[account] or 0) or 0
end

function Bridge.RemoveMoney(src, account, amount, reason)
    if Bridge.Framework() == 'esx' then
        local x = ESX.GetPlayerFromId(src)
        if not x then return false end
        if account == 'cash' then x.removeMoney(amount, reason) else x.removeAccountMoney(account, amount, reason) end
        return true
    end
    local p = qbPlayer(src)
    if not p then return false end
    return p.Functions.RemoveMoney(account, amount, reason) ~= false
end

--- Job of a character who may be offline: { name, grade } or nil.
function Bridge.GetJobOffline(cid)
    local src = Bridge.GetSource(cid)
    if src then
        local j = Bridge.GetJob(src)
        return j and { name = j.name, grade = j.grade } or nil
    end
    if Bridge.Framework() == 'esx' then
        local r = MySQL.single.await('SELECT job, job_grade FROM users WHERE identifier = ?', { cid })
        return r and { name = r.job, grade = tonumber(r.job_grade) or 0 } or nil
    end
    local r = MySQL.single.await('SELECT job FROM players WHERE citizenid = ?', { cid })
    if not r then return nil end
    local j = decode(r.job)
    local grade = type(j.grade) == 'table' and (j.grade.level or 0) or (tonumber(j.grade) or 0)
    return j.name and { name = j.name, grade = grade } or nil
end

function Bridge.Notify(src, msg, kind)
    TriggerClientEvent('ox_lib:notify', src, { title = Config.ForceName, description = msg, type = kind or 'inform', duration = 8000 })
end
