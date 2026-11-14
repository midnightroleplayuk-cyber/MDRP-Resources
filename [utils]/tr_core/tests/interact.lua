-- tr_core's own interaction (client/interact.lua) and the target setting that picks it.
local check = T.check

-- The target setting ------------------------------------------------------------------------------

T.resource = 'tr_example'
T.boot('client', {})
check('target: tr_core with none installed', TR.system('target') == 'tr_core')

T.boot('client', { ox_target = 'started' })
check('target: auto finds ox_target', TR.system('target') == 'ox_target')

T.boot('client', { ['qb-target'] = 'started' })
check('target: auto finds qb-target', TR.system('target') == 'qb_target')

T.boot('client', { ox_target = 'started' }, nil, { target = 'tr_core' })
check('target: tr_core when set, ox_target or not', TR.system('target') == 'tr_core')

-- A small world -------------------------------------------------------------------------------------

joaat = function(name)
    local h = 0
    for i = 1, #name do h = (h * 31 + name:byte(i)) & 0xFFFFFFFF end
    return h
end

T.world = {} ---@type table<integer, table>
T.cam = vector3(0.0, -2.0, 1.0)
T.flags = {}
T.items = {}
T.job = false
T.sprites = {}
T.dui = {}
T.served = {}
T.commandsRun = {}
T.walls = false

local function ent(handle, data)
    data.heading = data.heading or 0.0
    data.type = data.type or 3
    T.world[handle] = data
    return handle
end

local function e(handle) return T.world[handle] end
local function rot(h)
    local r = math.rad(h)
    return math.cos(r), math.sin(r)
end

DoesEntityExist = function(h) return T.world[h] ~= nil end
GetEntityCoords = function(h)
    if h == 1 then return T.player end
    local x = e(h)
    return x and x.pos or vector3(0, 0, 0)
end
GetEntityModel = function(h) return e(h) and e(h).model or 0 end
GetEntityForwardVector = function(h)
    local c, s = rot(e(h).heading)
    return vector3(-s, c, 0.0)
end
GetEntityType = function(h) return e(h) and e(h).type or 0 end
IsPedAPlayer = function(h) return e(h) and e(h).player or false end
GetModelDimensions = function(model)
    local d = T.dims and T.dims[model]
    if d then return d[1], d[2] end
    return vector3(-0.5, -0.5, 0.0), vector3(0.5, 0.5, 1.0)
end
GetOffsetFromEntityGivenWorldCoords = function(h, x, y, z)
    local o = e(h)
    local c, s = rot(o.heading)
    local dx, dy = x - o.pos.x, y - o.pos.y
    return vector3(dx * c + dy * s, -dx * s + dy * c, z - o.pos.z)
end
GetOffsetFromEntityInWorldCoords = function(h, x, y, z)
    local o = e(h)
    local c, s = rot(o.heading)
    return vector3(o.pos.x + x * c - y * s, o.pos.y + x * s + y * c, o.pos.z + z)
end
GetPedBoneCoords = function(h) return e(h).pos + vector3(0, 0, 0.5) end
GetEntityBoneIndexByName = function(h, bone)
    local o = e(h)
    if o and o.bones and o.bones[bone] then return #bone end
    return -1
end
GetWorldPositionOfEntityBone = function(h, index)
    for name, offset in pairs(e(h).bones) do
        if #name == index then return e(h).pos + offset end
    end
end
NetworkGetEntityIsNetworked = function(h) return e(h) and e(h).net ~= nil end
NetworkGetNetworkIdFromEntity = function(h) return e(h).net end
NetworkDoesEntityExistWithNetworkId = function(id)
    for _, o in pairs(T.world) do if o.net == id then return true end end
    return false
end
NetworkGetEntityFromNetworkId = function(id)
    for h, o in pairs(T.world) do if o.net == id then return h end end
end
local POOL_TYPES = { CPed = 1, CVehicle = 2, CObject = 3 }
GetClosestObjectOfType = function(x, y, z, radius, model)
    local best, bestD = 0, radius
    for h, o in pairs(T.world) do
        if o.type == 3 and (o.model & 0xFFFFFFFF) == (model & 0xFFFFFFFF) then
            local d = #(o.pos - vector3(x, y, z))
            if d <= bestD then best, bestD = h, d end
        end
    end
    return best
