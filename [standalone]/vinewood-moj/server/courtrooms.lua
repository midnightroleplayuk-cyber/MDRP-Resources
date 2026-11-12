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
    r.pa_volume = tonumber(r.pa_volume) or 1.0
    -- A drawn shape decides the centre and size; the circle is kept underneath as the fallback.
    local shape = U.decode(r.shape)
    r.shape = shape and shape.type == 'poly' and shape or nil
    if r.shape then
        r.circle = { centre = r.centre, radius = r.radius }
        r.centre, r.radius = Zones.Fit(r.shape)
    end
    return r
end

function Rooms.Load()
    list = {}
    for _, r in ipairs(MySQL.query.await('SELECT * FROM vw_moj_courtrooms ORDER BY label ASC') or {}) do
        list[r.id] = decode(r)
    end
    Rooms.loaded = true
end

function Rooms.Get(id) return list[tonumber(id) or 0] end

function Rooms.Public()
    local out = {}
    for _, r in pairs(list) do
        local court = U.court(r.court_id)
        out[#out + 1] = { id = r.id, label = r.label, court_id = r.court_id, courtLabel = court and court.label or nil,
            centre = r.centre, radius = r.radius, points = r.points, shape = r.shape,
            circle = r.circle and { radius = r.circle.radius } or nil, paVolume = r.pa_volume or 1.0 }
    end
    table.sort(out, function(a, b) return a.label < b.label end)
    return out
end

function Rooms.Broadcast()
    TriggerClientEvent('vinewood-moj:client:courtrooms', -1, Rooms.Public())
    -- Listing boards show room and court names: refresh them now rather than on their next tick.
    TriggerClientEvent('vinewood-moj:client:boardsRefresh', -1)
end

local function save(r)
    -- With a drawn shape, the stored centre/radius stay as the old circle (used again if the shape is removed).
    local centre, radius = r.centre, r.radius
    if r.shape and r.circle then centre, radius = r.circle.centre, r.circle.radius end
    MySQL.update.await('UPDATE vw_moj_courtrooms SET label = ?, court_id = ?, centre = ?, radius = ?, points = ?, shape = ?, updated_at = ? WHERE id = ?',
        { r.label, r.court_id, U.encode(centre), radius, U.encode(r.points), r.shape and U.encode(r.shape) or nil, U.now(), r.id })
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
    if Courts.HasDeskFor(courtId, 'custody') then return true end
    for _, r in pairs(list) do
        if r.court_id == courtId then
            for _, p in ipairs(r.points or {}) do if p.kind == 'custody' then return true end end
        end
    end
    return false
end

--- The custody desk this player is at: { court_id, label }, desk coords. Nil if they walked off.
--- Works for court desks and for older desks placed in a courtroom.
function Rooms.Desk(src)
    local d = deskAt[src]
    if not d then return nil end
    local at = vec3(d.point.x, d.point.y, d.point.z)
    if #(GetEntityCoords(GetPlayerPed(src)) - at) > 6.0 then return nil end
    if d.court then
        local c = U.court(d.court)
        if not c then return nil end
        return { court_id = c.id, label = d.label or c.label, courtLabel = c.label, serves = d.serves or { c.id }, kind = d.kind or 'custody' }, at
    end
    local r = list[d.room]
    if not r then return nil end
    local c = U.court(r.court_id)
    return { court_id = r.court_id, label = r.label, courtLabel = c and c.label or r.label, serves = { r.court_id }, kind = 'custody' }, at
end

local function pos(src)
    local p = GetEntityCoords(GetPlayerPed(src))
    return { x = math.floor(p.x * 100) / 100, y = math.floor(p.y * 100) / 100, z = math.floor(p.z * 100) / 100 }
end

local COURT_ROLES = { judge = true, clerk = true, cps = true, defence = true }

--- A screen's fitted picture: size and offset from the TV, in metres.
function Rooms.CleanGeo(g)
    if type(g) ~= 'table' then return nil end
    local function n(v, lo, hi) v = tonumber(v) if not v then return nil end return math.max(lo, math.min(hi, v)) end
    local out = { w = n(g.w, 0.1, 20), h = n(g.h, 0.1, 12), up = n(g.up, -5, 10), side = n(g.side, -10, 10), fwd = n(g.fwd, -5, 5), flip = g.flip == true }
    if not (out.w and out.h and out.up and out.side and out.fwd) then return nil end
    return out
end
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

