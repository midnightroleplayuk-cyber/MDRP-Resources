-- Listing boards: TVs in hallways and foyers showing the day's court list, like the screens
-- outside real courtrooms. Placed in /courtrooms → Listing boards. Each shows one, several or
-- all courts, and can show full names, surnames or initials.
Boards = {}

local list = {}   -- [id] = board

Boards.NameStyles = { full = 'Full names', surname = 'Surnames only', initials = 'Initials only' }

local function decode(b)
    b.courts = U.decode(b.courts)
    b.point = U.decode(b.point)
    return b
end

function Boards.Load()
    list = {}
    for _, b in ipairs(MySQL.query.await('SELECT * FROM vw_moj_boards ORDER BY label ASC') or {}) do list[b.id] = decode(b) end
end

function Boards.Public()
    local out = {}
    for _, b in pairs(list) do
        out[#out + 1] = { id = b.id, label = b.label, courts = b.courts, names = b.names, point = b.point }
    end
    table.sort(out, function(a, c) return a.label < c.label end)
    return out
end

function Boards.Broadcast() TriggerClientEvent('vinewood-moj:client:boards', -1, Boards.Public()) end

local function cleanCourts(c)
    local out = {}
    for _, id in ipairs(type(c) == 'table' and c or {}) do if U.court(id) then out[#out + 1] = id end end
    return out
end

--- Name as the board shows it. Businesses are always shown in full.
local function styled(name, style, business)
    name = tostring(name or '')
    if business or style == 'full' or name == '' then return name end
    local parts = {}
    for w in name:gmatch('%S+') do parts[#parts + 1] = w end
    if style == 'surname' then return parts[#parts] or name end
    local ini = {}
    for _, w in ipairs(parts) do ini[#ini + 1] = w:sub(1, 1):upper() .. '.' end
    return table.concat(ini)
end

---------------------------------------------------------------------------
-- The feed a board shows
---------------------------------------------------------------------------
local STATUS = {
    listed = { 'Waiting', 'wait' }, open = { 'In court', 'live' }, done = { 'Concluded', 'done' },
    adjourned = { 'Adjourned', 'adj' }, fta = { 'Did not attend', 'warn' },
}

local function dayBounds()
    local d = os.date('*t')
    local start = os.time({ year = d.year, month = d.month, day = d.day, hour = 0 })
    return start, start + 86400
end

function Boards.Feed(b)
    local from, to = dayBounds()
    local courts = (b.courts and #b.courts > 0) and b.courts or nil
    local inCourts = function(id)
        if not courts then return true end
        for _, c in ipairs(courts) do if c == id then return true end end
        return false
    end
    local roomName = {}
    for _, r in ipairs(Rooms.Public()) do roomName[r.id] = r.label end
    local rows = {}
    local recent = U.now() - 3600   -- finished hearings stay on the board for an hour

    for _, h in ipairs(MySQL.query.await([[SELECT h.id, h.type, h.court_id, h.scheduled_at, h.status, h.room_id, h.updated_at, h.booked_at,
            c.ref, c.subject_name FROM vw_moj_hearings h JOIN vw_moj_cases c ON c.id = h.case_id
        WHERE h.scheduled_at BETWEEN ? AND ? AND (h.status IN ('listed', 'open') OR (h.status IN ('done', 'adjourned', 'fta') AND h.updated_at >= ?))
        ORDER BY h.scheduled_at ASC LIMIT 120]], { from, to, recent }) or {}) do
        if inCourts(h.court_id) then
            local st = STATUS[h.status] or { h.status, 'wait' }
            local court = U.court(h.court_id)
            rows[#rows + 1] = {
                at = h.scheduled_at, ref = h.ref, title = 'R v ' .. styled(h.subject_name, b.names),
                hearing = Cases.HearingTypes[h.type] or h.type, court = court and court.label or '',
                room = h.room_id and roomName[h.room_id] or nil, status = st[1], tone = st[2],
            }
        end
    end

    if Config.Civil and Config.Civil.enabled ~= false then
        for _, c in ipairs(MySQL.query.await([[SELECT id, ref, claimant_name, claimant_kind, defendant_name, defendant_kind, hearing_at, hearing_court,
                hearing_room, hearing_open, status FROM vw_moj_civil WHERE hearing_at BETWEEN ? AND ? AND status IN ('listed', 'defended', 'issued')
            ORDER BY hearing_at ASC LIMIT 60]], { from, to }) or {}) do
            if inCourts(c.hearing_court) then
                local open = U.flag(c.hearing_open)
                local court = U.court(c.hearing_court)
                rows[#rows + 1] = {
                    at = c.hearing_at, ref = c.ref,
                    title = ('%s v %s'):format(styled(c.claimant_name, b.names, c.claimant_kind == 'business'), styled(c.defendant_name, b.names, c.defendant_kind == 'business')),
                    hearing = 'Civil hearing', court = court and court.label or '', room = c.hearing_room and roomName[c.hearing_room] or nil,
                    status = open and 'In court' or 'Waiting', tone = open and 'live' or 'wait',
                }
            end
        end
    end

    table.sort(rows, function(a, c) return a.at < c.at end)
    local title
    if courts and #courts == 1 then title = (U.court(courts[1]) or {}).label end
    return { title = title or b.label, courtsName = Config.CourtsName, multi = not courts or #courts > 1, rows = rows, now = U.now() }
end

lib.callback.register('vinewood-moj:server:boards', function() return Boards.Public() end)

lib.callback.register('vinewood-moj:server:boardFeed', function(src, id)
    local b = list[tonumber(id) or 0]
    if not b or not b.point or not b.point.x then return nil end
    -- Only for people standing near it (it's a public board, but this stops anyone polling every board).
    if #(GetEntityCoords(GetPlayerPed(src)) - vec3(b.point.x, b.point.y, b.point.z)) > 40.0 then return nil end
    return Boards.Feed(b)
end)

---------------------------------------------------------------------------
-- Admin (called from server/courtrooms.lua's admin dispatcher)
---------------------------------------------------------------------------
function Boards.Add(src, d)
    local label = U.trim(d.label, 96)
    if not label then return { error = 'Give the board a name, e.g. "Ground floor foyer".' } end
    local p = type(d.point) == 'table' and d.point or {}
    local x, y, z = tonumber(p.x), tonumber(p.y), tonumber(p.z)
    if not x then return { error = 'No position.' } end
    local mode = p.mode == 'pick' and 'pick' or 'spawn'
    local point = {
        kind = 'screen', x = x, y = y, z = z, h = tonumber(p.h) or 0.0, mode = mode, prop = mode == 'spawn',
        model = mode == 'spawn' and math.max(1, math.min(#((Config.Courtrooms or {}).ScreenModels or {}), tonumber(p.model) or 1)) or nil,
        mapModel = mode == 'pick' and math.floor(tonumber(p.modelHash) or 0) or nil,
        geo = Rooms.CleanGeo(p.geo),
    }
    if mode == 'pick' and (point.mapModel or 0) == 0 then return { error = 'No TV was selected.' } end
    local names = Boards.NameStyles[d.names] and d.names or 'full'
    local t = U.now()
    local id = MySQL.insert.await('INSERT INTO vw_moj_boards (label, courts, names, point, created_by, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
        { label, U.encode(cleanCourts(d.courts)), names, U.encode(point), Bridge.GetName(src), t, t })
    Boards.Load()
    Boards.Broadcast()
    return { ok = true, id = id }
end

function Boards.Update(d)
    local b = list[tonumber(d.boardId) or 0]
    if not b then return { error = 'Board not found.' } end
    b.label = U.trim(d.label, 96) or b.label
    if d.courts then b.courts = cleanCourts(d.courts) end
    if Boards.NameStyles[d.names] then b.names = d.names end
    if d.geo then b.point.geo = Rooms.CleanGeo(d.geo) or b.point.geo end
    MySQL.update.await('UPDATE vw_moj_boards SET label = ?, courts = ?, names = ?, point = ?, updated_at = ? WHERE id = ?',
        { b.label, U.encode(b.courts), b.names, U.encode(b.point), U.now(), b.id })
    Boards.Broadcast()
    return { ok = true }
end

function Boards.Remove(d)
    local b = list[tonumber(d.boardId) or 0]
    if not b then return { error = 'Board not found.' } end
    MySQL.update.await('DELETE FROM vw_moj_boards WHERE id = ?', { b.id })
    Boards.Load()
    Boards.Broadcast()
    return { ok = true }
end

function Boards.Get(id) return list[tonumber(id) or 0] end

CreateThread(function()
    U.WaitReady()
    Boards.Load()
    Boards.Broadcast()
end)