end
GetGamePool = function(name)
    local out = {}
    for h, o in pairs(T.world) do if o.type == POOL_TYPES[name] then out[#out + 1] = h end end
    table.sort(out)
    return out
end

IsNuiFocused = function() return T.flags.nui == true end
IsPauseMenuActive = function() return false end
IsPedInAnyVehicle = function() return T.flags.vehicle == true end
IsPedDeadOrDying = function() return false end
IsPedRagdoll = function() return false end
IsPedFalling = function() return false end
IsPedCuffed = function() return false end
IsPlayerFreeAiming = function() return false end
PlayerId = function() return 0 end
GetRenderingCam = function() return T.flags.cam and 5 or -1 end

GetFinalRenderedCamCoord = function() return T.cam end
GetFinalRenderedCamRot = function() return vector3(0.0, 0.0, 0.0) end -- looking along +Y
GetFinalRenderedCamFov = function() return 90.0 end
GetAspectRatio = function() return 16 / 9 end
-- The camera looks along +Y.
GetScreenCoordFromWorldCoord = function(x, y, z)
    local depth = y - T.cam.y
    if depth <= 0.05 then return false, -1, -1 end
    local sx, sy = 0.5 + (x - T.cam.x) / depth * 0.3, 0.5 - (z - T.cam.z) / depth * 0.5
    return sx >= 0 and sx <= 1 and sy >= 0 and sy <= 1, sx, sy
end
StartExpensiveSynchronousShapeTestLosProbe = function(...) T.ray = table.pack(...) return 7 end
GetShapeTestResult = function() return 2, T.walls end

CreateRuntimeTxd = function(name) T.txd = name return 3 end
CreateRuntimeTextureFromImage = function() end
CreateDui = function(url, w, h) T.duiUrl, T.duiSize = url, { w, h } return 9 end
GetDuiHandle = function() return 'handle' end
CreateRuntimeTextureFromDuiHandle = function() end
DestroyDui = function() end
SendDuiMessage = function(_, s) T.dui[#T.dui + 1] = T.encoded[s] end
T.encoded = {}
json.encode = function(t)
    local key = 'm' .. (#T.dui + 1) .. ':' .. tostring(t.action)
    T.encoded[key] = t
    return key
end
GetControlInstructionalButton = function() return 't_E' end
PlaySoundFrontend = function() end
RegisterKeyMapping = function(command, _, _, key) T.mapping = { command = command, key = key } end
DisableControlAction = function(_, c) T.disabled = T.disabled or {}; T.disabled[c] = true end
IsDisabledControlJustPressed = function(_, c) return T.pressed == c end
IsControlJustPressed = function(_, c) return T.pressed == c end
GetActiveScreenResolution = function() return 1920, 1080 end
SetDrawOrigin = function(x, y, z) T.origin = vector3(x, y, z) end
DrawSprite = function(dict, name, x, y, w, h, _, _, _, _, a)
    T.sprites[#T.sprites + 1] = { dict = dict, name = name, x = x, y = y, w = w, h = h, a = a, at = T.origin }
end
ClearDrawOrigin = function() end
ExecuteCommand = function(c) T.commandsRun[#T.commandsRun + 1] = c end

local threads = {}
CreateThread = function(fn) threads[#threads + 1] = fn end
local function runThreads()
    local list = threads
    threads = {}
    for _, fn in ipairs(list) do fn() end
end

T.player = vector3(0.0, 0.0, 0.0)

-- tr_core itself, running the interaction
T.resource = 'tr_core'
T.ownExports = {}
T.boot('client', {})
rawset(TR, 'inventory', { hasItem = function(name, count) return (T.items[name] or 0) >= (count or 1) end })
rawset(TR, 'player', {
    hasJob = function(filter) return T.job and (filter == T.job or (type(filter) == 'table' and (filter[T.job] ~= nil or filter[1] == T.job))) or false end,
    hasGang = function() return false end,
})
local Interact = load(LoadResourceFile('tr_core', 'client/interact.lua'), '@interact.lua')()
check('loads: its key is E and can be bound', T.mapping and T.mapping.command == 'tr_interact' and T.mapping.key == 'E')
check('loads: the drawing loop waits to be needed', #threads == 1)
threads = {}

-- The exports, as a resource's bridge reaches them
T.exports.tr_core = setmetatable({}, { __index = function(_, k)
    local fn = T.ownExports[k]
    return fn and function(_, ...) return fn(...) end
end })
local core = T.exports.tr_core
local function as(resource, fn, ...)
    T.invoking = resource
    local r = table.pack(fn(...))
    T.invoking = nil
    return table.unpack(r, 1, r.n)
end

local now = 1000
local function scan()
    now = now + 200
    T.timer = now
    return Interact.scan(now)
end
local function focusLabels()
    local f = Interact.state.focus
    if not f then return nil end
    local out = {}
    for i, o in ipairs(f.options) do out[i] = o.label end
    return table.concat(out, ',')
end
local function lastDui(action)
    for i = #T.dui, 1, -1 do
        if T.dui[i] and T.dui[i].action == action then return T.dui[i], i end
    end
end
local function reset()
    for k in pairs(T.world) do T.world[k] = nil end
    T.player = vector3(0.0, 0.0, 0.0)
    T.flags, T.walls, T.items, T.job = {}, false, {}, false
    T.events, T.serverEvents = {}, {}
end

-- The bridge ----------------------------------------------------------------------------------------

T.resource = 'tr_example'
local bridgeFile = LoadResourceFile('tr_core', 'bridge/target/tr_core/client.lua')
check('bridge: exists', bridgeFile ~= nil)
local bridge = load(bridgeFile, '@bridge.lua')('tr_core')
check('bridge: every TR.target function', bridge.addBoxZone and bridge.removeZone and bridge.addModel and bridge.removeModel
    and bridge.addEntity and bridge.addLocalEntity and bridge.removeLocalEntity and bridge.addGlobalVehicle
    and bridge.removeGlobalPlayer and bridge.addPolyZone)
T.resource = 'tr_core'

-- Zones: how far ------------------------------------------------------------------------------------

do
    local near = function(z, p) return Interact.zoneDistance(z, p) end
    local sphere = { shape = 'sphere', center = vector3(0, 0, 0), radius = 1.0 }
    check('zone: inside a sphere is 0', near(sphere, vector3(0.5, 0, 0)) == 0)
    check('zone: outside a sphere is past its edge', math.abs(near(sphere, vector3(3, 0, 0)) - 2) < 1e-9)

    -- 4 m long along x, turned 90 degrees: long along y
    local r = math.rad(90)
    local box = { shape = 'box', center = vector3(0, 0, 0), size = vector3(4, 1, 2), cos = math.cos(r), sin = math.sin(r) }
    check('zone: a turned box is long the other way', near(box, vector3(0, 1.9, 0)) < 1e-6 and math.abs(near(box, vector3(1.9, 0, 0)) - 1.4) < 1e-6)

    local poly = { shape = 'poly', center = vector3(1, 1, 0), thickness = 2.0,
        points = { vector3(0, 0, 0), vector3(2, 0, 0), vector3(2, 2, 0), vector3(0, 2, 0) } }
    check('zone: inside a poly is 0', near(poly, vector3(1, 1, 0.5)) == 0)
    check('zone: beside a poly is to its edge', math.abs(near(poly, vector3(3, 1, 0)) - 1) < 1e-9)
    check('zone: above a poly counts its height', math.abs(near(poly, vector3(1, 1, 3)) - 2) < 1e-9)
end

-- Registering ---------------------------------------------------------------------------------------

reset()
local broker = ent(101, { pos = vector3(0.0, 1.5, 0.0), type = 1, model = 55 })
local picked = {}
as('tr_crypto', core.addLocalEntity, core, broker, {
    { name = 'tr_crypto:broker', label = 'Browse warehouses', distance = 2.5, onSelect = function(data) picked[#picked + 1] = data end },
})

scan()
check('focus: the ped in reach', focusLabels() == 'Browse warehouses')
local show = lastDui('show')
check('focus: the page gets its options and key', show and show.rows[1] == 'Browse warehouses' and show.key == 'E' and show.selected == 0)
check('page: made when first needed, at twice its size', T.duiUrl and T.duiUrl:find('cfx%-nui%-tr_core/web/interact/index.html') and T.duiSize[1] == 800 and T.duiSize[2] == 1024)
check('focus: anchored at the chest', Interact.state.focus.anchor().z == 0.5)

-- Same name from the same resource replaces it
as('tr_crypto', core.addLocalEntity, core, broker, { name = 'tr_crypto:broker', label = 'Browse warehouses (2)', distance = 2.5 })
scan()
check('register: same name replaces', focusLabels() == 'Browse warehouses (2)')
check('register: a change updates the page', lastDui('update') and lastDui('update').rows[1] == 'Browse warehouses (2)')
as('tr_crypto', core.addLocalEntity, core, broker, {
    { name = 'tr_crypto:broker', label = 'Browse warehouses', distance = 2.5, onSelect = function(data) picked[#picked + 1] = data end },
})
scan()

-- Picking
Interact.select()
runThreads()
check('pick: onSelect runs with the entity', #picked == 1 and picked[1].entity == broker and picked[1].name == 'tr_crypto:broker')
check('pick: no functions and no resource in what it gets', picked[1].onSelect == nil and picked[1].resource == nil and picked[1].label == 'Browse warehouses')
check('pick: where and how far', picked[1].coords and picked[1].distance and picked[1].distance < 2.5)
check('pick: the key shows the press', lastDui('press') ~= nil)
Interact.select()
runThreads()
check('pick: not twice in a row', #picked == 1)
T.timer = T.timer + 500
Interact.select()
runThreads()
check('pick: again after a moment', #picked == 2)

-- Out of reach, but near: a dot (a script put it there)
T.world[broker].pos = vector3(0.0, 4.0, 0.0)
scan()
check('dot: out of reach is not in focus', Interact.state.focus == nil)
check('dot: but marked', #Interact.state.dots == 1 and Interact.state.dots[1].key == 'e' .. broker)
check('dot: the panel closes', lastDui('hide') ~= nil)
T.world[broker].pos = vector3(0.0, 10.0, 0.0)
scan()
check('dot: too far for one', #Interact.state.dots == 0)

-- Behind a wall
T.world[broker].pos = vector3(0.0, 1.5, 0.0)
T.walls = true
scan()
check('wall: not through the map', Interact.state.focus == nil and #Interact.state.dots == 0)
T.walls = false
scan()
check('wall: back once in sight', focusLabels() == 'Browse warehouses')
check('wall: the probe ignores the thing itself', T.ray[8] == broker)

-- Things that are everywhere: no dot, only their option in reach
local atm = ent(102, { pos = vector3(1.0, 4.0, 0.0), model = joaat('prop_atm_01') })
local atmUsed = 0
as('tr_fraud', core.addModel, core, 'prop_atm_01', {
    { name = 'tr_fraud:atm', label = 'Use cloned card', distance = 1.5, canInteract = function() atmUsed = atmUsed + 1 return true end },
})
T.world[broker].pos = vector3(0.0, 20.0, 0.0)
scan()
check('model: no dot out of reach', #Interact.state.dots == 0 and Interact.state.focus == nil)
check('model: not asked out of reach', atmUsed == 0)
T.player = vector3(1.0, 2.2, 0.0)
scan()
check('model: in reach by its hash from a name', focusLabels() == 'Use cloned card')
check('model: no dot even in reach', #Interact.state.dots == 0)
as('tr_fraud', core.removeModel, core, joaat('prop_atm_01') - 0x100000000, 'tr_fraud:atm')
scan()
check('model: removed by name, signed hash', Interact.state.focus == nil)

-- canInteract, items and groups
reset()
local stand = ent(201, { pos = vector3(0.0, 1.2, 0.0), model = 77 })
local on = true
local bad = 0
as('tr_crypto', core.addLocalEntity, core, stand, {
    { name = 'open', label = 'Work on the stand', distance = 2.5 },
    { name = 'off', label = 'Switch off', distance = 2.5, canInteract = function() return on end },
    { name = 'on', label = 'Switch on', distance = 2.5, canInteract = function() return not on end },
    { name = 'boom', label = 'Broken', distance = 2.5, canInteract = function() bad = bad + 1 error('bug') end },
    { name = 'item', label = 'Needs a key', distance = 2.5, items = 'key' },
    { name = 'cop', label = 'Police only', distance = 2.5, groups = { police = 0 } },
})
T.logs = {}
scan()
check('options: canInteract picks', focusLabels() == 'Work on the stand,Switch off')
local errors = 0
for _, l in ipairs(T.logs) do if tostring(l):find('canInteract') then errors = errors + 1 end end
check('options: a failing canInteract hides it, said once', errors == 1)
scan()
errors = 0
for _, l in ipairs(T.logs) do if tostring(l):find('canInteract') then errors = errors + 1 end end
check('options: not said again', errors == 1 and bad == 2)
T.items.key = 1
T.job = 'police'
scan()
check('options: items and groups', focusLabels() == 'Work on the stand,Switch off,Needs a key,Police only')

-- Scrolling, and the selection kept while options change
Interact.scroll(1)
check('scroll: next', Interact.state.focus.selected == 2 and lastDui('select').selected == 1)
Interact.scroll(1)
check('scroll: and the next', Interact.state.focus.selected == 3)
Interact.scroll(1)
Interact.scroll(1)
check('scroll: stops at the end', Interact.state.focus.selected == 4)
Interact.scroll(-1)
Interact.scroll(-1)
check('scroll: back', Interact.state.focus.selected == 2)
on = false
scan()
check('options: changed while in focus', focusLabels() == 'Work on the stand,Switch on,Needs a key,Police only')
check('options: the picked one went: the first instead', Interact.state.focus.selected == 1)
Interact.scroll(1)
Interact.scroll(1)
check('options: on Needs a key', Interact.state.focus.options[Interact.state.focus.selected].label == 'Needs a key')
on = true
scan()
check('options: kept on it when another changes', Interact.state.focus.options[Interact.state.focus.selected].label == 'Needs a key')

-- The look decides between two
reset()
local left = ent(301, { pos = vector3(-0.8, 1.5, 0.0), model = 77 })
local right = ent(302, { pos = vector3(0.25, 1.5, 0.0), model = 77 })
as('tr_crypto', core.addLocalEntity, core, { left, right }, { name = 'open', label = 'Work on the stand', distance = 2.5 })
scan()
check('look: the one nearest the middle', Interact.state.focus.entity == right)
T.world[right].pos = vector3(0.9, 1.5, 0.0)
T.world[left].pos = vector3(-0.85, 1.5, 0.0)
scan()
check('look: the one in focus stays when it is close', Interact.state.focus.entity == right)
T.world[left].pos = vector3(0.0, 1.5, 0.0)
local _, before = lastDui('show')
scan()
check('look: another clearly nearer the middle takes over', Interact.state.focus.entity == left)
local _, after = lastDui('show')
check('look: the new one opens on its own', after > before)

-- The entity's anchor: the middle of the side facing the player
do
    local _, face = Interact.entityPoints(left, T.player)
    check('anchor: on the side facing the player', math.abs(face.y - 1.0) < 1e-9 and math.abs(face.x) < 1e-9 and math.abs(face.z - 0.5) < 1e-9)
end

-- Removing, and a resource stopping
as('tr_crypto', core.removeLocalEntity, core, left, 'open')
scan()
check('remove: by entity and name', Interact.state.focus.entity == right or Interact.state.focus == nil)
as('tr_other', core.removeLocalEntity, core, right)
scan()
check('remove: another resource cannot take them', Interact.state.focus and Interact.state.focus.entity == right or #Interact.state.dots > 0)
local zone = as('tr_crypto', core.addSphereZone, core, { coords = vector3(0.0, 1.0, 0.0), radius = 0.5, options = { { label = 'Enter warehouse', distance = 2.0 } } })
check('zone: gives an id', type(zone) == 'number')
for _, fn in ipairs(T.handlers.onClientResourceStop or {}) do fn('tr_crypto') end
scan()
check('stop: its options go with it', Interact.state.focus == nil and #Interact.state.dots == 0)

-- Zones
reset()
local door = as('tr_crypto', core.addSphereZone, core, { coords = vector3(0.0, 2.0, 0.5), radius = 1.2,
    options = { { name = 'door', label = 'Enter warehouse', distance = 2.5 } } })
T.walls = true
scan()
check('zone: in reach (to its edge), and the map is not asked', focusLabels() == 'Enter warehouse')
check('zone: anchored at its middle', Interact.state.focus.anchor().y == 2.0 and Interact.state.focus.zone == door)
T.walls = false
as('tr_crypto', core.removeZone, core, door)
scan()
check('zone: removed', Interact.state.focus == nil)

local box = as('tr_laptop', core.addBoxZone, core, { coords = vector3(0.0, 2.0, 0.0), size = vector3(1, 1, 1), rotation = 45,
    options = { { label = 'Use laptop', distance = 1.6 } } })
scan()
check('zone: box in reach', focusLabels() == 'Use laptop')
as('tr_laptop', core.removeZone, core, box)

-- Bones on every vehicle
reset()
local car = ent(401, { pos = vector3(0.0, 2.5, 0.0), type = 2, model = 88, bones = { handle_dside_f = vector3(-0.9, 0.4, 0.6) } })
T.dims = { [88] = { vector3(-1.0, -2.2, -0.5), vector3(1.0, 2.2, 1.0) } }
as('tr_minigames', core.addGlobalVehicle, core, {
    { name = 'lockpick', label = 'Pick the lock', distance = 2.0, bones = 'handle_dside_f' },
})
T.player = vector3(-1.5, 2.9, 0.0)
scan()
check('bones: a vehicle option at its bone', focusLabels() == 'Pick the lock' and Interact.state.focus.bone == 'handle_dside_f')
local at = Interact.state.focus.anchor()
check('bones: anchored at the bone', math.abs(at.x + 0.9) < 1e-9 and math.abs(at.z - 0.6) < 1e-9)
as('tr_minigames', core.removeGlobalVehicle, core, 'lockpick')
scan()
check('bones: removed by name', Interact.state.focus == nil)

-- event / serverEvent / command
reset()
local crate = ent(501, { pos = vector3(0.0, 1.2, 0.0), model = 99, net = 77 })
T.fired = {}
as('tr_example', core.addEntity, core, 77, {
    { name = 'a', label = 'Event', distance = 2.0, event = 'tr_example:event' },
    { name = 'b', label = 'Server', distance = 2.0, serverEvent = 'tr_example:server' },
    { name = 'c', label = 'Command', distance = 2.0, command = 'tr_cmd' },
})
scan()
check('networked: found by its network id', focusLabels() == 'Event,Server,Command')
T.timer = T.timer + 1000
Interact.select()
check('pick: event', T.count('tr_example:event') == 1 and T.fired['tr_example:event'][1][1].entity == crate)
Interact.scroll(1)
T.timer = T.timer + 1000
T.serverEvents = {}
Interact.select()
check('pick: server event with the network id', #T.serverEvents == 1 and T.serverEvents[1].name == 'tr_example:server' and T.serverEvents[1].args[1].entity == 77)
Interact.scroll(1)
T.timer = T.timer + 1000
Interact.select()
check('pick: command', T.commandsRun[#T.commandsRun] == 'tr_cmd')

-- When it stays out of the way
T.flags.nui = true
scan()
check('blocked: a menu or page has the mouse', Interact.state.focus == nil)
T.flags.nui = false
scan()
check('blocked: back after', Interact.state.focus ~= nil)
TriggerEvent('tr:hud', 'tr_crypto', true)
scan()
check('blocked: while a script shows its hint bar', Interact.state.focus == nil)
TriggerEvent('tr:hud', 'tr_crypto', false)
scan()
check('blocked: back when it hides', Interact.state.focus ~= nil)
TriggerEvent('tr:hud', 'tr_fraud', true)
for _, fn in ipairs(T.handlers.onClientResourceStop or {}) do fn('tr_fraud') end
scan()
check('blocked: a resource that stopped with its hint bar up', Interact.state.focus ~= nil)
T.flags.vehicle = true
scan()
check('blocked: in a vehicle', Interact.state.focus == nil)
T.flags.vehicle = false
T.flags.cam = true
scan()
check('blocked: a scripted camera', Interact.state.focus == nil)
T.flags.cam = false

-- A deleted entity's options go (its handle may be given out again)
reset()
local gone = ent(601, { pos = vector3(0.0, 1.2, 0.0), model = 77 })
as('tr_crypto', core.addLocalEntity, core, gone, { label = 'Gone', distance = 2.0 })
scan()
check('deleted: in focus first', focusLabels() == 'Gone')
T.world[gone] = nil
now = now + 2000
scan()
ent(601, { pos = vector3(0.0, 1.2, 0.0), model = 77 })
now = now + 2000
scan()
check('deleted: a new entity with its handle has none', Interact.state.focus == nil)

-- A dot only from an option near enough for one
reset()
local twoReach = ent(602, { pos = vector3(0.0, 5.0, 0.0), model = 78 })
as('tr_crypto', core.addLocalEntity, core, twoReach, {
    { name = 'short', label = 'Short', distance = 1.0 },
    { name = 'long', label = 'Long', distance = 6.0, canInteract = function() return false end },
})
scan()
check('dot: not from an option too far for one', #Interact.state.dots == 0 and Interact.state.focus == nil)

-- What a look costs: what's near, not how much has options
local function reads(names, fn)
    local calls, saved = 0, {}
    for _, n in ipairs(names) do
        saved[n] = _G[n]
        _G[n] = function(...)
            calls = calls + 1
            return saved[n](...)
        end
    end
    fn()
    for _, n in ipairs(names) do _G[n] = saved[n] end
    return calls
end
reset()
local many = {}
for i = 1, 2000 do
    many[i] = ent(10000 + i, { pos = vector3(100.0 + (i % 50) * 1.5, 100.0 + (i // 50) * 1.5, 0.0), model = 77 })
end
as('tr_crypto', core.addLocalEntity, core, many, { name = 'open', label = 'Look at the miner', distance = 2.5 })
local walker = ent(9002, { pos = vector3(30.0, 0.0, 0.0), type = 1, model = 55 })
as('tr_crypto', core.addLocalEntity, core, walker, { name = 'talk', label = 'Talk', distance = 2.0 })
local near = ent(9001, { pos = vector3(0.0, 1.2, 0.0), model = 77 })
as('tr_crypto', core.addLocalEntity, core, near, { name = 'open', label = 'Work on the stand', distance = 2.5 })
scan()
local entityReads = reads({ 'DoesEntityExist', 'GetEntityCoords', 'GetEntityModel', 'GetEntityForwardVector', 'GetOffsetFromEntityInWorldCoords' }, function()
    for _ = 1, 5 do scan() end
end)
check('cost: 2000 props far away are not read each look', focusLabels() == 'Work on the stand' and entityReads < 5 * 40)
local pools = reads({ 'GetGamePool' }, function()
    for _ = 1, 6 do scan() end
end)
check('cost: things by their model are found without going through every object', pools == 0)

-- A ped walking up is seen within a second, however many props there are
T.world[walker].pos = vector3(0.0, 1.5, 0.0)
T.world[near].pos = vector3(0.0, 40.0, 0.0)
for _ = 1, 6 do scan() end
check('moving: a ped is looked at every second', focusLabels() == 'Talk')
as('tr_crypto', core.removeLocalEntity, core, walker)

-- A prop deleted without its options removed goes at once, even among many (its handle may be given out again)
local gone2 = ent(9003, { pos = vector3(0.0, 1.2, 0.0), model = 77 })
as('tr_crypto', core.addLocalEntity, core, gone2, { name = 'open', label = 'Gone too', distance = 2.5 })
scan()
check('deleted among many: in focus first', focusLabels() == 'Gone too')
T.world[gone2] = nil
scan()
ent(9003, { pos = vector3(0.0, 1.2, 0.0), model = 77 })
scan()
scan()
check('deleted among many: a new entity with its handle has none', Interact.state.focus == nil)
as('tr_crypto', core.removeLocalEntity, core, many)

-- A prop moved without its options being added again is found where it went
local moved = ent(9101, { pos = vector3(40.0, 0.0, 0.0), model = 77 })
as('tr_crypto', core.addLocalEntity, core, moved, { name = 'open', label = 'Moved stand', distance = 2.5 })
scan()
T.world[moved].pos = vector3(0.0, 1.2, 0.0)
for _ = 1, 5 do scan() end
check('moved: found where it went', focusLabels() == 'Moved stand')
as('tr_crypto', core.removeLocalEntity, core, { moved, near })

-- More than enough for the dots: the nearest are the ones shown, as the player moves
reset()
local row = {}
for i = 0, 9 do row[#row + 1] = ent(9200 + i, { pos = vector3(-2.25 + i * 0.5, 4.0, 0.0), model = 77 }) end
as('tr_crypto', core.addLocalEntity, core, row, { name = 'open', label = 'Work on the stand', distance = 2.5 })
local function dotXs()
    local xs = {}
    for _, d in ipairs(Interact.state.dots) do xs[#xs + 1] = T.world[tonumber(d.key:sub(2))].pos.x end
    table.sort(xs)
    return xs
end
scan()
scan()
local xs = dotXs()
check('dots: the eight nearest', #xs == 8 and math.abs(xs[1] + 1.75) < 1e-9 and math.abs(xs[8] - 1.75) < 1e-9)
T.player = vector3(2.0, 0.0, 0.0)
scan()
scan()
xs = dotXs()
check('dots: the eight nearest after a walk', #xs == 8 and math.abs(xs[1] + 1.25) < 1e-9 and math.abs(xs[8] - 2.25) < 1e-9)
as('tr_crypto', core.removeLocalEntity, core, row)

-- Big things and long reaches (kept out of the grid so they don't stretch every look) are still found
reset()
T.dims = { [120] = { vector3(-6.0, -1.0, 0.0), vector3(6.0, 1.0, 2.5) } }
local container = ent(9301, { pos = vector3(0.0, 3.4, 0.0), model = 120 })
as('tr_crypto', core.addLocalEntity, core, container, { name = 'open', label = 'Open the container', distance = 2.5 })
T.player = vector3(5.8, 0.0, 0.0)
scan()
check('wide: a 12 m container from its end', focusLabels() == 'Open the container')
as('tr_crypto', core.removeLocalEntity, core, container)
local far = ent(9302, { pos = vector3(0.0, 5.5, 0.0), model = 77 })
as('tr_crypto', core.addLocalEntity, core, far, { name = 'call', label = 'Call over', distance = 6.0 })
T.player = vector3(0.0, 0.0, 0.0)
scan()
check('wide: a 6 m reach from 5 m', focusLabels() == 'Call over')
as('tr_crypto', core.removeLocalEntity, core, far)

-- Drawing: the panel once painted, a dot meanwhile
reset()
T.sprites = {}
local p = ent(701, { pos = vector3(0.0, 1.5, 0.0), type = 1, model = 55 })
as('tr_crypto', core.addLocalEntity, core, p, { label = 'Browse warehouses', distance = 2.5 })
scan()
local s = lastDui('show')
local function drawn(name)
    local n = 0
    for _, sp in ipairs(T.sprites) do if sp.name == name then n = n + 1 end end
    return n
end
T.nui('interact:ready')
Interact.frame(T.timer)
check('draw: a dot until the page has painted', drawn('dot') == 1 and drawn('panel') == 0)
T.nui('interact:painted', { seq = s.seq })
T.sprites = {}
Interact.frame(T.timer + 16)
check('draw: the panel once painted', drawn('panel') == 1 and drawn('dot') == 0)
local sp = T.sprites[1]
check('draw: the key point on the thing', math.abs(sp.x - (200 - 40) / 1920) < 1e-9 and sp.y == 0 and math.abs(sp.w - 400 / 1920) < 1e-9)
check('draw: the game keeps E to itself while in focus', T.disabled and T.disabled[38] and T.disabled[51])
T.world[p].pos = vector3(0.0, 30.0, 0.0)
scan()
T.sprites = {}
Interact.frame(T.timer + 32)
check('draw: closing, still drawn', drawn('panel') == 1)
T.sprites = {}
Interact.frame(T.timer + 400)
check('draw: closed into its dot', drawn('panel') == 0 and drawn('dot') == 1)
local still = Interact.frame(T.timer + 600)
check('draw: the dot fades, then nothing left to draw', still == false)

-- Drawing: the panel over the dots, and a dot where it goes fades out. From the camera, 1 m across or up
-- at y = 1 is 180 px; the panel is the page's own measure of two options.
reset()
local ft = T.timer + 1000
local function frames(n)
    for _ = 1, n do
        ft = ft + 50
        T.sprites = {}
        Interact.frame(ft)
    end
end
local function dotAt(x, z)
    for _, sp in ipairs(T.sprites) do
        if sp.name == 'dot' and math.abs(sp.at.x - x) < 1e-6 and math.abs(sp.at.z - z) < 1e-6 then return true end
    end
    return false
end
local function sphere(x, z, options)
    return as('tr_crypto', core.addSphereZone, core, { coords = vector3(x, 1.0, z), radius = 0.2, options = options })
end
local spheres = {
    sphere(0.0, 1.0, { { label = 'Scan a receipt', distance = 2.5 }, { label = 'Pack up check printer', distance = 2.5 } }),
    sphere(0.3, 1.0, { { label = 'Collect the tray', distance = 2.5 } }), -- 54 px right of the key: under the panel
    sphere(1.5, 1.0, { { label = 'Collect the tray', distance = 2.5 } }), -- 270 px right: past it
    sphere(0.0, 1.25, { { label = 'Collect the tray', distance = 2.5 } }), -- 45 px above: above it, till it scrolls
}
scan()
scan()
check('under: the middle one in focus', focusLabels() == 'Scan a receipt,Pack up check printer')
frames(6)
check('under: before the page measures its panel, every dot', dotAt(0.3, 1.0) and dotAt(1.5, 1.0) and dotAt(0.0, 1.25))
T.nui('interact:painted', { seq = lastDui('show').seq, box = { x = 20, y = 236, w = 213, h = 76, row = 36 } })
scan()
frames(6)
check('under: a dot where the panel is fades out', not dotAt(0.3, 1.0))
check('under: the dots beside it and above it stay', dotAt(1.5, 1.0) and dotAt(0.0, 1.25))
check('under: the panel drawn over the dots', T.sprites[#T.sprites].name == 'panel' and drawn('dot') == 2)
Interact.scroll(1)
scan()
frames(6)
check('under: scrolled down, the panel goes up over the dot above', not dotAt(0.0, 1.25) and not dotAt(0.3, 1.0) and dotAt(1.5, 1.0))
T.nui('interact:painted', { seq = lastDui('show').seq, box = 'wide' })
scan()
frames(6)
check('under: a paint without a box keeps the last', not dotAt(0.0, 1.25) and dotAt(1.5, 1.0))
for _, id in ipairs(spheres) do as('tr_crypto', core.removeZone, core, id) end

-- The hint bar tells the interaction (modules/ui)
T.resource = 'tr_example'
T.boot('client', {})
T.fired = {}
TR.ui.hud.set({ hint = { text = 'Place it' } })
TR.ui.hud.set({ hint = { text = 'Place it again' } })
check('hud: says when it shows, once', T.count('tr:hud') == 1 and T.fired['tr:hud'][1][1] == 'tr_example' and T.fired['tr:hud'][1][2] == true)
TR.ui.hud.hide()
TR.ui.hud.hide()
check('hud: and when it hides, once', T.count('tr:hud') == 2 and T.fired['tr:hud'][2][2] == false)

T.done('interact')