lib.callback.register('vinewood-moj:server:openCourtDesk', function(src, courtId, index)
    local c, p = Courts.Desk(courtId, index)
    if not p then return { error = 'This custody desk is not set up.' } end
    if #(GetEntityCoords(GetPlayerPed(src)) - vec3(p.x, p.y, p.z)) > 4.0 then return { error = 'You need to be at the desk.' } end
    local a = U.Access(src)
    local kind = p.kind or 'custody'
    local roles = kind == 'front' and ((Config.FrontDesk or {}).Roles or { 'clerk', 'judge' }) or ((Config.CustodyDesk or {}).Roles or {})
    local ok = false
    for _, role in ipairs(roles) do if a and role == a.role then ok = true end end
    if not ok then
        return { error = kind == 'front' and 'The front desk system is for court staff. Use "Check in for my hearing" instead.'
            or 'Only police, prison officers and court staff can use the custody desk.' }
    end
    local label = ('%s · %s'):format(c.label, p.label or (kind == 'front' and 'Front desk' or 'Custody suite'))
    deskAt[src] = { court = c.id, label = label, point = { x = p.x, y = p.y, z = p.z }, serves = Courts.Serves(c, p), kind = kind }
    laptopRoom[src] = nil
    return { role = a.role, room = label, kind = kind }
end)

