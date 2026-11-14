--[[
    tr_core's own interaction: what TR.target uses when the server runs no other target script (or picks
    it: target = 'tr_core' in config.lua). It runs once, here in tr_core; every resource reaches it
    through bridge/target/tr_core with the same ox_target-format options.

    Walk up to something and look at it. What a script put in the world (its props, peds and zones) shows
    a small dot from a few metres away; within reach the dot becomes the key, with the option next to it.
    More than one option: scroll for the next. The key is E, rebindable in the game's key bindings.
    Things that are everywhere (every ATM) show no dot, only the option once you're at one.

    The option panel is a page (web/interact) the game draws into a texture; it goes on the screen at the
    thing with SetDrawOrigin, so it stays on it as the camera moves. The dots are a small texture drawn
    the same way, under the panel: a dot where the panel goes fades out. Nothing runs while nothing with
    options is near.

    What it costs doesn't grow with how much has options (a warehouse can hold thousands of miners): a
    script's props are measured once when they get options and kept in a grid by where they are, so a
    look only works through those near the player. Only what is about to be shown is read from the game
    on every look; a few others are checked again each time, for any that moved or went without saying.
]]

local RESOURCE = GetCurrentResourceName()
local COMMAND = 'tr_interact'

local DEFAULT_DISTANCE = 2.0 -- an option's reach when it doesn't give one (m)
local HINT = 2.5 -- how far past its reach a dot shows (m)
local MAX_DOTS = 8
local SCAN_MS = 120 -- a close look, while something with options is near
local QUIET_MS = 250 -- the next look while nothing is
local NEAR_MS = 1000 -- things found by their model, every car or ped, networked entities, zones: found this often
local ASK_MS = 1000 -- whether a thing only near enough for a dot has an option for the player: asked this often
local SIGHT_MS = 500 -- whether the map hides a dot: looked again this often
local SWITCH = 0.03 -- how much nearer the middle of the screen another target must be to take over
local CELL = 2.0 -- placed things are kept in a grid of squares this big (m)
local SWEEP_PER_S = 50 -- placed things checked again per second at most, for any that moved or went without saying
local SWEEP_ROUND_MS = 2000 -- and none more often than once in this long
local HOT_MS = 10000 -- something seen moving is checked every second for this long
local MARGIN = 5.0 -- things that aren't kept in the grid are found this much further out than their reach (m)
local SEARCH_MAX = 20.0 -- the furthest out a look searches (m)

-- The page's canvas (css px) and where on it the key sits; it renders at SCALE times that for sharpness.
local CANVAS = { w = 400, h = 512, ax = 40, ay = 256 }
local SCALE = 2
local DOT_PX = 12 -- the dot texture (32 px: a 20 px disc in a halo) on the screen
local UNDER_PX = 12 -- a dot whose middle is this near the panel (px) fades out under it
local PANEL_WAIT = 150 -- ms to wait for the page to paint new options before drawing it anyway
local LEAVE_MS = 160 -- the panel's closing animation

local PED_CHEST = 24818 -- SKEL_Spine3

local Interact = {}

-- What's registered ------------------------------------------------------------------------------------

local zones = {} ---@type table<integer, table>
local models = {} ---@type table<integer, table[]> model hash -> options
local locals = {} ---@type table<integer, table[]> entity -> options
local networked = {} ---@type table<integer, table[]> network id -> options
local globals = { ped = {}, vehicle = {}, object = {}, player = {} } ---@type table<string, table[]>
local nextZone = 0
local dirty = true
local version = 0 -- bumped when options other than an entity's own change: what each thing has is worked out again
local reachMax = DEFAULT_DISTANCE -- the furthest reach of any option
local layout = 0 -- bumped when what's near may have changed (something measured, added, gone): looked through again

local function signed(hash)
    if type(hash) == 'string' then hash = joaat(hash) end
    hash = math.tointeger(hash) or 0
    hash = hash & 0xFFFFFFFF
    if hash > 0x7FFFFFFF then hash = hash - 0x100000000 end
    return hash
end

local function invoker() return GetInvokingResource() or RESOURCE end

local function list(value)
    if value == nil then return {} end
    if type(value) ~= 'table' then return { value } end
    return value
end

local function nameSet(names)
    if names == nil then return nil end
    local set = {}
    for _, n in ipairs(list(names)) do set[n] = true end
    return set
end

