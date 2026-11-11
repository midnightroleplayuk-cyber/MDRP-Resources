-- Courts are kept in the database and managed in game (/courtrooms → Courts).
-- Config.Courts is only the starting list: it's copied in the first time the resource starts,
-- after that the database is the source and Config.Courts is refreshed from it.
Courts = {}

Courts.Kinds = { magistrates = "Magistrates' court", crown = 'Crown Court', county = 'County Court (civil)' }

local seed = {}
for i, c in ipairs(Config.Courts or {}) do seed[i] = c end

local function toVec(c)
    if type(c) == 'table' and c.x then return vec3(c.x + 0.0, c.y + 0.0, (c.z or 0) + 0.0) end
end

function Courts.Load()
    local rows = MySQL.query.await('SELECT * FROM vw_moj_courts ORDER BY sort ASC, label ASC') or {}
    if #rows == 0 then
        local t = U.now()
        for i, c in ipairs(seed) do
            MySQL.insert.await('INSERT IGNORE INTO vw_moj_courts (id, label, kind, coords, civil_default, sort, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
                { c.id, c.label, c.kind or 'magistrates', c.coords and U.encode({ x = c.coords.x, y = c.coords.y, z = c.coords.z }) or nil,
                  (Config.Civil and Config.Civil.Court == c.id) and 1 or 0, i, t, t })
        end
        rows = MySQL.query.await('SELECT * FROM vw_moj_courts ORDER BY sort ASC, label ASC') or {}
    end
    -- Refresh Config.Courts in place, so everything reading it sees the live list.
    for i = #Config.Courts, 1, -1 do Config.Courts[i] = nil end
    for _, r in ipairs(rows) do
        Config.Courts[#Config.Courts + 1] = {
            id = r.id, label = r.label, kind = r.kind, coords = toVec(U.decode(r.coords)), civilDefault = U.flag(r.civil_default),
        }
    end
end

--- The County Court civil claims go to unless the person issuing picks another.
function Courts.CivilDefault()
    for _, c in ipairs(Config.Courts) do if c.civilDefault and c.kind == 'county' then return c.id end end
    local cfg = Config.Civil and Config.Civil.Court
    if cfg and U.court(cfg) then return cfg end
    for _, c in ipairs(Config.Courts) do if c.kind == 'county' then return c.id end end
    return Config.Courts[1] and Config.Courts[1].id
end

--- For the UI: courts with their coords as plain tables and how many rooms each has.
function Courts.Public()
    local out = {}
    local rooms, desks = {}, {}
    for _, r in ipairs(Rooms.Public()) do
        rooms[r.court_id] = (rooms[r.court_id] or 0) + 1
        for _, p in ipairs(r.points or {}) do if p.kind == 'custody' then desks[r.court_id] = (desks[r.court_id] or 0) + 1 end end
    end
    for _, c in ipairs(Config.Courts) do
        out[#out + 1] = { id = c.id, label = c.label, kind = c.kind, kindLabel = Courts.Kinds[c.kind] or c.kind,
            hasCoords = c.coords ~= nil, civilDefault = c.civilDefault, rooms = rooms[c.id] or 0, desks = desks[c.id] or 0 }
    end
    return out
end

