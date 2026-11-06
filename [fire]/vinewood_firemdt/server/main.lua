local Units      = {}   -- [src] = { src, callsign, name, status, incident, coords, heading, vehicle }
local Incidents  = {}   -- [id]  = incident (open + recently closed)
local Hydrants   = {}   -- [id]
local Risks      = {}   -- [id]
local Sops       = {}   -- [id]
local Ready      = false

local function clamp(s, n) s = tostring(s or ''); return s:sub(1, n or 255) end
local function now() return os.time() end

-- ─────────────────────────────────────────────────────────────
-- Permissions
-- ─────────────────────────────────────────────────────────────
local function getPerms(src)
    local p = Bridge.GetPlayer(src)
    if not p then return nil end
    local isControlJob = Config.ControlJobs[p.name] == true
    if not Config.Jobs[p.name] and not isControlJob then return nil end
    if Config.RequireDuty and not p.onduty then return nil, 'duty' end
    local g = p.grade or 0
    return {
        name = p.fullname, identifier = p.identifier, job = p.name, grade = g,
        control      = isControlJob or g >= Config.Grades.control,
        editHydrants = isControlJob or g >= Config.Grades.editHydrants,
        editRisks    = isControlJob or g >= Config.Grades.editRisks,
        editSops     = isControlJob or g >= Config.Grades.editSops,
    }
end

-- ─────────────────────────────────────────────────────────────
-- Sync helpers
-- ─────────────────────────────────────────────────────────────
local function unitList()
    local list = {}
    for _, u in pairs(Units) do
        list[#list + 1] = {
            src = u.src, callsign = u.callsign, name = u.name, status = u.status,
            incident = u.incident, x = u.coords and u.coords.x, y = u.coords and u.coords.y,
            heading = u.heading, control = u.control,
        }
    end
    table.sort(list, function(a, b) return a.callsign < b.callsign end)
    return list
end

local function broadcast(kind, payload)
    for src in pairs(Units) do
        TriggerClientEvent('vfmdt:client:sync', src, kind, payload)
    end
end