---Options as given (one option or a list), each marked with the resource that added it.
local function own(options, resource)
    if type(options) ~= 'table' then error('options must be a table', 3) end
    if options.label then options = { options } end
    local out = {}
    for _, o in ipairs(options) do
        if type(o) == 'table' and o.label ~= nil then
            o.resource = resource
            o.label = tostring(o.label)
            o.distance = tonumber(o.distance) or DEFAULT_DISTANCE
            if type(o.bones) == 'string' then o.bones = { o.bones } end
            if o.distance > reachMax then reachMax = o.distance end
            out[#out + 1] = o
        end
    end
    return out
end

---Adds options to a target's list. An option with the same name from the same resource is replaced.
local function addTo(target, options)
    for _, o in ipairs(options) do
        if o.name then
            for i = #target, 1, -1 do
                if target[i].name == o.name and target[i].resource == o.resource then table.remove(target, i) end
            end
        end
        target[#target + 1] = o
    end
end

---Removes a resource's options from a target's list: those with the names, or all of them.
local function removeFrom(target, names, resource)
    for i = #target, 1, -1 do
        local o = target[i]
        if (resource == nil or o.resource == resource) and (names == nil or names[o.name]) then table.remove(target, i) end
    end
end

local function changed()
    dirty = true
    version = version + 1
    layout = layout + 1
end

-- Zones

local function vec(v) return TR.utils.toVector3(v) end

local function addZone(shape, data)
    if type(data) ~= 'table' then error('zone data must be a table', 3) end
    local resource = invoker()
    nextZone = nextZone + 1
    local zone = { id = nextZone, resource = resource, shape = shape, options = own(data.options or {}, resource) }

    if shape == 'sphere' then
        zone.center = vec(data.coords)
        zone.radius = tonumber(data.radius) or 2.0
    elseif shape == 'box' then
        zone.center = vec(data.coords)
        zone.size = vec(data.size or vec3(2, 2, 2))
        local r = math.rad(tonumber(data.rotation) or 0.0)
        zone.cos, zone.sin = math.cos(r), math.sin(r)
    else
        local points = {}
        local sx, sy, sz = 0.0, 0.0, 0.0
        for i, p in ipairs(data.points or {}) do
            p = vec(p)
            points[i] = p
            sx, sy, sz = sx + p.x, sy + p.y, sz + p.z
        end
        if #points < 3 then error('a poly zone needs three points or more', 3) end
        local n = #points
        zone.points = points
        zone.center = vec3(sx / n, sy / n, sz / n)
        zone.thickness = tonumber(data.thickness) or 4.0
    end

    zones[zone.id] = zone
    changed()
    return zone.id
end

-- The point of a zone nearest `pos`, and how far it is.

local function sphereNearest(zone, pos)
    local d = pos - zone.center
    local len = #d
    if len <= zone.radius then return pos, 0.0 end
    local p = zone.center + d * (zone.radius / len)
    return p, len - zone.radius
end

local function clamp(v, lo, hi) return v < lo and lo or (v > hi and hi or v) end

local function boxNearest(zone, pos)
    local c, s = zone.center, zone.size
    local dx, dy = pos.x - c.x, pos.y - c.y
    -- into the box's own axes (rotated by -rotation), clamped, and back
    local lx = dx * zone.cos + dy * zone.sin
    local ly = -dx * zone.sin + dy * zone.cos
    local nx, ny = clamp(lx, -s.x / 2, s.x / 2), clamp(ly, -s.y / 2, s.y / 2)
    local nz = clamp(pos.z, c.z - s.z / 2, c.z + s.z / 2)
    local p = vec3(c.x + nx * zone.cos - ny * zone.sin, c.y + nx * zone.sin + ny * zone.cos, nz)
    return p, #(pos - p)
end

local function inPolygon(points, x, y)
    local inside, j = false, #points
    for i = 1, #points do
        local a, b = points[i], points[j]
        if (a.y > y) ~= (b.y > y) and x < (b.x - a.x) * (y - a.y) / (b.y - a.y) + a.x then inside = not inside end
        j = i
    end
    return inside
end

local function polyNearest(zone, pos)
    local half = zone.thickness / 2
    local z = clamp(pos.z, zone.center.z - half, zone.center.z + half)
    if inPolygon(zone.points, pos.x, pos.y) then
        local p = vec3(pos.x, pos.y, z)
        return p, #(pos - p)
    end
    local best, bx, by = math.huge, pos.x, pos.y
    local pts, j = zone.points, #zone.points
    for i = 1, #pts do
        local a, b = pts[j], pts[i]
        local ex, ey = b.x - a.x, b.y - a.y
        local len2 = ex * ex + ey * ey
        local t = len2 > 0 and clamp(((pos.x - a.x) * ex + (pos.y - a.y) * ey) / len2, 0, 1) or 0
        local px, py = a.x + ex * t, a.y + ey * t
        local d2 = (pos.x - px) ^ 2 + (pos.y - py) ^ 2
        if d2 < best then best, bx, by = d2, px, py end
        j = i
    end
    local p = vec3(bx, by, z)
    return p, #(pos - p)
end

local NEAREST = { sphere = sphereNearest, box = boxNearest, poly = polyNearest }

function Interact.zoneDistance(zone, pos)
    local _, d = NEAREST[zone.shape](zone, pos)
    return d
end

-- Where placed things are --------------------------------------------------------------------------------
-- Each entity a script gave options (addLocalEntity) is measured when it gets them: where it is, which way
-- it faces, its box. It's kept in the grid square its middle is in, and read from the game again only when
-- it's about to be shown, when the sweep comes to it (a few each look), or every second while it's moving.

local dims = {} ---@type table<integer, vector3[]>

local function boxOf(model)
    local d = dims[model]
    if not d then
        local mn, mx = GetModelDimensions(model)
        d = { mn, mx }
        dims[model] = d
    end
    return d[1], d[2]
end

local TYPES = { [1] = 'ped', [2] = 'vehicle', [3] = 'object' }

local tracked = {} ---@type table<integer, table> entity -> what's known of it
local cells = {} ---@type table<integer, table<table, true>>
local sweepList, sweepAt = {}, 1 ---@type table[], integer
local hot = {} ---@type table<table, number|true> moving (until when; peds and cars always), or not there yet
local sweptAt = 0
-- A look searches the grid out to its largest box and furthest reach. A thing bigger than WIDE m round, or
-- with a longer reach, would stretch that search for all: it's kept apart and looked at every time instead.
local WIDE = 4.0
local gridRadius, gridReach = 1.0, DEFAULT_DISTANCE
local wide = {} ---@type table<table, true>

local function cellOf(x, y) return (math.floor(x / CELL) + 32768) * 65536 + math.floor(y / CELL) + 32768 end

local function regrid(rec, keep)
    wide[rec] = nil
    if rec.cell then
        local cell = cells[rec.cell]
        if cell then
            cell[rec] = nil
            if next(cell) == nil then cells[rec.cell] = nil end
        end
        rec.cell = nil
    end
    if keep and rec.centre then
        local reach = rec.ownReach or 0
        if rec.radius > WIDE or reach > WIDE then
            wide[rec] = true
            return
        end
        if rec.radius > gridRadius then gridRadius = rec.radius end
        if reach > gridReach then gridReach = reach end
        local k = cellOf(rec.centre.x, rec.centre.y)
        local cell = cells[k]
        if not cell then
            cell = {}
            cells[k] = cell
        end
        cell[rec] = true
        rec.cell = k
    end
end

---Reads where an entity is, which way it faces and how big it is.
local function measure(rec, pos)
    local entity = rec.entity
    layout = layout + 1
    rec.pos, rec.fwd = pos, GetEntityForwardVector(entity)
    if rec.kind == 'ped' then
        rec.centre, rec.radius = pos, 0.5
        rec.cx, rec.cy, rec.cz = pos.x, pos.y, pos.z
        return
    end
    local mn, mx = boxOf(rec.model)
    rec.right = GetOffsetFromEntityInWorldCoords(entity, 1.0, 0.0, 0.0) - pos
    rec.up = GetOffsetFromEntityInWorldCoords(entity, 0.0, 0.0, 1.0) - pos
    rec.mn, rec.mx = mn, mx
    local c = (mn + mx) / 2
    rec.centre = pos + rec.right * c.x + rec.fwd * c.y + rec.up * c.z
    rec.radius = #(mx - mn) / 2
    rec.cx, rec.cy, rec.cz = rec.centre.x, rec.centre.y, rec.centre.z
end

---What kind of thing an entity is, its model, and where it is.
local function identify(rec, now)
    local entity = rec.entity
    rec.kind = TYPES[GetEntityType(entity)] or 'object'
    rec.model = signed(GetEntityModel(entity))
    rec.checkedAt = now
    measure(rec, GetEntityCoords(entity))
    if rec.tracked then
        regrid(rec, true)
        -- peds and cars move by themselves: looked at every second
        if rec.kind ~= 'object' then hot[rec] = math.huge end
    end
end

---Starts keeping track of an entity that got options.
local function track(entity)
    if tracked[entity] then return end
    local rec = { entity = entity, key = 'e' .. entity, tracked = true, version = -1 }
    tracked[entity] = rec
    sweepList[#sweepList + 1] = rec
    rec.slot = #sweepList
    if DoesEntityExist(entity) then
        identify(rec, GetGameTimer())
    else
        hot[rec] = true -- looked at again within a second; gone then if it still isn't there
    end
end

local function untrack(entity)
    local rec = tracked[entity]
    if not rec then return end
    tracked[entity] = nil
    layout = layout + 1
    regrid(rec, false)
    hot[rec] = nil
    local last = sweepList[#sweepList]
    sweepList[rec.slot] = last
    last.slot = rec.slot
    sweepList[#sweepList] = nil
    rec.gone = true
end

---Whether a thing is still there; read again when it moved (and then checked every second for a while).
---`full` also notices a turn on the spot and a deleted entity's handle given to another model.
local function check(rec, now, full)
    local entity = rec.entity
    if not DoesEntityExist(entity) then return false end
    if not rec.kind then
        identify(rec, now)
        return true
    end
    if full and signed(GetEntityModel(entity)) ~= rec.model then return false end
    rec.checkedAt = now
    local pos = GetEntityCoords(entity)
    local moved = #(pos - rec.pos) > 0.02
    if not moved and full then
        local f, was = GetEntityForwardVector(entity), rec.fwd
        moved = f.x * was.x + f.y * was.y + f.z * was.z < 0.9998
    end
    if moved then
        measure(rec, pos)
        rec.movedAt = now
        if rec.tracked then
            regrid(rec, true)
            if hot[rec] ~= math.huge then hot[rec] = now + HOT_MS end
        end
    end
    return true
end

---A thing that went without its options being removed: they go too (its handle may be given out again).
local function forget(rec)
    rec.gone = true
    if rec.tracked then
        locals[rec.entity] = nil
        untrack(rec.entity)
    end
end

---A few tracked things looked at again, round the list (every fourth time round, closely).
local function sweep(now)
    local n = #sweepList
    local dt = math.min(now - sweptAt, 1000)
    sweptAt = now
    local budget = math.min(n, math.ceil(SWEEP_PER_S * dt / 1000), math.ceil(n * dt / SWEEP_ROUND_MS))
    for _ = 1, budget do
        if sweepAt > #sweepList then sweepAt = 1 end
        local rec = sweepList[sweepAt]
        sweepAt = sweepAt + 1
        if rec then
            rec.sweeps = (rec.sweeps or 0) + 1
            if not check(rec, now, rec.sweeps % 4 == 0) then forget(rec) end
        end
    end
end

-- The exports bridge/target/tr_core calls (the same names as ox_target's) --------------------------------

exports('addBoxZone', function(data) return addZone('box', data) end)
exports('addSphereZone', function(data) return addZone('sphere', data) end)
exports('addPolyZone', function(data) return addZone('poly', data) end)

exports('removeZone', function(id)
    local zone = zones[id]
    if zone then
        zones[id] = nil
        changed()
    end
end)

---An entity's own options changed: only it works out what it has again.
local function localChanged(entity)
    layout = layout + 1
    local own = locals[entity]
    if not own then return untrack(entity) end
    track(entity)
    local rec = tracked[entity]
    rec.version = -1
    local reach = 0
    for _, o in ipairs(own) do
        if o.distance > reach then reach = o.distance end
    end
    if reach ~= rec.ownReach then
        rec.ownReach = reach
        if rec.centre then regrid(rec, true) end
    end
end

---Options that may apply to tracked things too (by their model, or for all of their kind): the grid's
---search goes as far as they reach (up to WIDE).
local function stretch(options)
    for _, o in ipairs(options) do
        gridReach = math.max(gridReach, math.min(o.distance, WIDE))
    end
end

local function addKeyed(store, keys, options, key)
    local resource = invoker()
    for _, k in ipairs(list(keys)) do
        k = key(k)
        store[k] = store[k] or {}
        local owned = own(options, resource)
        addTo(store[k], owned)
        if store == models then stretch(owned) end
        if store == locals then localChanged(k) end
    end
    if store ~= locals then changed() end
end

local function removeKeyed(store, keys, names, key)
    local resource, set = invoker(), nameSet(names)
    for _, k in ipairs(list(keys)) do
        k = key(k)
        local target = store[k]
        if target then
            removeFrom(target, set, resource)
            if #target == 0 then store[k] = nil end
            if store == locals then localChanged(k) end
        end
    end
    if store ~= locals then changed() end
end

local function same(v) return v end

exports('addModel', function(m, options) addKeyed(models, m, options, signed) end)
exports('removeModel', function(m, names) removeKeyed(models, m, names, signed) end)
exports('addEntity', function(netIds, options) addKeyed(networked, netIds, options, same) end)
exports('removeEntity', function(netIds, names) removeKeyed(networked, netIds, names, same) end)
exports('addLocalEntity', function(entities, options) addKeyed(locals, entities, options, same) end)
exports('removeLocalEntity', function(entities, names) removeKeyed(locals, entities, names, same) end)

for kind, name in pairs({ ped = 'Ped', vehicle = 'Vehicle', object = 'Object', player = 'Player' }) do
    exports('addGlobal' .. name, function(options)
        local owned = own(options, invoker())
        addTo(globals[kind], owned)
        stretch(owned)
        changed()
    end)
    exports('removeGlobal' .. name, function(names)
        removeFrom(globals[kind], nameSet(names) or {}, invoker())
        changed()
    end)
end

-- A resource that stops takes its options with it.
AddEventHandler('onClientResourceStop', function(resource)
    if resource == RESOURCE then return end
    for id, zone in pairs(zones) do
        if zone.resource == resource then zones[id] = nil end
    end
    for _, store in ipairs({ models, networked }) do
        for k, target in pairs(store) do
            removeFrom(target, nil, resource)
            if #target == 0 then store[k] = nil end
        end
    end
    local touched = {}
    for entity, target in pairs(locals) do
        local before = #target
        removeFrom(target, nil, resource)
        if #target == 0 then locals[entity] = nil end
        if #target ~= before then touched[#touched + 1] = entity end
    end
    for _, entity in ipairs(touched) do localChanged(entity) end
    for _, target in pairs(globals) do removeFrom(target, nil, resource) end
    Interact.huds[resource] = nil
    changed()
end)

-- When the player can't use it ----------------------------------------------------------------------------

-- Resources showing a TR.ui.hud: an activity is going on (its controls are in the hint bar), and the
-- interaction's key would clash with them.
Interact.huds = {} ---@type table<string, true>
AddEventHandler('tr:hud', function(resource, shown)
    if type(resource) ~= 'string' then return end
    Interact.huds[resource] = shown and true or nil
end)

function Interact.blocked(ped)
    return IsNuiFocused() or IsPauseMenuActive() or IsPedInAnyVehicle(ped, true) or IsPedDeadOrDying(ped, true)
        or IsPedRagdoll(ped) or IsPedFalling(ped) or IsPedCuffed(ped) or IsPlayerFreeAiming(PlayerId())
        or GetRenderingCam() ~= -1 or next(Interact.huds) ~= nil
end

-- Asking an option ----------------------------------------------------------------------------------------

local warned = {}

local function failed(o, what, err)
    local id = ('%s:%s:%s'):format(o.resource, o.name or o.label, what)
    if warned[id] then return end
    warned[id] = true
    TR.log.error('%s option "%s" (%s): %s', o.resource, o.name or o.label, what, tostring(err))
end

local function hasItems(items, any)
    if type(items) == 'string' then return TR.inventory.hasItem(items, 1) end
    if type(items) ~= 'table' then return true end
    if items[1] then
        for _, name in ipairs(items) do
            local has = TR.inventory.hasItem(name, 1)
            if any and has then return true end
            if not any and not has then return false end
        end
        return not any
    end
    for name, count in pairs(items) do
        local has = TR.inventory.hasItem(name, tonumber(count) or 1)
        if any and has then return true end
        if not any and not has then return false end
    end
    return not any
end

local function hasGroups(groups)
    if TR.player.hasJob(groups) then return true end
    local ok, gang = pcall(TR.player.hasGang, groups)
    return ok and gang == true
end

---Whether an option may show: its groups, items and canInteract.
function Interact.allowed(o, entity, distance, coords, bone)
    if o.groups and not hasGroups(o.groups) then return false end
    if o.items then
        local ok, has = pcall(hasItems, o.items, o.anyItem)
        if not ok then failed(o, 'items', has) end
        if not ok or not has then return false end
    end
    if o.canInteract then
        local ok, yes = pcall(o.canInteract, entity, distance, coords, o.name, bone)
        if not ok then
            failed(o, 'canInteract', yes)
            return false
        end
        return yes and true or false
    end
    return true
end

-- What's near ---------------------------------------------------------------------------------------------

-- Found again every second (they aren't kept in the grid): things by their model, every car or ped with
-- options for all of them, networked entities, and the zones.
local transient = {} ---@type table[]
local netOf = {} ---@type table<integer, integer> entity -> its network id, for those with options
local nearZones = {} ---@type table[]
local nearAt = -math.huge
-- What a thing only near enough for a dot said last (asked again after ASK_MS), and whether the map hid it.
local asked = {} ---@type table<string, { at: integer, shown: boolean }>
local sights = {} ---@type table<string, { at: integer, seen: boolean }>

local POOLS = { { 'CObject', 'object' }, { 'CPed', 'ped' }, { 'CVehicle', 'vehicle' } }

local function found(entity, kind, now)
    local rec = { entity = entity, key = 'e' .. entity, kind = kind, model = signed(GetEntityModel(entity)), version = -1, checkedAt = now }
    measure(rec, GetEntityCoords(entity))
    return rec
end

---What isn't kept in the grid, within reach soon: refreshed every second, or at once after options change.
function Interact.refresh(pos, ped, now)
    local range = math.min(reachMax + HINT + MARGIN, SEARCH_MAX)
    local list, seen, nets = {}, {}, {}

    local netChanged = false
    for netId in pairs(networked) do
        if NetworkDoesEntityExistWithNetworkId(netId) then
            local entity = NetworkGetEntityFromNetworkId(netId)
            nets[entity] = netId
            if netOf[entity] ~= netId then netChanged = true end
            if not tracked[entity] and not seen[entity] and #(GetEntityCoords(entity) - pos) <= range then
                seen[entity] = true
                list[#list + 1] = found(entity, TYPES[GetEntityType(entity)] or 'object', now)
            end
        end
    end
    for entity in pairs(netOf) do
        if not nets[entity] then netChanged = true end
    end
    netOf = nets
    if netChanged then version = version + 1 end

    for model in pairs(models) do
        local entity = GetClosestObjectOfType(pos.x, pos.y, pos.z, range, model, false, false, false)
        if entity ~= 0 and not tracked[entity] and not seen[entity] then
            seen[entity] = true
            list[#list + 1] = found(entity, 'object', now)
        end
    end

    for _, pool in ipairs(POOLS) do
        local kind = pool[2]
        if #globals[kind] > 0 or (kind == 'ped' and #globals.player > 0) then
            for _, entity in ipairs(GetGamePool(pool[1])) do
                if entity ~= ped and not tracked[entity] and not seen[entity] and #(GetEntityCoords(entity) - pos) <= range then
                    seen[entity] = true
                    local rec = found(entity, kind, now)
                    rec.player = kind == 'ped' and IsPedAPlayer(entity) or nil
                    list[#list + 1] = rec
                end
            end
        end
    end
    transient = list
    layout = layout + 1

    -- Moving, or not there yet: looked at every second.
    for rec, untilAt in pairs(hot) do
        if untilAt ~= true and now > untilAt then
            hot[rec] = nil
        elseif not check(rec, now, true) then
            forget(rec)
        elseif untilAt == true then
            hot[rec] = nil -- it's there now
        end
    end

    nearZones = {}
    for _, zone in pairs(zones) do
        if #zone.options > 0 and Interact.zoneDistance(zone, pos) <= range then nearZones[#nearZones + 1] = zone end
    end

    for _, cache in ipairs({ asked, sights }) do
        for key, last in pairs(cache) do
            if now - last.at > 5000 then cache[key] = nil end
        end
    end

    dirty = false
end

---The options that apply to a thing (its own, by its network id, by its model, for all of its kind), split
---into those on the whole of it and those on its bones; the furthest reach; and whether it gets a dot
---(only what a script put there on purpose does). Worked out again only when they change.
local function optionsOf(rec)
    if rec.version == version then return end
    rec.version = version
    local plain, bones, reach, placed = {}, nil, 0, false
    local function take(target, own)
        if not target or #target == 0 then return end
        if own then placed = true end
        for _, o in ipairs(target) do
            if o.bones then
                bones = bones or {}
                for _, bone in ipairs(o.bones) do
                    bones[bone] = bones[bone] or { options = {}, reach = 0 }
                    local b = bones[bone]
                    b.options[#b.options + 1] = o
                    if o.distance > b.reach then b.reach = o.distance end
                end
            else
                plain[#plain + 1] = o
                if o.distance > reach then reach = o.distance end
            end
        end
    end
    take(locals[rec.entity], true)
    local net = netOf[rec.entity]
    take(net and networked[net], true)
    take(models[rec.model], false)
    take(globals[rec.player and 'player' or rec.kind], false)
    local all = reach
    for _, b in pairs(bones or {}) do all = math.max(all, b.reach) end
    rec.plain, rec.bones, rec.reach, rec.reachAll, rec.placed = plain, bones, reach, all, placed
    rec.cand, rec.boneCands = nil, nil
end

---How far `pos` is from a thing (to the nearest point of its box), and `pos` in the thing's own axes.
local function distanceTo(rec, pos)
    local v = pos - rec.pos
    if rec.kind == 'ped' then return #v end
    local r, f, u, mn, mx = rec.right, rec.fwd, rec.up, rec.mn, rec.mx
    local lx = v.x * r.x + v.y * r.y + v.z * r.z
    local ly = v.x * f.x + v.y * f.y + v.z * f.z
    local lz = v.x * u.x + v.y * u.y + v.z * u.z
    local dx, dy, dz = lx - clamp(lx, mn.x, mx.x), ly - clamp(ly, mn.y, mx.y), lz - clamp(lz, mn.z, mx.z)
    return math.sqrt(dx * dx + dy * dy + dz * dz), lx, ly, lz
end

---The middle of the side of a thing's box that faces a point at (lx, ly) in its own axes.
local function faceOf(rec, lx, ly)
    local mn, mx = rec.mn, rec.mx
    local cx, cy, cz = (mn.x + mx.x) / 2, (mn.y + mx.y) / 2, (mn.z + mx.z) / 2
    local hx, hy = math.max((mx.x - mn.x) / 2, 0.01), math.max((mx.y - mn.y) / 2, 0.01)
    local rx, ry = (lx - cx) / hx, (ly - cy) / hy
    local fx, fy = cx, cy
    if math.abs(rx) > math.abs(ry) then fx = cx + (rx > 0 and hx or -hx) else fy = cy + (ry > 0 and hy or -hy) end
    return rec.pos + rec.right * fx + rec.fwd * fy + rec.up * cz
end

---The point of an entity's box nearest `pos`, and the middle of the side of it that faces `pos`.
function Interact.entityPoints(entity, pos)
    local rec = tracked[entity]
    if not rec then
        rec = { entity = entity }
        identify(rec, GetGameTimer())
    end
    local _, lx, ly, lz = distanceTo(rec, pos)
    local mn, mx = rec.mn, rec.mx
    local near = rec.pos + rec.right * clamp(lx, mn.x, mx.x) + rec.fwd * clamp(ly, mn.y, mx.y) + rec.up * clamp(lz, mn.z, mx.z)
    return near, faceOf(rec, lx, ly)
end

---Where on a thing its dot and panel sit: a function, as some move (a ped's chest, a car's door handle).
local function anchorOf(c)
    local entity = c.entity
    if c.boneIndex then
        local index = c.boneIndex
        return function()
            if DoesEntityExist(entity) then return GetWorldPositionOfEntityBone(entity, index) end
        end
    elseif c.rec and c.rec.kind == 'ped' then
        return function()
            if DoesEntityExist(entity) then return GetPedBoneCoords(entity, PED_CHEST, 0.0, 0.0, 0.0) end
        end
    end
    local point = c.point
    return function() return point end
end

local boneIndexes = {} ---@type table<integer, table<string, integer>> model -> bone name -> index

---A thing near `pos` as a candidate: one for the whole of it (plus one per bone with options), with how far
---it is and the furthest reach of its options. Kept on the thing between looks, so nothing new is made. How
---far is rough (to the ball round its box) unless it may be in reach; dots measure it properly when shown.
local function consider(rec, pos, out, search)
    if rec.version ~= version then optionsOf(rec) end
    local dx, dy, dz = rec.cx - pos.x, rec.cy - pos.y, rec.cz - pos.z
    local all = rec.reachAll
    local d2, far = dx * dx + dy * dy + dz * dz, rec.radius + math.max(all, math.min(search, all + HINT))
    if d2 > far * far then return end
    local rough = math.sqrt(d2) - rec.radius
    -- in reach, or near enough for a dot (as far as this look searches for dots)
    if rec.reach > 0 and (rough <= rec.reach or (rough <= rec.reach + HINT and rough <= search)) then
        local c = rec.cand
        if not c then
            c = { key = rec.key, rec = rec, entity = rec.entity, options = rec.plain, reachMax = rec.reach, placed = rec.placed }
            rec.cand = c
        end
        if rough <= rec.reach or rec.kind == 'ped' then
            c.distance, c.lx, c.ly = distanceTo(rec, pos)
            c.precise = true
        else
            c.distance, c.precise = rough, false
        end
        out[#out + 1] = c
    end
    if rec.bones and rough <= math.max(search, all) then
        rec.boneCands = rec.boneCands or {}
        local indexes = boneIndexes[rec.model]
        if not indexes then
            indexes = {}
            boneIndexes[rec.model] = indexes
        end
        for bone, b in pairs(rec.bones) do
            local index = indexes[bone]
            if not index then
                index = GetEntityBoneIndexByName(rec.entity, bone)
                indexes[bone] = index
            end
            if index ~= -1 then
                local at = GetWorldPositionOfEntityBone(rec.entity, index)
                local d = #(pos - at)
                if d <= b.reach + HINT then
                    local c = rec.boneCands[bone]
                    if not c then
                        c = { key = ('b%d:%s'):format(rec.entity, bone), rec = rec, entity = rec.entity, bone = bone,
                            boneIndex = index, options = b.options, reachMax = b.reach, placed = rec.placed, precise = true }
                        rec.boneCands[bone] = c
                    end
                    c.distance, c.point = d, at
                    out[#out + 1] = c
                end
            end
        end
    end
end

---The candidates near `pos`, out to `search` m: the tracked things in the grid squares round it, those the
---refresh found, and the zones.
local function candidates(pos, out, search)
    local r = math.min(math.max(gridReach, math.min(search, gridReach + HINT)) + gridRadius, SEARCH_MAX)
    local x0, x1 = math.floor((pos.x - r) / CELL), math.floor((pos.x + r) / CELL)
    local y0, y1 = math.floor((pos.y - r) / CELL) + 32768, math.floor((pos.y + r) / CELL) + 32768
    for cx = x0, x1 do
        local base = (cx + 32768) * 65536
        for cy = y0, y1 do
            local cell = cells[base + cy]
            if cell then
                for rec in pairs(cell) do consider(rec, pos, out, search) end
            end
        end
    end
    for rec in pairs(wide) do consider(rec, pos, out, search) end
    for _, rec in ipairs(transient) do
        if not rec.gone then consider(rec, pos, out, search) end
    end

    for _, zone in ipairs(nearZones) do
        if zones[zone.id] then
            local d = Interact.zoneDistance(zone, pos)
            local c = zone.cand
            if not c then
                local r = 0
                for _, o in ipairs(zone.options) do r = math.max(r, o.distance) end
                c = { key = 'z' .. zone.id, zone = zone.id, options = zone.options, placed = true, reachMax = r, point = zone.center, precise = true }
                zone.cand = c
            end
            if d <= c.reachMax + HINT then
                c.distance = d
                out[#out + 1] = c
            end
        end
    end
    return out
end

---Where a candidate's dot and panel sit now (for a whole thing: the middle of its side facing the player).
local function pointOf(c)
    local rec = c.rec
    if c.bone or not rec then return c.point end
    if rec.kind == 'ped' then return GetPedBoneCoords(c.entity, PED_CHEST, 0.0, 0.0, 0.0) end
    return faceOf(rec, c.lx, c.ly)
end

-- Looking at it -------------------------------------------------------------------------------------------

-- The camera, read once a look: where things are on the screen is worked out here, not asked for each.
local view = { cam = vec3(0, 0, 0), f = vec3(0, 1, 0), r = vec3(1, 0, 0), u = vec3(0, 0, 1), tanV = 1.0, tanH = 1.0 }

local function readView(aspect)
    local rot = GetFinalRenderedCamRot(2)
    local p, y = math.rad(rot.x), math.rad(rot.z)
    local cp = math.cos(p)
    local f = vec3(-math.sin(y) * cp, math.cos(y) * cp, math.sin(p))
    local r = vec3(math.cos(y), math.sin(y), 0.0)
    view.cam, view.f, view.r = GetFinalRenderedCamCoord(), f, r
    view.u = vec3(r.y * f.z - r.z * f.y, r.z * f.x - r.x * f.z, r.x * f.y - r.y * f.x)
    view.tanV = math.tan(math.rad(GetFinalRenderedCamFov()) / 2)
    view.tanH = view.tanV * aspect
end

---How far from the middle of the screen a point is (in screen heights), or nil when it's off the screen.
local function offCentre(point)
    local d = point - view.cam
    local f, r, u = view.f, view.r, view.u
    local depth = d.x * f.x + d.y * f.y + d.z * f.z
    if depth <= 0.05 then return nil end
    local x = (d.x * r.x + d.y * r.y + d.z * r.z) / depth
    local y = (d.x * u.x + d.y * u.y + d.z * u.z) / depth
    if math.abs(x) > view.tanH or math.abs(y) > view.tanV then return nil end
    return math.sqrt(x * x + y * y) / view.tanV * 0.5
end

---Whether the map hides `point` from the camera (props and cars don't count: ours aren't solid).
local function seen(point, entity)
    local cam = view.cam
    local dir = point - cam
    local len = #dir
    if len < 0.25 then return true end
    local stop = cam + dir * ((len - 0.1) / len)
    local ray = StartExpensiveSynchronousShapeTestLosProbe(cam.x, cam.y, cam.z, stop.x, stop.y, stop.z, 1, entity or 0, 7)
    local _, hit = GetShapeTestResult(ray)
    return not (hit == true or hit == 1)
end

---Reads a thing about to be shown from the game, once a look: false if it went, or moved out of range or
---off the screen (one that moved is measured again).
local function fresh(c, now, pos)
    if c.freshAt == now then return c.freshOk end
    c.freshAt = now
    local ok, rec = true, c.rec
    if rec then
        if rec.gone then
            ok = false
        elseif rec.checkedAt ~= now and not check(rec, now, false) then
            forget(rec)
            ok = false
        end
        if ok and rec.movedAt == now then
            if not c.bone then
                c.distance, c.lx, c.ly = distanceTo(rec, pos)
                c.precise = true
            end
            c.point = pointOf(c)
            c.off = c.point and offCentre(c.point)
            ok = c.off ~= nil and c.distance <= c.reachMax + HINT
            if c.score and c.off then c.score = c.off + c.distance * 0.02 end
        end
    end
    c.freshOk = ok
    return ok
end

---Whether a candidate is in sight: zones always are; asked again after `ttl` ms.
local function inSight(c, now, point, ttl)
    if c.zone then return true end
    local last = sights[c.key]
    if last and now - last.at < ttl then return last.seen end
    local yes = seen(point, c.entity)
    sights[c.key] = { at = now, seen = yes }
    return yes
end

---The options of a candidate that can be used now (in reach).
local function usable(c, point)
    local reach = {}
    for _, o in ipairs(c.options) do
        if c.distance <= o.distance and Interact.allowed(o, c.entity or 0, c.distance, point, c.bone) then reach[#reach + 1] = o end
    end
    return reach
end

---Whether a candidate near enough for a dot has an option for the player (what it said last, for a while).
local function shows(c, now, point)
    local last = asked[c.key]
    if last and now - last.at < ASK_MS then return last.shown end
    local yes = false
    for _, o in ipairs(c.options) do
        if c.distance <= o.distance + HINT and Interact.allowed(o, c.entity or 0, c.distance, point, c.bone) then
            yes = true
            break
        end
    end
    asked[c.key] = { at = now, shown = yes }
    return yes
end

-- The panel and the dots --------------------------------------------------------------------------------

local state = { focus = nil, dots = {} } ---@type { focus: table?, dots: table[] }
Interact.state = state
local screen = { w = 1920, h = 1080 }
-- Each dot (and the one in focus): where it is, how visible now, and what it fades to (set each look).
local fades = {} ---@type table<string, { anchor: function, alpha: number, dot: number, last: vector3? }>

local dui, txdName
local seq, painted, duiReady = 0, -1, false
local panel ---@type table? what the page shows: { key, seq, since, anchor, leaving?, untilAt? }
-- Where the panel is on the page (css px, which are screen px) with its first option at the key, from the
-- last paint.
local box ---@type { x: number, y: number, w: number, h: number, row: number }?
local lastShow ---@type table? the last show/update message, sent again if the page loads late

local function send(message)
    if message.action == 'show' or message.action == 'update' then lastShow = message end
    if message.action == 'hide' then lastShow = nil end
    if dui then SendDuiMessage(dui, json.encode(message)) end
end

local function ensureDui()
    if dui then return end
    txdName = ('tr_core_interact_%d'):format(GetGameTimer()) -- a name used before this start can't take textures
    local txd = CreateRuntimeTxd(txdName)
    CreateRuntimeTextureFromImage(txd, 'dot', 'web/interact/dot.png')
    dui = CreateDui(('https://cfx-nui-%s/web/interact/index.html?res=%s'):format(RESOURCE, RESOURCE), CANVAS.w * SCALE, CANVAS.h * SCALE)
    CreateRuntimeTextureFromDuiHandle(txd, 'panel', GetDuiHandle(dui))
end
Interact.ensureDui = ensureDui

RegisterNUICallback('interact:ready', function(_, cb)
    cb({})
    duiReady = true
    if lastShow then send(lastShow) end
end)

RegisterNUICallback('interact:painted', function(data, cb)
    cb({})
    local n = type(data) == 'table' and math.tointeger(tonumber(data.seq))
    if not n or n < painted then return end
    painted = n
    local b = type(data.box) == 'table' and data.box
    if b then
        local x, y, w, h, row = tonumber(b.x), tonumber(b.y), tonumber(b.w), tonumber(b.h), tonumber(b.row)
        if x and y and w and h and row then box = { x = x, y = y, w = w, h = h, row = row } end
    end
end)

---The key the player has on the interaction (they can bind another in the game's settings).
local function keyLabel()
    local button = GetControlInstructionalButton(0, (joaat(COMMAND) | 0x80000000) & 0xFFFFFFFF, true)
    if type(button) == 'string' and button:find('^t_.') then return button:sub(3) end
    return 'E'
end

local function labels(options)
    local out = {}
    for i, o in ipairs(options) do out[i] = o.label end
    return out
end

local function optionId(o) return ('%s|%s|%s'):format(o.resource, o.name or '', o.label) end

local function sameLabels(a, b)
    if #a ~= #b then return false end
    for i = 1, #a do if a[i] ~= b[i] then return false end end
    return true
end

---A new focus, the same one with other options, or none.
local function setFocus(c, reach)
    local f = state.focus
    if c and f and f.key == c.key then
        local picked = f.options[f.selected]
        local keep = picked and optionId(picked)
        local selected = 1
        for i, o in ipairs(reach) do
            if optionId(o) == keep then selected = i end
        end
        local was, before = labels(f.options), f.selected
        f.options, f.selected, f.anchor, f.distance, f.entity = reach, math.min(selected, #reach), c.anchor, c.distance, c.entity
        if panel and panel.key == c.key and not panel.leaving then panel.anchor = c.anchor end
        local now = labels(reach)
        if not sameLabels(was, now) or f.selected ~= before then
            -- the panel stays up while the page changes it (no fresh paint to wait for)
            seq = seq + 1
            send({ action = 'update', seq = seq, rows = now, selected = f.selected - 1 })
        end
        return
    end

    if f then
        -- the panel closes where it was
        if panel and not panel.leaving then
            panel.leaving, panel.untilAt = true, GetGameTimer() + LEAVE_MS
            if not c then send({ action = 'hide' }) end
        end
        state.focus = nil
    end
    if not c then return end

    ensureDui()
    seq = seq + 1
    state.focus = {
        key = c.key, entity = c.entity, zone = c.zone, bone = c.bone, anchor = c.anchor, distance = c.distance,
        options = reach, selected = 1,
    }
    panel = { key = c.key, seq = seq, since = GetGameTimer(), anchor = c.anchor }
    send({ action = 'show', seq = seq, key = keyLabel(), rows = labels(reach), selected = 0 })
end

-- The pass ------------------------------------------------------------------------------------------------

local function byScore(a, b) return a.score < b.score end
local function byDistance(a, b) return a.distance < b.distance end

---Whether a thing a script put there gets a dot: measured properly first, then on the screen, still there,
---not behind the map, and with something for the player.
local function dotted(c, now, pos)
    if not c.precise then
        c.distance, c.lx, c.ly = distanceTo(c.rec, pos)
        c.precise = true
        if c.distance > c.reachMax + HINT then return false end
    end
    if c.at ~= now then
        c.point = pointOf(c)
        c.off = c.point and offCentre(c.point)
        c.at = now
    end
    return c.off ~= nil and fresh(c, now, pos) and inSight(c, now, c.point, SIGHT_MS) and shows(c, now, c.point)
end

local lastNear, lastPos, lastLayout, lastSearch ---@type table[]?, vector3?, integer?, number?
-- How far out a look searches for dots: all the way to the edge of their range, or (when the last look found
-- all the dots it shows) a little past the furthest of them: nothing further could be one of the nearest.
-- What's in reach is always found.
local dotsWithin ---@type number?

---Where a point is on the screen (px), or nil when it's behind the camera.
local function toPixels(point)
    local d = point - view.cam
    local f, r, u = view.f, view.r, view.u
    local depth = d.x * f.x + d.y * f.y + d.z * f.z
    if depth <= 0.05 then return nil end
    local x = (d.x * r.x + d.y * r.y + d.z * r.z) / depth / view.tanH
    local y = (d.x * u.x + d.y * u.y + d.z * u.z) / depth / view.tanV
    return (1 + x) * 0.5 * screen.w, (1 - y) * 0.5 * screen.h
end

---Nothing in focus and no dots (those up fade out).
local function showNothing()
    setFocus(nil)
    state.dots = {}
    for _, fade in pairs(fades) do fade.dot = 0.0 end
end

---One close look: what is near, what's in reach, what the player looks at. Returns the ms to wait.
function Interact.scan(now)
    local ped = PlayerPedId()
    if Interact.blocked(ped) then
        showNothing()
        return QUIET_MS
    end

    local pos = GetEntityCoords(ped)
    if dirty or now - nearAt >= NEAR_MS then
        Interact.refresh(pos, ped, now)
        nearAt = now
        screen.w, screen.h = GetActiveScreenResolution()
        screen.aspect = GetAspectRatio(false)
    end
    sweep(now)

    -- Standing still with nothing changed: the same things are near, as far as they were.
    local search = math.min(dotsWithin or math.huge, reachMax + HINT)
    local near
    if lastNear and layout == lastLayout and search == lastSearch and #(pos - lastPos) < 0.03 then
        near = lastNear
    else
        near = candidates(pos, {}, search)
        lastNear, lastPos, lastLayout, lastSearch = near, pos, layout, search
    end
    if #near == 0 then
        showNothing()
        return QUIET_MS
    end
    ensureDui() -- the page loads before it's first needed (its texture is empty until then)
    readView(screen.aspect or 16 / 9)

    -- In reach: scored by how near the middle of the screen it is (and a little by how near). Further out,
    -- what a script put there may get a dot: sorted by how far into quarter-metre bins, nearest first.
    local reachable, bins = {}, {}
    for _, c in ipairs(near) do
        if c.distance <= c.reachMax then
            local point = pointOf(c)
            local off = point and offCentre(point)
            if off then
                c.point, c.off, c.at = point, off, now
                c.score = off + c.distance * 0.02
                reachable[#reachable + 1] = c
            end
        end
        if c.placed then
            local b = math.max(1, math.floor(c.distance * 4) + 1)
            local bin = bins[b]
            if not bin then
                bin = {}
                bins[b] = bin
            end
            bin[#bin + 1] = c
        end
    end

    -- The best that can be used; the one in focus stays unless another is clearly nearer the middle.
    table.sort(reachable, byScore)
    local best, reach, current, currentReach
    for _, c in ipairs(reachable) do
        if fresh(c, now, pos) and inSight(c, now, c.point, 0) then
            local r = usable(c, c.point)
            if #r > 0 then
                best, reach = c, r
                break
            end
        end
    end
    local f = state.focus
    if f and best and best.key ~= f.key then
        for _, c in ipairs(reachable) do
            if c.key == f.key then
                if best.score > c.score - SWITCH and fresh(c, now, pos) and inSight(c, now, c.point, 0) then
                    currentReach = usable(c, c.point)
                    if #currentReach > 0 then current = c end
                end
                break
            end
        end
    end
    if current then best, reach = current, currentReach end
    if best then best.anchor = anchorOf(best) end

    -- Dots: the nearest things a script put there that have something for the player.
    local dots = {}
    for b = 1, math.floor((reachMax + HINT) * 4) + 1 do
        local bin = bins[b]
        if bin then
            if #bin > 1 then table.sort(bin, byDistance) end
            for _, c in ipairs(bin) do
                if c == best or dotted(c, now, pos) then
                    dots[#dots + 1] = { key = c.key, anchor = c == best and best.anchor or anchorOf(c), point = c.point, distance = c.distance, reach = c.reachMax }
                    if #dots >= MAX_DOTS then break end
                end
            end
            if #dots >= MAX_DOTS then break end
        end
    end

    setFocus(best, reach)
    state.dots = dots
    dotsWithin = nil
    if #dots >= MAX_DOTS then
        local furthest = 0
        for _, d in ipairs(dots) do furthest = math.max(furthest, d.distance) end
        dotsWithin = furthest + 0.5 -- as far as the player may walk till the next look
    end

    -- What each dot fades to (fainter at the edge of its range): the frames only follow it.
    for _, fade in pairs(fades) do fade.dot = 0.0 end
    for _, d in ipairs(dots) do
        local fade = fades[d.key]
        if not fade then
            fade = { alpha = 0.0 }
            fades[d.key] = fade
        end
        fade.anchor = d.anchor
        fade.dot = clamp(1.0 - (d.distance - d.reach) / HINT * 0.5, 0.5, 1.0)
    end
    local focus = state.focus
    if focus and fades[focus.key] then fades[focus.key].anchor = focus.anchor end

    -- Where the panel goes (its selected option at the key), dots fade out: it's drawn over them.
    local px, py
    if focus and box then px, py = toPixels(best.point) end
    if px then
        local left = px + box.x - CANVAS.ax - UNDER_PX
        local top = py + box.y - CANVAS.ay - (focus.selected - 1) * box.row - UNDER_PX
        local right, bottom = left + box.w + UNDER_PX * 2, top + box.h + UNDER_PX * 2
        for _, d in ipairs(dots) do
            if d.key ~= focus.key then
                local x, y = toPixels(d.point)
                if x and x >= left and x <= right and y >= top and y <= bottom then fades[d.key].dot = 0.0 end
            end
        end
    end
    return SCAN_MS
end

-- Picking an option ---------------------------------------------------------------------------------------

local pickedAt = -math.huge

---A function, or one from another resource (a table that can be called, which mustn't be indexed).
local function callable(v)
    return type(v) == 'function' or (type(v) == 'table' and rawget(v, '__cfx_functionReference') ~= nil)
end

---The data an option's onSelect gets: the option's own fields and where it was picked (as ox_target gives it).
local function response(f, o)
    local data = {}
    for k, v in pairs(o) do
        if not callable(v) and k ~= 'resource' then data[k] = v end
    end
    data.entity, data.coords, data.distance, data.zone, data.bone = f.entity or 0, f.anchor(), f.distance, f.zone, f.bone
    return data
end

function Interact.select()
    local now = GetGameTimer()
    local f = state.focus
    if not f or now - pickedAt < 400 or Interact.blocked(PlayerPedId()) then return end
    local o = f.options[f.selected]
    if not o then return end
    pickedAt = now

    send({ action = 'press' })
    PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)

    local data = response(f, o)
    if o.onSelect then
        CreateThread(function()
            local ok, err = pcall(o.onSelect, data)
            if not ok then failed(o, 'onSelect', err) end
        end)
    elseif o.event then
        TriggerEvent(o.event, data)
    elseif o.serverEvent then
        local entity = data.entity
        data.entity = entity ~= 0 and NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity) or 0
        TriggerServerEvent(o.serverEvent, data)
    elseif o.command then
        ExecuteCommand(o.command)
    end
end

---Scrolls the focused target's options by `step` (stops at either end).
function Interact.scroll(step)
    local f = state.focus
    if not f or #f.options < 2 then return end
    local selected = clamp(f.selected + step, 1, #f.options)
    if selected == f.selected then return end
    f.selected = selected
    if lastShow then lastShow.selected = selected - 1 end
    send({ action = 'select', selected = selected - 1 })
    PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
end

RegisterCommand(COMMAND, function() Interact.select() end, false)
RegisterKeyMapping(COMMAND, 'Interact (TR Scripts)', 'keyboard', 'E')

-- Drawing -------------------------------------------------------------------------------------------------

local WHEEL = { 14, 15, 16, 17, 261, 262 } -- the weapon wheel's scroll, on foot
local KEY = { 38, 46, 51 } -- the game's own use of E on foot

local frameAt = 0

-- The origin stays set until the next sprite's; it's cleared once at the end of the frame.
local function drawAt(point, name, x, y, w, h, alpha)
    SetDrawOrigin(point.x, point.y, point.z, 0)
    DrawSprite(txdName, name, x, y, w, h, 0.0, 255, 255, 255, math.floor(alpha * 255 + 0.5))
end

---One frame: the controls while something is in focus, the dots and the panel. Returns false when
---there's nothing left to draw.
function Interact.frame(now)
    local dt = math.min((now - frameAt) / 1000, 0.1)
    frameAt = now
    local sw, sh = screen.w, screen.h
    local f = state.focus
    local drew = false

    if f then
        for _, c in ipairs(KEY) do DisableControlAction(0, c, true) end
        if #f.options > 1 then
            for _, c in ipairs(WHEEL) do DisableControlAction(0, c, true) end
            if IsDisabledControlJustPressed(0, 15) or IsDisabledControlJustPressed(0, 17) or IsControlJustPressed(0, 172) then
                Interact.scroll(-1)
            elseif IsDisabledControlJustPressed(0, 14) or IsDisabledControlJustPressed(0, 16) or IsControlJustPressed(0, 173) then
                Interact.scroll(1)
            end
        end
    end

    -- The panel: shown once the page has painted it (or it's taken too long), until it has closed. It's
    -- drawn after the dots, over them.
    local panelKey, panelAt
    if panel then
        if panel.leaving and now >= panel.untilAt then
            -- it has shrunk back into its dot: the dot takes over at once
            if fades[panel.key] then fades[panel.key].alpha = 1.0 end
            panel = nil
        else
            panelKey = panel.key
            -- (a page still loading gets longer: its texture is empty till then)
            local waited = now - panel.since
            local ready = painted >= panel.seq or (duiReady and waited >= PANEL_WAIT) or waited >= 1500
            if ready or panel.leaving then
                panelAt = panel.anchor() or panel.last
                panel.last = panelAt
            else
                panelKey = nil -- not painted yet: its dot stands in
            end
        end
    end

    -- Dots: fade in and out, to what the last look said.
    local any = panel ~= nil
    local w, h = DOT_PX / sw, DOT_PX / sh
    local focusKey = f and f.key
    if f and f.key ~= panelKey and not fades[f.key] then
        -- in focus but not painted yet, with no dot of its own (like an ATM): a dot at it meanwhile
        fades[f.key] = { alpha = 1.0, dot = 0.0, anchor = f.anchor }
    end
    for key, fade in pairs(fades) do
        local target = fade.dot
        if key == focusKey and target <= 0 then target = 1.0 end
        if key == panelKey then
            fade.alpha = 0.0 -- the panel grows out of the dot and shrinks back into it
        elseif fade.alpha < target then
            fade.alpha = math.min(target, fade.alpha + dt / 0.15)
        elseif fade.alpha > target then
            fade.alpha = math.max(target, fade.alpha - dt / 0.15)
        end
        if fade.alpha <= 0 and target <= 0 and key ~= panelKey then
            fades[key] = nil
        else
            any = true
            if fade.alpha > 0 then
                local point = fade.anchor()
                if point then fade.last = point end
                if fade.last then
                    drawAt(fade.last, 'dot', 0.0, 0.0, w, h, fade.alpha)
                    drew = true
                end
            end
        end
    end
    if panelAt then
        drawAt(panelAt, 'panel', (CANVAS.w / 2 - CANVAS.ax) / sw, (CANVAS.h / 2 - CANVAS.ay) / sh, CANVAS.w / sw, CANVAS.h / sh, 1.0)
        drew = true
    end
    if drew then ClearDrawOrigin() end

    return any or f ~= nil
end

-- Running it ----------------------------------------------------------------------------------------------

local drawing = false

local function startDrawing()
    if drawing then return end
    drawing = true
    frameAt = GetGameTimer()
    CreateThread(function()
        while drawing do
            if not txdName then ensureDui() end
            drawing = Interact.frame(GetGameTimer())
            Wait(0)
        end
    end)
end

CreateThread(function()
    while true do
        local wait = Interact.scan(GetGameTimer())
        if state.focus or #state.dots > 0 or panel then startDrawing() end
        Wait(wait)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == RESOURCE and dui then DestroyDui(dui) end
end)

return Interact
