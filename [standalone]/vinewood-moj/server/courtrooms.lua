-- Courtrooms built in game: a centre and radius, plus laptops and microphones placed by admins.
-- Every client gets the list and builds its own ox_target points, props and microphone checks.
Rooms = {}

local CR = Config.Courtrooms or {}
local list = {}          -- [id] = room
local laptopRoom = {}    -- [src] = room id the player opened the system from
local deskAt = {}        -- [src] = { room = id, point = { x, y, z } } custody desk they're working at

local function decode(r)
    r.centre = U.decode(r.centre)
    r.points = U.decode(r.points)
    r.radius = tonumber(r.radius) or 20.0
    return r
end

function Rooms.Load()
    list = {}
    for _, r in ipairs(MySQL.query.await('SELECT * FROM vw_moj_courtrooms ORDER BY label ASC') or {}) do
        list[r.id] = decode(r)
    end
end

function Rooms.Get(id) return list[tonumber(id) or 0] end

function Rooms.Public()
    local out = {}
    for _, r in pairs(list) do
        out[#out + 1] = { id = r.id, label = r.label, court_id = r.court_id, centre = r.centre, radius = r.radius, points = r.points }
    end
    table.sort(out, function(a, b) return a.label < b.label end)
    return out
end

function Rooms.Broadcast()
    TriggerClientEvent('vinewood-moj:client:courtrooms', -1, Rooms.Public())
end

local function save(r)
    MySQL.update.await('UPDATE vw_moj_courtrooms SET label = ?, court_id = ?, centre = ?, radius = ?, points = ?, updated_at = ? WHERE id = ?',
        { r.label, r.court_id, U.encode(r.centre), r.radius, U.encode(r.points), U.now(), r.id })
    Rooms.Broadcast()
end

--- Where defendants are sent for a court: its first courtroom, otherwise Config.Courts coords.
function Rooms.CourtCoords(court)
    if not court then return nil end
    for _, r in pairs(list) do
        if r.court_id == court.id and r.centre and r.centre.x then return vec3(r.centre.x, r.centre.y, r.centre.z) end
    end
    return court.coords
end

function Rooms.IsAdmin(src)
    for _, ace in ipairs(CR.AdminAces or {}) do
        if IsPlayerAceAllowed(src, ace) then return true end
    end
    return false
end

function Rooms.LaptopRoom(src) return laptopRoom[src] and list[laptopRoom[src]] end
function Rooms.ClearLaptop(src) laptopRoom[src], deskAt[src] = nil, nil end

--- Does this court have a custody desk placed in any of its courtrooms?
function Rooms.HasDesk(courtId)
    for _, r in pairs(list) do
        if r.court_id == courtId then
            for _, p in ipairs(r.points or {}) do if p.kind == 'custody' then return true end end
        end
    end
    return false
end

--- The custody desk this player is at: room, desk coords. Nil if they walked off.
function Rooms.Desk(src)
    local d = deskAt[src]
    if not d then return nil end
    local r = list[d.room]
    if not r then return nil end
    local at = vec3(d.point.x, d.point.y, d.point.z)
    if #(GetEntityCoords(GetPlayerPed(src)) - at) > 6.0 then return nil end
    return r, at
end

local function pos(src)
    local p = GetEntityCoords(GetPlayerPed(src))
    return { x = math.floor(p.x * 100) / 100, y = math.floor(p.y * 100) / 100, z = math.floor(p.z * 100) / 100 }
end

local COURT_ROLES = { judge = true, clerk = true, cps = true, defence = true }
Rooms.CourtRoles = COURT_ROLES

---------------------------------------------------------------------------
-- Everyone: the room list, and opening a laptop
---------------------------------------------------------------------------
lib.callback.register('vinewood-moj:server:courtrooms', function() return Rooms.Public() end)

lib.callback.register('vinewood-moj:server:openLaptop', function(src, roomId, index)
    local r = Rooms.Get(roomId)
    local p = r and r.points[tonumber(index) or 0]
    if not p or p.kind ~= 'laptop' then return { error = 'This laptop is not set up.' } end
    if #(GetEntityCoords(GetPlayerPed(src)) - vec3(p.x, p.y, p.z)) > 4.0 then return { error = 'You need to be at the laptop.' } end
    local a = U.Access(src)
    if not a then return { error = 'You do not have access to the court system.' } end
    local allowed = p.roles and #p.roles > 0 and p.roles or CR.LaptopRoles or {}
    local ok = false
    for _, role in ipairs(allowed) do if role == a.role then ok = true end end
    if not ok then return { error = ('This laptop is for %s.'):format(p.label or 'other court staff') } end
    laptopRoom[src] = r.id
    return { role = a.role, room = r.label }
end)

lib.callback.register('vinewood-moj:server:openDesk', function(src, roomId, index)
    local r = Rooms.Get(roomId)
    local p = r and r.points[tonumber(index) or 0]
    if not p or p.kind ~= 'custody' then return { error = 'This custody desk is not set up.' } end
    if #(GetEntityCoords(GetPlayerPed(src)) - vec3(p.x, p.y, p.z)) > 4.0 then return { error = 'You need to be at the desk.' } end
    local a = U.Access(src)
    local ok = false
    for _, role in ipairs((Config.CustodyDesk or {}).Roles or {}) do if a and role == a.role then ok = true end end
    if not ok then return { error = 'Only police, prison officers and court staff can use the custody desk.' } end
    deskAt[src] = { room = r.id, point = { x = p.x, y = p.y, z = p.z } }
    laptopRoom[src] = r.id
    return { role = a.role, room = r.label, roomId = r.id }
end)

AddEventHandler('playerDropped', function() laptopRoom[source], deskAt[source] = nil, nil end)

---------------------------------------------------------------------------
-- Admins: building rooms
---------------------------------------------------------------------------
local function cleanRoles(roles)
    local valid, out = {}, {}
    for _, r in ipairs(CR.LaptopRoles or {}) do valid[r] = true end
    for _, r in ipairs(type(roles) == 'table' and roles or {}) do if valid[r] then out[#out + 1] = r end end
    return out
end

local ADMIN = {}

ADMIN.list = function()
    local screens = {}
    for i, m in ipairs(CR.ScreenModels or {}) do screens[#screens + 1] = { index = i, label = m.label or m.model } end
    local roles = {}
    for _, r in ipairs(CR.LaptopRoles or {}) do roles[#roles + 1] = { id = r, label = Config.Roles[r] and Config.Roles[r].label or r } end
    return { rooms = Rooms.Public(), courts = Config.Courts, roles = roles, micReach = CR.MicReach, micRange = CR.MicRange,
        laptopProp = CR.LaptopProp, micProp = CR.MicProp, voice = GetResourceState('pma-voice') == 'started',
        target = GetResourceState('ox_target') == 'started', screens = screens }
end

ADMIN.create = function(src, d)
    local label = U.trim(d.label, 96)
    if not label then return { error = 'Give the courtroom a name.' } end
    local court = U.court(d.courtId) and d.courtId or (Config.Courts[1] and Config.Courts[1].id)
    local t = U.now()
    local id = MySQL.insert.await([[INSERT INTO vw_moj_courtrooms (label, court_id, centre, radius, points, created_by, created_at, updated_at)
        VALUES (?, ?, ?, ?, '[]', ?, ?, ?)]], { label, court, U.encode(pos(src)), math.max(5.0, math.min(150.0, tonumber(d.radius) or 20.0)), Bridge.GetName(src), t, t })
    Rooms.Load()
    Rooms.Broadcast()
    return { ok = true, id = id }
end

ADMIN.update = function(src, d)
    local r = Rooms.Get(d.id)
    if not r then return { error = 'Courtroom not found.' } end
    r.label = U.trim(d.label, 96) or r.label
    if U.court(d.courtId) then r.court_id = d.courtId end
    if d.radius then r.radius = math.max(5.0, math.min(150.0, tonumber(d.radius) or r.radius)) end
    if d.recentre then r.centre = pos(src) end
    save(r)
    return { ok = true }
end

ADMIN.delete = function(_, d)
    local r = Rooms.Get(d.id)
    if not r then return { error = 'Courtroom not found.' } end
    MySQL.update.await('DELETE FROM vw_moj_courtrooms WHERE id = ?', { r.id })
    Rooms.Load()
    Rooms.Broadcast()
    return { ok = true }
end

ADMIN.addPoint = function(_, d)
    local r = Rooms.Get(d.id)
    if not r then return { error = 'Courtroom not found.' } end
    local p = type(d.point) == 'table' and d.point or {}
    if p.kind ~= 'laptop' and p.kind ~= 'mic' and p.kind ~= 'custody' and p.kind ~= 'screen' then return { error = 'Unknown point.' } end
    local x, y, z = tonumber(p.x), tonumber(p.y), tonumber(p.z)
    if not x or not y or not z then return { error = 'No position.' } end
    if r.centre and r.centre.x and #(vec3(x, y, z) - vec3(r.centre.x, r.centre.y, r.centre.z)) > r.radius + 5.0 then
        return { error = 'That spot is outside the courtroom. Move the centre or make the room bigger.' }
    end
    -- mode: 'spawn' (we spawn the prop), 'pick' (an object already in the map was selected), 'spot' (just a position)
    local mode = (p.mode == 'pick' or p.mode == 'spot') and p.mode or 'spawn'
    if p.kind == 'screen' and mode == 'spot' then mode = 'spawn' end
    local target, modelHash, modelIndex
    if p.kind == 'screen' then
        if mode == 'pick' then
            modelHash = math.floor(tonumber(p.modelHash) or 0)
            if modelHash == 0 then return { error = 'No TV was selected.' } end
            -- A known TV model uses its own render target; a custom one needs it typed in.
            for i, m in ipairs(CR.ScreenModels or {}) do
                if joaat(m.model) == modelHash or GetHashKey(m.model) == modelHash then modelIndex, target = i, m.target end
            end
            if not target then
                target = type(p.target) == 'string' and p.target:match('^[%w_]+$') and p.target:sub(1, 40) or nil
                if not target then return { error = 'Enter the render target name for this TV (tvscreen for most TVs).' } end
            end
        else
            modelIndex = math.max(1, math.min(#(CR.ScreenModels or {}), tonumber(p.model) or 1))
        end
    end
    r.points[#r.points + 1] = {
        kind = p.kind, x = x, y = y, z = z, h = tonumber(p.h) or 0.0, mode = mode,
        prop = mode == 'spawn' and (p.kind == 'screen' or p.prop ~= false),
        mapModel = mode == 'pick' and math.floor(tonumber(p.modelHash) or 0) or nil,
        target = mode == 'pick' and p.kind == 'screen' and target or nil,
        label = U.trim(p.label, 48) or (p.kind == 'laptop' and 'Court laptop' or p.kind == 'custody' and 'Court custody desk'
            or p.kind == 'screen' and 'Screen' or 'Microphone'),
        model = p.kind == 'screen' and modelIndex or nil,
        roles = p.kind == 'laptop' and cleanRoles(p.roles) or nil,
        range = p.kind == 'mic' and tonumber(p.range) or nil,
    }
    save(r)
    return { ok = true }
end

ADMIN.updatePoint = function(_, d)
    local r = Rooms.Get(d.id)
    local p = r and r.points[tonumber(d.index) or 0]
    if not p then return { error = 'Point not found.' } end
    if d.label then p.label = U.trim(d.label, 48) or p.label end
    if d.roles and p.kind == 'laptop' then p.roles = cleanRoles(d.roles) end
    if d.range ~= nil and p.kind == 'mic' then p.range = type(d.range) == 'number' and math.max(3.0, d.range) or nil end
    if d.prop ~= nil and p.kind ~= 'screen' and p.mode ~= 'pick' then p.prop = d.prop == true; p.mode = p.prop and 'spawn' or 'spot' end
    save(r)
    return { ok = true }
end

ADMIN.removePoint = function(_, d)
    local r = Rooms.Get(d.id)
    local i = tonumber(d.index)
    if not r or not i or not r.points[i] then return { error = 'Point not found.' } end
    table.remove(r.points, i)
    save(r)
    return { ok = true }
end

ADMIN.teleport = function(src, d)
    local r = Rooms.Get(d.id)
    if not r or not r.centre or not r.centre.x then return { error = 'Courtroom not found.' } end
    local p = d.index and r.points[tonumber(d.index)]
    local c = p and vec3(p.x, p.y, p.z) or vec3(r.centre.x, r.centre.y, r.centre.z)
    SetEntityCoords(GetPlayerPed(src), c.x, c.y, c.z, false, false, false, false)
    return { ok = true }
end

lib.callback.register('vinewood-moj:server:roomsAdmin', function(src, action, data)
    if not Rooms.IsAdmin(src) then return { error = 'Only server admins can set up courtrooms.' } end
    local fn = ADMIN[action]
    if not fn then return { error = 'Unknown request.' } end
    data = type(data) == 'table' and data or {}
    local before = data.id and Rooms.Get(data.id)
    local beforeLabel = before and before.label
    local beforePoint = before and data.index and before.points[tonumber(data.index) or 0]
    local ok, r = pcall(fn, src, data)
    if not ok then print('[vinewood-moj] courtrooms: ' .. tostring(r)) return { error = 'The request failed. Check the server console.' } end
    -- Log every change admins make to courtrooms.
    local WHAT = { create = 'Courtroom created', update = 'Courtroom edited', delete = 'Courtroom deleted',
        addPoint = 'Point placed', updatePoint = 'Point edited', removePoint = 'Point removed' }
    if r and r.ok and WHAT[action] then
        local room = Rooms.Get(r.id or data.id)
        local point = action == 'addPoint' and data.point or beforePoint
        local PT = { laptop = 'Laptop', mic = 'Microphone', custody = 'Custody desk', screen = 'Screen' }
        Webhook.Send('courtrooms', ('%s: %s'):format(WHAT[action], (room and room.label) or beforeLabel or data.label or ''), nil, {
            { 'Point', point and ('%s%s'):format(PT[point.kind] or point.kind or '', point.label and (' · ' .. point.label) or '') },
            { 'How', point and (point.mode == 'pick' and 'Map object' or point.mode == 'spot' and 'Marked spot' or point.kind and 'Spawned prop') },
            { 'Admin', ('%s (%s)'):format(GetPlayerName(src) or '?', Bridge.GetName(src) or '?') },
        }, (action == 'delete' or action == 'removePoint') and 'red' or 'blue')
    end
    return r
end)

CreateThread(function()
    U.WaitReady()
    Rooms.Load()
    Rooms.Broadcast()
end)

---------------------------------------------------------------------------
-- Courtroom screens: one exhibit at a time per room, shown on every screen in it
---------------------------------------------------------------------------
local playing = {}   -- [roomId] = { kind, src, label, url, startedAt, by, ref }

function Rooms.HasScreens(r)
    for _, p in ipairs(r and r.points or {}) do if p.kind == 'screen' then return true end end
    return false
end

local function hostOf(url) return (url:match('^https?://([^/:?#]+)') or ''):lower() end

local function hostAllowed(host)
    for _, h in ipairs(CR.VideoHosts or {}) do
        h = h:lower()
        if host == h or host:sub(-(#h + 1)) == '.' .. h then return true end
    end
    return false
end

--- A link someone pasted: { kind = 'file'|'medal'|'youtube', src = what the screen loads } or nil, reason.
function Rooms.ParseVideo(url)
    url = U.trim(url, 500)
    if not url then return nil, 'Paste a link to the footage.' end
    if not url:match('^https://') then return nil, 'The link must start with https://' end
    local host = hostOf(url)

    if host == 'medal.tv' or host == 'www.medal.tv' then
        if not CR.AllowMedal then return nil, 'Medal clips are switched off on this server.' end
        local path = url:match('^https?://[^/]+(/[^?#]*)') or ''
        -- /clip/<id>, /clips/<id>, /games/<game>/clips/<id>, /<lang>/games/<game>/clips/<id>, /users/<u>/clips/<id>,
        -- each optionally followed by /<key> (needed for unlisted clips, so it's kept).
        local id, key = path:match('/clips?/([%w_-]+)/?([%w_-]*)')
        if key == '' then key = nil end
        if not id then return nil, 'That does not look like a Medal clip link.' end
        return { kind = 'medal', src = ('https://medal.tv/clip/%s%s?autoplay=1&muted=0&loop=0&cta=0'):format(id, key and ('/' .. key) or '') }
    end

    if host == 'youtube.com' or host == 'www.youtube.com' or host == 'm.youtube.com' or host == 'youtu.be' then
        if not CR.AllowYouTube then return nil, 'YouTube links are switched off on this server.' end
        local id = url:match('[?&]v=([%w_-]+)') or url:match('youtu%.be/([%w_-]+)') or url:match('/shorts/([%w_-]+)') or url:match('/embed/([%w_-]+)')
        if not id then return nil, 'That does not look like a YouTube video link.' end
        return { kind = 'youtube', id = id, src = ('https://www.youtube.com/embed/%s?autoplay=1&controls=0&rel=0&modestbranding=1&playsinline=1'):format(id) }
    end

    local file = (url:match('^[^?#]+') or ''):lower()
    if file:match('%.mp4$') or file:match('%.webm$') or file:match('%.mov$') or file:match('%.m4v$') then
        if CR.AllowAnyVideoHost or hostAllowed(host) then return { kind = 'file', src = url } end
        return nil, ('Videos from %s are not allowed. Upload the clip to Medal or an allowed host.'):format(host)
    end
    return nil, 'Use a Medal clip, a YouTube video, or a direct link to a video file (.mp4, .webm).'
end

local function broadcast() TriggerClientEvent('vinewood-moj:client:screens', -1, playing) end

lib.callback.register('vinewood-moj:server:screens', function() return playing end)

function Rooms.NowShowing(roomId) return playing[roomId] end

function Rooms.Play(roomId, url, label, by, ref)
    local v, err = Rooms.ParseVideo(url)
    if not v then return nil, err end
    playing[roomId] = { kind = v.kind, src = v.src, id = v.id, url = url, label = U.trim(label, 80) or 'Exhibit', by = by, ref = ref, startedAt = os.time() }
    broadcast()
    return playing[roomId]
end

function Rooms.Restart(roomId)
    local p = playing[roomId]
    if not p then return false end
    p.startedAt = os.time()
    broadcast()
    return true
end

function Rooms.StopScreen(roomId)
    if not playing[roomId] then return false end
    playing[roomId] = nil
    broadcast()
    return true
end

CreateThread(function()
    while true do
        Wait(30000)
        local limit = (CR.MaxPlayMinutes or 15) * 60
        local changed = false
        for id, p in pairs(playing) do
            if os.time() - p.startedAt > limit then playing[id] = nil changed = true end
        end
        if changed then broadcast() end
    end
end)