local function incidentUnits(id)
    local list = {}
    for _, u in pairs(Units) do
        if u.incident == id then list[#list + 1] = u.callsign end
    end
    return list
end

local function publicIncident(inc)
    local copy = {}
    for k, v in pairs(inc) do copy[k] = v end
    copy.units = incidentUnits(inc.id)
    return copy
end

local function pushIncident(inc) broadcast('incident', publicIncident(inc)) end
local function pushUnits() broadcast('units', unitList()) end

-- ─────────────────────────────────────────────────────────────
-- Incident log
-- ─────────────────────────────────────────────────────────────
local function addLog(incId, kind, text, author, callsign)
    local entry = {
        incident_id = incId, kind = kind, text = clamp(text, 1000),
        author = author or Config.Branding.controlName, callsign = callsign or '', created_at = now(),
    }
    entry.id = MySQL.insert.await(
        'INSERT INTO firemdt_incident_log (incident_id, kind, text, author, callsign, created_at) VALUES (?, ?, ?, ?, ?, ?)',
        { incId, entry.kind, entry.text, entry.author, entry.callsign, entry.created_at })
    broadcast('log', entry)
    return entry
end

-- ─────────────────────────────────────────────────────────────
-- Risk matching
-- ─────────────────────────────────────────────────────────────
local function risksNear(x, y)
    local found = {}
    for id, r in pairs(Risks) do
        local d = math.sqrt((r.x - x) ^ 2 + (r.y - y) ^ 2)
        if d <= (r.radius or 50) + Config.RiskAlertExtra then found[#found + 1] = id end
    end
    return found
end

-- ─────────────────────────────────────────────────────────────
-- Incidents
-- ─────────────────────────────────────────────────────────────
local function createIncident(data, author)
    if not data or not data.coords then return nil, 'No location' end
    local x, y, z = tonumber(data.coords.x) or 0.0, tonumber(data.coords.y) or 0.0, tonumber(data.coords.z) or 0.0
    local inc = {
        type = clamp(data.type or 'Special Service', 64),
        priority = clamp(data.priority or Config.Priorities[2], 32),
        location = clamp(data.location or 'Unknown', 128),
        details = clamp(data.details or '', 2000),
        caller = clamp(data.caller or '', 64),
        x = x, y = y, z = z,
        status = 'open', created_at = now(), closed_at = nil,
        created_by = clamp(author or Config.Branding.controlName, 64),
        source = clamp(data.source or 'mdt', 32),
    }
    inc.id = MySQL.insert.await(
        'INSERT INTO firemdt_incidents (type, priority, location, details, caller, x, y, z, status, created_at, created_by, source) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)',
        { inc.type, inc.priority, inc.location, inc.details, inc.caller, x, y, z, inc.status, inc.created_at, inc.created_by, inc.source })
    if not inc.id then return nil, 'Database error' end
    inc.ref = ('%s%s-%04d'):format(Config.IncidentPrefix, os.date('%y%m%d'), inc.id)
    MySQL.update('UPDATE firemdt_incidents SET ref = ? WHERE id = ?', { inc.ref, inc.id })
    inc.risks = risksNear(x, y)
    Incidents[inc.id] = inc
    pushIncident(inc)
    addLog(inc.id, 'system', ('Incident created: %s, %s'):format(inc.type, inc.location), inc.created_by)
    if #inc.risks > 0 then
        local names = {}
        for _, rid in ipairs(inc.risks) do names[#names + 1] = Risks[rid].name end
        addLog(inc.id, 'risk', 'Risk information on file: ' .. table.concat(names, ', '))
    end
    return inc
end

local function setStatus(src, code, silent)
    local u = Units[src]; if not u then return false end
    local valid = false
    for _, s in ipairs(Config.Statuses) do if s.code == code then valid = s break end end
    if not valid then return false end
    u.status = code
    if u.incident and not silent then
        addLog(u.incident, 'status', ('%s status %d - %s'):format(u.callsign, code, valid.label), u.name, u.callsign)
    end
    if valid.emergency then
        broadcast('priority', { callsign = u.callsign, name = u.name, x = u.coords and u.coords.x, y = u.coords and u.coords.y })
    end
    pushUnits()
    return true
end

local function attach(src, incId, byControl)
    local u = Units[src]; local inc = Incidents[incId]
    if not u or not inc or inc.status ~= 'open' then return false end
    u.incident = incId
    if byControl then
        TriggerClientEvent('vfmdt:client:mobilise', src, publicIncident(inc))
        addLog(incId, 'mobilise', ('%s mobilised'):format(u.callsign))
    else
        addLog(incId, 'mobilise', ('%s booked on to incident'):format(u.callsign), u.name, u.callsign)
    end
    pushIncident(inc); pushUnits()
    return true
end

local function closeIncident(incId, author)
    local inc = Incidents[incId]; if not inc or inc.status ~= 'open' then return false end
    inc.status = 'closed'; inc.closed_at = now()
    MySQL.update('UPDATE firemdt_incidents SET status = ?, closed_at = ? WHERE id = ?', { 'closed', inc.closed_at, incId })
    addLog(incId, 'system', 'Incident closed', author)
    for _, u in pairs(Units) do
        if u.incident == incId then u.incident = nil end
    end
    pushIncident(inc); pushUnits()
    return true
end

-- ─────────────────────────────────────────────────────────────
-- Database bootstrap
-- ─────────────────────────────────────────────────────────────
CreateThread(function()
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS firemdt_incidents (
        id INT AUTO_INCREMENT PRIMARY KEY, ref VARCHAR(32), type VARCHAR(64), priority VARCHAR(32),
        location VARCHAR(128), details TEXT, caller VARCHAR(64), x FLOAT, y FLOAT, z FLOAT,
        status VARCHAR(16) DEFAULT 'open', created_at INT, closed_at INT NULL, created_by VARCHAR(64), source VARCHAR(32),
        INDEX(status)) ]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS firemdt_incident_log (
        id INT AUTO_INCREMENT PRIMARY KEY, incident_id INT, kind VARCHAR(16), text TEXT,
        author VARCHAR(64), callsign VARCHAR(32), created_at INT, INDEX(incident_id)) ]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS firemdt_hydrants (
        id INT AUTO_INCREMENT PRIMARY KEY, code VARCHAR(32), type VARCHAR(32), status VARCHAR(32),
        defect TEXT, x FLOAT, y FLOAT, z FLOAT, updated_by VARCHAR(64), updated_at INT) ]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS firemdt_risks (
        id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(128), address VARCHAR(128), level TINYINT DEFAULT 1,
        x FLOAT, y FLOAT, z FLOAT, radius FLOAT DEFAULT 50, hazards TEXT, access TEXT, water TEXT,
        contacts TEXT, notes TEXT, updated_by VARCHAR(64), updated_at INT) ]])
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS firemdt_sops (
        id INT AUTO_INCREMENT PRIMARY KEY, category VARCHAR(64), title VARCHAR(128), body TEXT,
        updated_by VARCHAR(64), updated_at INT) ]])

    for _, h in ipairs(MySQL.query.await('SELECT * FROM firemdt_hydrants') or {}) do Hydrants[h.id] = h end
    for _, r in ipairs(MySQL.query.await('SELECT * FROM firemdt_risks') or {}) do Risks[r.id] = r end

    local sops = MySQL.query.await('SELECT * FROM firemdt_sops') or {}
    if #sops == 0 then
        for _, s in ipairs(DefaultSops) do
            local id = MySQL.insert.await('INSERT INTO firemdt_sops (category, title, body, updated_by, updated_at) VALUES (?,?,?,?,?)',
                { s.category, s.title, s.body, 'System', now() })
            Sops[id] = { id = id, category = s.category, title = s.title, body = s.body, updated_by = 'System', updated_at = now() }
        end
    else
        for _, s in ipairs(sops) do Sops[s.id] = s end
    end

    -- open incidents + last 24h closed
    local rows = MySQL.query.await('SELECT * FROM firemdt_incidents WHERE status = ? OR created_at > ?', { 'open', now() - 86400 }) or {}
    for _, inc in ipairs(rows) do
        inc.risks = risksNear(inc.x, inc.y)
        Incidents[inc.id] = inc
    end
    Ready = true