local function slug(label)
    local s = tostring(label):lower():gsub("[^%w]+", ''):sub(1, 12)
    if s == '' then s = 'court' end
    local id, n = s, 1
    while U.court(id) do n = n + 1; id = s:sub(1, 12 - #tostring(n)) .. n end
    return id
end

local function pos(src)
    local p = GetEntityCoords(GetPlayerPed(src))
    return { x = math.floor(p.x * 100) / 100, y = math.floor(p.y * 100) / 100, z = math.floor(p.z * 100) / 100 }
end

local function setCivilDefault(id)
    MySQL.update.await('UPDATE vw_moj_courts SET civil_default = 0')
    MySQL.update.await("UPDATE vw_moj_courts SET civil_default = 1 WHERE id = ? AND kind = 'county'", { id })
end

function Courts.Create(src, d)
    local label = U.trim(d.label, 96)
    if not label then return { error = 'Give the court a name.' } end
    if not Courts.Kinds[d.kind] then return { error = 'Choose what kind of court it is.' } end
    for _, c in ipairs(Config.Courts) do
        if c.label:lower() == label:lower() then return { error = 'There is already a court with that name.' } end
    end
    local id = slug(label)
    local t = U.now()
    MySQL.insert.await('INSERT INTO vw_moj_courts (id, label, kind, coords, sort, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
        { id, label, d.kind, d.here and U.encode(pos(src)) or nil, #Config.Courts + 1, t, t })
    if d.civilDefault and d.kind == 'county' then setCivilDefault(id) end
    Courts.Load()
    return { ok = true, id = id }
end

function Courts.Update(src, d)
    local c = U.court(d.courtId)
    if not c then return { error = 'Court not found.' } end
    local label = U.trim(d.label, 96) or c.label
    for _, o in ipairs(Config.Courts) do
        if o.id ~= c.id and o.label:lower() == label:lower() then return { error = 'There is already a court with that name.' } end
    end
    local kind = Courts.Kinds[d.kind] and d.kind or c.kind
    MySQL.update.await('UPDATE vw_moj_courts SET label = ?, kind = ?, updated_at = ? WHERE id = ?', { label, kind, U.now(), c.id })
    if d.here then MySQL.update.await('UPDATE vw_moj_courts SET coords = ? WHERE id = ?', { U.encode(pos(src)), c.id }) end
    if d.clearCoords then MySQL.update.await('UPDATE vw_moj_courts SET coords = NULL WHERE id = ?', { c.id }) end
    if d.civilDefault and kind == 'county' then setCivilDefault(c.id)
    elseif d.civilDefault == false and c.civilDefault then MySQL.update.await('UPDATE vw_moj_courts SET civil_default = 0 WHERE id = ?', { c.id }) end
    Courts.Load()
    return { ok = true }
end

--- Only courts nothing uses can be deleted; otherwise rename them.
function Courts.Delete(d)
    local c = U.court(d.courtId)
    if not c then return { error = 'Court not found.' } end
    if #Config.Courts <= 1 then return { error = 'There has to be at least one court.' } end
    local cases = MySQL.scalar.await('SELECT COUNT(*) FROM vw_moj_cases WHERE court_id = ?', { c.id }) or 0
    local hearings = MySQL.scalar.await("SELECT COUNT(*) FROM vw_moj_hearings WHERE court_id = ? AND status IN ('listed', 'open')", { c.id }) or 0
    local claims = MySQL.scalar.await('SELECT COUNT(*) FROM vw_moj_civil WHERE hearing_court = ?', { c.id }) or 0
    local rooms = 0
    for _, r in ipairs(Rooms.Public()) do if r.court_id == c.id then rooms = rooms + 1 end end
    local used = {}
    if cases > 0 then used[#used + 1] = ('%d case%s'):format(cases, cases == 1 and '' or 's') end
    if hearings > 0 then used[#used + 1] = ('%d listed hearing%s'):format(hearings, hearings == 1 and '' or 's') end
    if claims > 0 then used[#used + 1] = ('%d civil claim%s'):format(claims, claims == 1 and '' or 's') end
    if rooms > 0 then used[#used + 1] = ('%d courtroom%s'):format(rooms, rooms == 1 and '' or 's') end
    if #used > 0 then
        return { error = ('%s is used by %s. Rename it instead, or move its courtrooms to another court first.'):format(c.label, table.concat(used, ', ')) }
    end
    MySQL.update.await('DELETE FROM vw_moj_courts WHERE id = ?', { c.id })
    Courts.Load()
    return { ok = true }
end

CreateThread(function()
    U.WaitReady()
    Courts.Load()
end)