-- Anyone: check yourself in for your hearing at a front desk.
lib.callback.register('vinewood-moj:server:selfCheckIn', function(src, courtId, index)
    if (Config.FrontDesk or {}).enabled == false then return { error = 'The front desk is closed.' } end
    local c, p = Courts.Desk(courtId, index)
    if not p or (p.kind or 'custody') ~= 'front' then return { error = 'This desk is not a front desk.' } end
    if #(GetEntityCoords(GetPlayerPed(src)) - vec3(p.x, p.y, p.z)) > 4.0 then return { error = 'You need to be at the desk.' } end
    return FrontDesk.SelfCheckIn(src, Courts.Serves(c, p))
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
    local kinds = {}
    for id, label in pairs(Courts.Kinds) do kinds[#kinds + 1] = { id = id, label = label } end
    table.sort(kinds, function(a, b) return a.label < b.label end)
    local styles = {}
    for id, label in pairs(Boards.NameStyles) do styles[#styles + 1] = { id = id, label = label } end
    -- Courtrooms whose areas overlap: screens and microphones go by the nearest centre, but it's
    -- better to size rooms so they don't.
    local overlaps, pub = {}, Rooms.Public()
    for i = 1, #pub do
        for j = i + 1, #pub do
            local a, b = pub[i], pub[j]
            if a.centre and a.centre.x and b.centre and b.centre.x and Zones.Overlap(a, b) then
                local d = #(vec3(a.centre.x, a.centre.y, a.centre.z) - vec3(b.centre.x, b.centre.y, b.centre.z))
                overlaps[#overlaps + 1] = { a = a.label, b = b.label, apart = math.floor(d * 10) / 10, aId = a.id, bId = b.id,
                    shapes = (a.shape and 1 or 0) + (b.shape and 1 or 0) }
            end
        end
    end
    return { overlaps = overlaps, rooms = pub, courts = Courts.Public(), kinds = kinds, roles = roles, boards = Boards.Public(), nameStyles = styles, micReach = CR.MicReach, micRange = CR.MicRange,
        laptopProp = CR.LaptopProp, micProp = CR.MicProp, voice = GetResourceState('pma-voice') == 'started',
        target = GetResourceState('ox_target') == 'started', screens = screens, overlay = (CR.ScreenRender or 'overlay') ~= 'rendertarget' }
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
    if r.shape and r.circle then
        if d.radius then r.circle.radius = math.max(3.0, math.min(150.0, tonumber(d.radius) or r.circle.radius)) end
        if d.recentre then r.circle.centre = pos(src) end
    else
        if d.radius then r.radius = math.max(3.0, math.min(150.0, tonumber(d.radius) or r.radius)) end
        if d.recentre then r.centre = pos(src) end
    end
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
    if p.kind ~= 'laptop' and p.kind ~= 'mic' and p.kind ~= 'custody' and p.kind ~= 'screen' and p.kind ~= 'speaker' then return { error = 'Unknown point.' } end
    local x, y, z = tonumber(p.x), tonumber(p.y), tonumber(p.z)
    if not x or not y or not z then return { error = 'No position.' } end
    -- Custody desks can go anywhere in the building (the cells are rarely inside the courtroom).
    if p.kind ~= 'custody' and not Zones.Contains(r, vec3(x, y, z), 3.0) then
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
            or p.kind == 'screen' and 'Screen' or p.kind == 'speaker' and 'Speaker' or 'Microphone'),
        model = p.kind == 'screen' and modelIndex or nil,
        geo = p.kind == 'screen' and Rooms.CleanGeo(p.geo) or nil,
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
    if d.geo and p.kind == 'screen' then p.geo = Rooms.CleanGeo(d.geo) or p.geo end
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

ADMIN.boardAdd = function(src, d) return Boards.Add(src, d) end
ADMIN.boardUpdate = function(_, d) return Boards.Update(d) end
ADMIN.boardRemove = function(_, d) return Boards.Remove(d) end
ADMIN.boardTeleport = function(src, d)
    local b = Boards.Get(d.boardId)
    if not b or not b.point or not b.point.x then return { error = 'Board not found.' } end
    SetEntityCoords(GetPlayerPed(src), b.point.x, b.point.y, b.point.z, false, false, false, false)
    return { ok = true }
end

ADMIN.courtDeskAdd = function(_, d) return Courts.AddDesk(d) end
ADMIN.courtDeskRemove = function(_, d) return Courts.RemoveDesk(d) end
ADMIN.courtDeskTeleport = function(src, d)
    local _, p = Courts.Desk(d.courtId, d.index)
    if not p then return { error = 'Desk not found.' } end
    SetEntityCoords(GetPlayerPed(src), p.x, p.y, p.z, false, false, false, false)
    return { ok = true }
end

ADMIN.courtCreate = function(src, d) return Courts.Create(src, d) end
ADMIN.courtUpdate = function(src, d) return Courts.Update(src, d) end
ADMIN.courtDelete = function(_, d) return Courts.Delete(d) end

--- Draw the room's real shape (walls and ceiling). shape = { points = { {x,y}... }, minZ, maxZ }
ADMIN.setShape = function(_, d)
    local r = Rooms.Get(d.id)
    if not r then return { error = 'Courtroom not found.' } end
    local shape, err = Zones.Clean(d.shape)
    if not shape then return { error = err } end
    if not r.circle then r.circle = { centre = r.centre, radius = r.radius } end
    r.shape = shape
    r.centre, r.radius = Zones.Fit(shape)
    save(r)
    -- Points that are now outside the room still work, but tell the admin.
    local outside = 0
    for _, p in ipairs(r.points or {}) do
        if p.kind ~= 'custody' and not Zones.Contains(r, vec3(p.x, p.y, p.z), 1.0) then outside = outside + 1 end
    end
    return { ok = true, outside = outside }
end

ADMIN.clearShape = function(_, d)
    local r = Rooms.Get(d.id)
    if not r then return { error = 'Courtroom not found.' } end
    if r.circle then r.centre, r.radius = r.circle.centre, r.circle.radius end
    r.shape, r.circle = nil, nil
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
    local beforeCourt = data.courtId and U.court(data.courtId)
    local beforeCourtLabel = beforeCourt and beforeCourt.label
    local ok, r = pcall(fn, src, data)
    if not ok then print('[vinewood-moj] courtrooms: ' .. tostring(r)) return { error = 'The request failed. Check the server console.' } end
    -- Log every change admins make to courtrooms.
    local WHAT = { create = 'Courtroom created', update = 'Courtroom edited', delete = 'Courtroom deleted',
        addPoint = 'Point placed', updatePoint = 'Point edited', removePoint = 'Point removed',
        setShape = 'Room shape drawn', clearShape = 'Room shape removed' }
    local BOARD = { boardAdd = 'Listing board placed', boardUpdate = 'Listing board edited', boardRemove = 'Listing board removed' }
    if r and r.ok and BOARD[action] then
        local b = Boards.Get(r.id or data.boardId)
        Webhook.Send('courtrooms', ('%s: %s'):format(BOARD[action], (b and b.label) or data.label or ''), nil, {
            { 'Admin', ('%s (%s)'):format(GetPlayerName(src) or '?', Bridge.GetName(src) or '?') },
        }, action == 'boardRemove' and 'red' or 'blue')
    end
    local COURT = { courtCreate = 'Court created', courtUpdate = 'Court edited', courtDelete = 'Court deleted',
        courtDeskAdd = 'Custody desk placed', courtDeskRemove = 'Custody desk removed' }
    if r and r.ok and COURT[action] then
        local now = U.court(r.id or data.courtId)
        Webhook.Send('courtrooms', ('%s: %s'):format(COURT[action], (now and now.label) or beforeCourtLabel or data.label or ''), nil, {
            { 'Was', action == 'courtUpdate' and beforeCourtLabel ~= (now and now.label) and beforeCourtLabel or nil },
            { 'Type', now and Courts.Kinds[now.kind] }, { 'Waypoint', data.here and 'Set to the admin\'s position' or nil },
            { 'Admin', ('%s (%s)'):format(GetPlayerName(src) or '?', Bridge.GetName(src) or '?') },
        }, (action == 'courtDelete' or action == 'courtDeskRemove') and 'red' or 'blue')
    end
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

--- A link someone pasted: see server/videolinks.lua for the sites that work.
function Rooms.ParseVideo(url) return VideoLinks.Parse(url) end

local function broadcast() TriggerClientEvent('vinewood-moj:client:screens', -1, playing) end

lib.callback.register('vinewood-moj:server:screens', function() return playing end)

function Rooms.NowShowing(roomId) return playing[roomId] end

function Rooms.Play(roomId, url, label, by, ref)
    local v, err = Rooms.ParseVideo(url)
    if not v then return nil, err end
    v, err = VideoLinks.Resolve(v)
    if not v then return nil, err end
    playing[roomId] = {
        kind = v.kind, src = v.src, provider = v.provider, providerLabel = v.providerLabel, offset = v.offset or 0, control = v.control,
        fallback = v.fallback, fallbackEmbed = v.fallbackEmbed,
        url = url, label = U.trim(label, 80) or 'Exhibit', by = by, ref = ref, startedAt = os.time(),
    }
    broadcast()
    return playing[roomId]
end

--- An interview: every speaker's audio and the CCTV video, kept in step on the screens.
function Rooms.PlayInterview(roomId, session, by, ref)
    local started = session.startedAt or 0
    if started > 1e11 then started = math.floor(started / 1000) end -- stored in ms by some versions
    playing[roomId] = {
        kind = 'interview', src = 'interview:' .. session.id, provider = 'interview', providerLabel = 'Interview recording',
        label = ('Interview: %s'):format(session.interviewee or 'unknown'), by = by, ref = ref, startedAt = os.time(), offset = 0,
        tracks = session.tracks, total = session.total,
        meta = { interviewee = session.interviewee, officer = session.officer, solicitor = session.solicitor, room = session.room,
            caseRef = session.caseRef, when = started > 0 and os.date('%d/%m/%Y %H:%M', started) or nil },
    }
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


---------------------------------------------------------------------------
-- Courtroom PA: who is live at a microphone in each room. Clients in the room play those people
-- through the speakers (a volume override, like pma-voice radio), so distance doesn't fade them.
---------------------------------------------------------------------------
local live = {}   -- [roomId] = { [src] = true }

local function liveList()
    local out = {}
    for roomId, set in pairs(live) do
        local srcs = {}
        for src in pairs(set) do srcs[#srcs + 1] = src end
        if #srcs > 0 then out[#out + 1] = { room = roomId, srcs = srcs } end
    end
    return out
end

local function sendLive() TriggerClientEvent('vinewood-moj:client:liveMics', -1, liveList()) end

local function dropLive(src)
    local changed = false
    for _, set in pairs(live) do
        if set[src] then set[src] = nil changed = true end
    end
    return changed
end

RegisterNetEvent('vinewood-moj:server:mic', function(roomId, on)
    local src = source
    local changed = dropLive(src)
    local r = on and Rooms.Get(roomId)
    if r and Zones.Contains(r, GetEntityCoords(GetPlayerPed(src)), 3.0) then
        live[r.id] = live[r.id] or {}
        live[r.id][src] = true
        changed = true
    end
    if changed then sendLive() end
end)

lib.callback.register('vinewood-moj:server:liveMics', function() return liveList() end)

AddEventHandler('playerDropped', function()
    if dropLive(source) then sendLive() end
end)


--- Turn a courtroom's speakers up or down (0 = muted, 1 = normal, up to 1.5). Everyone in the room hears it straight away.
function Rooms.SetVolume(roomId, v)
    local r = Rooms.Get(roomId)
    if not r then return false end
    r.pa_volume = math.max(0.0, math.min(1.5, tonumber(v) or 1.0))
    MySQL.update.await('UPDATE vw_moj_courtrooms SET pa_volume = ? WHERE id = ?', { r.pa_volume, r.id })
    Rooms.Broadcast()
    return true
end