end)

local function listOf(t) local l = {}; for _, v in pairs(t) do l[#l + 1] = v end; return l end

-- ─────────────────────────────────────────────────────────────
-- Callbacks
-- ─────────────────────────────────────────────────────────────
lib.callback.register('vfmdt:open', function(src)
    while not Ready do Wait(100) end
    local perms, reason = getPerms(src)
    if not perms then return { error = reason == 'duty' and 'You must be on duty to use the MDT.' or 'You are not authorised to use this terminal.' } end
    local me = Units[src]
    if me then me.name = perms.name; me.control = perms.control end
    local incs = {}
    for _, inc in pairs(Incidents) do incs[#incs + 1] = publicIncident(inc) end
    return {
        perms = perms, me = me and { callsign = me.callsign, status = me.status, incident = me.incident } or nil,
        units = unitList(), incidents = incs, hydrants = listOf(Hydrants), risks = listOf(Risks), sops = listOf(Sops),
    }
end)

lib.callback.register('vfmdt:signOn', function(src, callsign)
    local perms = getPerms(src); if not perms then return false end
    callsign = clamp(callsign, 24):upper():gsub('[^%w%-%s]', '')
    if callsign == '' then return false, 'Enter a callsign' end
    local u = Units[src]
    if u then
        u.callsign = callsign
    else
        Units[src] = { src = src, callsign = callsign, name = perms.name, status = Config.DefaultStatus, control = perms.control }
    end
    pushUnits()
    return true
end)

lib.callback.register('vfmdt:signOff', function(src)
    local u = Units[src]
    if u and u.incident then addLog(u.incident, 'status', u.callsign .. ' signed off', u.name, u.callsign) end
    Units[src] = nil
    pushUnits()
    return true
end)

lib.callback.register('vfmdt:setStatus', function(src, code)
    if not getPerms(src) then return false end
    return setStatus(src, tonumber(code))
end)

lib.callback.register('vfmdt:incident:create', function(src, data)
    local perms = getPerms(src); if not perms or not perms.control then return false, 'Not authorised' end
    local inc, err = createIncident(data, perms.name)
    if not inc then return false, err end
    return true, inc.id
end)

lib.callback.register('vfmdt:incident:log', function(src, id)
    if not getPerms(src) then return {} end
    return MySQL.query.await('SELECT * FROM firemdt_incident_log WHERE incident_id = ? ORDER BY id ASC', { id }) or {}
end)

lib.callback.register('vfmdt:incident:history', function(src, search)
    if not getPerms(src) then return {} end
    search = '%' .. clamp(search, 64) .. '%'
    return MySQL.query.await('SELECT * FROM firemdt_incidents WHERE status = ? AND (ref LIKE ? OR location LIKE ? OR type LIKE ?) ORDER BY id DESC LIMIT 50',
        { 'closed', search, search, search }) or {}
end)

lib.callback.register('vfmdt:incident:message', function(src, id, kind, text)
    local perms = getPerms(src); if not perms then return false end
    local inc = Incidents[id]; if not inc or inc.status ~= 'open' then return false, 'Incident is not open' end
    local allowed = { assistance = true, informative = true, stop = true, message = true }
    if not allowed[kind] then return false end
    local u = Units[src]
    local cs = u and u.callsign or (perms.control and Config.Branding.controlName or '')
    addLog(id, kind, text, perms.name, cs)
    if kind == 'stop' and Config.StopMessageClosesIncident then closeIncident(id, perms.name) end
    return true
end)

lib.callback.register('vfmdt:incident:mobilise', function(src, id, targets)
    local perms = getPerms(src); if not perms or not perms.control then return false end
    local n = 0
    for _, t in ipairs(targets or {}) do
        if attach(tonumber(t), id, true) then n = n + 1 end
    end
    return n > 0, n
end)

lib.callback.register('vfmdt:incident:attach', function(src, id)
    if not getPerms(src) then return false end
    return attach(src, id, false)
end)

lib.callback.register('vfmdt:incident:accept', function(src, id)
    local u = Units[src]; if not u or u.incident ~= id then return false end
    addLog(id, 'status', u.callsign .. ' acknowledged mobilisation', u.name, u.callsign)
    setStatus(src, Config.MobileStatus, true)
    return true
end)

lib.callback.register('vfmdt:incident:detach', function(src)
    local u = Units[src]; if not u or not u.incident then return false end
    local id = u.incident
    addLog(id, 'status', u.callsign .. ' booked off incident', u.name, u.callsign)
    u.incident = nil
    if Incidents[id] then pushIncident(Incidents[id]) end
    pushUnits()
    return true
end)

lib.callback.register('vfmdt:incident:close', function(src, id)
    local perms = getPerms(src); if not perms or not perms.control then return false end
    return closeIncident(id, perms.name)
end)

lib.callback.register('vfmdt:control:message', function(src, target, text)
    local perms = getPerms(src); if not perms or not perms.control then return false end
    local payload = { from = Config.Branding.controlName, name = perms.name, text = clamp(text, 500), at = now() }
    if target == 'all' then
        broadcast('message', payload)
    elseif Units[tonumber(target)] then
        TriggerClientEvent('vfmdt:client:sync', tonumber(target), 'message', payload)
    end
    return true
end)

lib.callback.register('vfmdt:unit:message', function(src, text)
    local u = Units[src]; if not u then return false end
    local payload = { from = u.callsign, name = u.name, text = clamp(text, 500), at = now(), toControl = true }
    for s, unit in pairs(Units) do
        if unit.control then TriggerClientEvent('vfmdt:client:sync', s, 'message', payload) end
    end
    return true
end)

-- Hydrants
lib.callback.register('vfmdt:hydrant:save', function(src, d)
    local perms = getPerms(src); if not perms or not perms.editHydrants then return false, 'Not authorised' end
    local row = {
        code = clamp(d.code, 32), type = clamp(d.type, 32), status = clamp(d.status, 32), defect = clamp(d.defect, 500),
        x = tonumber(d.x) or 0.0, y = tonumber(d.y) or 0.0, z = tonumber(d.z) or 0.0, updated_by = perms.name, updated_at = now(),
    }
    local id = tonumber(d.id)
    if id and Hydrants[id] then
        MySQL.update.await('UPDATE firemdt_hydrants SET code=?, type=?, status=?, defect=?, x=?, y=?, z=?, updated_by=?, updated_at=? WHERE id=?',
            { row.code, row.type, row.status, row.defect, row.x, row.y, row.z, row.updated_by, row.updated_at, id })
    else
        id = MySQL.insert.await('INSERT INTO firemdt_hydrants (code, type, status, defect, x, y, z, updated_by, updated_at) VALUES (?,?,?,?,?,?,?,?,?)',
            { row.code, row.type, row.status, row.defect, row.x, row.y, row.z, row.updated_by, row.updated_at })
        if row.code == '' then
            row.code = ('H%04d'):format(id)
            MySQL.update('UPDATE firemdt_hydrants SET code = ? WHERE id = ?', { row.code, id })
        end
    end
    row.id = id
    Hydrants[id] = row
    broadcast('hydrant', row)
    return true, id
end)

lib.callback.register('vfmdt:hydrant:delete', function(src, id)
    local perms = getPerms(src); if not perms or not perms.editRisks then return false, 'Not authorised' end
    id = tonumber(id); if not Hydrants[id] then return false end
    MySQL.update.await('DELETE FROM firemdt_hydrants WHERE id = ?', { id })
    Hydrants[id] = nil
    broadcast('hydrantDelete', id)
    return true
end)

-- Risks
lib.callback.register('vfmdt:risk:save', function(src, d)
    local perms = getPerms(src); if not perms or not perms.editRisks then return false, 'Not authorised' end
    local row = {
        name = clamp(d.name, 128), address = clamp(d.address, 128), level = math.max(1, math.min(3, tonumber(d.level) or 1)),
        x = tonumber(d.x) or 0.0, y = tonumber(d.y) or 0.0, z = tonumber(d.z) or 0.0, radius = tonumber(d.radius) or 50.0,
        hazards = clamp(d.hazards, 2000), access = clamp(d.access, 1000), water = clamp(d.water, 1000),
        contacts = clamp(d.contacts, 500), notes = clamp(d.notes, 2000), updated_by = perms.name, updated_at = now(),
    }
    if row.name == '' then return false, 'Enter a site name' end
    local id = tonumber(d.id)
    if id and Risks[id] then
        MySQL.update.await('UPDATE firemdt_risks SET name=?, address=?, level=?, x=?, y=?, z=?, radius=?, hazards=?, access=?, water=?, contacts=?, notes=?, updated_by=?, updated_at=? WHERE id=?',
            { row.name, row.address, row.level, row.x, row.y, row.z, row.radius, row.hazards, row.access, row.water, row.contacts, row.notes, row.updated_by, row.updated_at, id })
    else
        id = MySQL.insert.await('INSERT INTO firemdt_risks (name, address, level, x, y, z, radius, hazards, access, water, contacts, notes, updated_by, updated_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
            { row.name, row.address, row.level, row.x, row.y, row.z, row.radius, row.hazards, row.access, row.water, row.contacts, row.notes, row.updated_by, row.updated_at })
    end
    row.id = id
    Risks[id] = row
    broadcast('risk', row)
    return true, id
end)

lib.callback.register('vfmdt:risk:delete', function(src, id)
    local perms = getPerms(src); if not perms or not perms.editRisks then return false end
    id = tonumber(id); if not Risks[id] then return false end
    MySQL.update.await('DELETE FROM firemdt_risks WHERE id = ?', { id })
    Risks[id] = nil
    broadcast('riskDelete', id)
    return true
end)

-- SOPs
lib.callback.register('vfmdt:sop:save', function(src, d)
    local perms = getPerms(src); if not perms or not perms.editSops then return false, 'Not authorised' end
    local row = { category = clamp(d.category, 64), title = clamp(d.title, 128), body = clamp(d.body, 8000), updated_by = perms.name, updated_at = now() }
    if row.title == '' then return false, 'Enter a title' end
    local id = tonumber(d.id)
    if id and Sops[id] then
        MySQL.update.await('UPDATE firemdt_sops SET category=?, title=?, body=?, updated_by=?, updated_at=? WHERE id=?',
            { row.category, row.title, row.body, row.updated_by, row.updated_at, id })
    else
        id = MySQL.insert.await('INSERT INTO firemdt_sops (category, title, body, updated_by, updated_at) VALUES (?,?,?,?,?)',
            { row.category, row.title, row.body, row.updated_by, row.updated_at })
    end
    row.id = id
    Sops[id] = row
    broadcast('sop', row)
    return true, id
end)

lib.callback.register('vfmdt:sop:delete', function(src, id)
    local perms = getPerms(src); if not perms or not perms.editSops then return false end
    id = tonumber(id); if not Sops[id] then return false end
    MySQL.update.await('DELETE FROM firemdt_sops WHERE id = ?', { id })
    Sops[id] = nil
    broadcast('sopDelete', id)
    return true
end)

-- ─────────────────────────────────────────────────────────────
-- Position tracking + auto "in attendance"
-- ─────────────────────────────────────────────────────────────
CreateThread(function()
    while true do
        Wait(Config.UnitBroadcastInterval)
        if next(Units) then
            for src, u in pairs(Units) do
                local ped = GetPlayerPed(src)
                if ped and ped ~= 0 then
                    local c = GetEntityCoords(ped)
                    u.coords = { x = c.x, y = c.y, z = c.z }
                    u.heading = GetEntityHeading(ped)
                    if Config.AutoAttendDistance > 0 and u.incident and u.status == Config.MobileStatus then
                        local inc = Incidents[u.incident]
                        if inc and #(c - vec3(inc.x, inc.y, inc.z)) <= Config.AutoAttendDistance then
                            setStatus(src, Config.AttendStatus)
                        end
                    end
                end
            end
            pushUnits()
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local u = Units[src]
    if u then
        if u.incident then addLog(u.incident, 'status', u.callsign .. ' lost contact', u.name, u.callsign) end
        Units[src] = nil
        pushUnits()
    end
end)

-- ─────────────────────────────────────────────────────────────
-- Exports for other resources (dispatch, fire alarm, fire script…)
-- ─────────────────────────────────────────────────────────────
---@param data { type:string, priority?:string, location:string, coords:vector3|table, details?:string, caller?:string, source?:string, mobilise?:number[] }
exports('CreateIncident', function(data)
    while not Ready do Wait(100) end
    local inc, err = createIncident(data, data.author or Config.Branding.controlName)
    if not inc then return nil, err end
    for _, s in ipairs(data.mobilise or {}) do attach(s, inc.id, true) end
    return inc.id, inc.ref
end)

exports('AddIncidentMessage', function(id, text, author)
    if not Incidents[id] then return false end
    addLog(id, 'message', text, author or Config.Branding.controlName)
    return true
end)

exports('CloseIncident', function(id) return closeIncident(id, Config.Branding.controlName) end)
exports('MobiliseUnit', function(id, src) return attach(src, id, true) end)
exports('GetOpenIncidents', function()
    local l = {}
    for _, inc in pairs(Incidents) do if inc.status == 'open' then l[#l + 1] = publicIncident(inc) end end
    return l
end)
exports('GetUnits', unitList)
