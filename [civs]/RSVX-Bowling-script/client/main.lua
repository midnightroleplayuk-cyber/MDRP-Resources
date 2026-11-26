Lanes = {}     -- lane definitions from the server, by id
State = {}     -- live game state, by id
Loaded = {}    -- lanes close enough to have props: [id] = { pins = {}, replaying = bool }
MyLane = nil   -- lane the local player is seated on
Watching = nil -- lane whose scores the player chose to watch

local points, zones = {}, {}
local wasMyTurn = false
local promptShown = false

-- The simulation always runs on a regulation lane. Real MLO lanes vary a
-- little, so each lane can have its own length (foul line to head pin) and
-- pin spacing; this stretches simulation space to fit. Sideways scaling only
-- fades in over the last 1.5 m so the ball's line down the lane is untouched.
local HEAD = Physics.HEAD

local function fit(lane, x, y)
    local length, scale = lane.length or HEAD, lane.pinScale or 1.0
    if y > HEAD then
        return x * scale, length + (y - HEAD) * scale
    end
    local k = (y - (HEAD - 1.5)) / 1.5
    if k < 0.0 then k = 0.0 end
    return x * (1.0 + (scale - 1.0) * k), y * length / HEAD
end

-- Height of a pin's origin above the lane's foul-line level.
function PinBase(lane)
    return Config.Props.pinZ + (lane.pinZ or 0.0)
end

function OrientLane(lane)
    local h = math.rad(lane.heading)
    lane.fx, lane.fy = -math.sin(h), math.cos(h)
    lane.rx, lane.ry = math.cos(h), math.sin(h)
end

-- Lane-local position (x across, y down the lane, z above the surface) to world.
function LaneToWorld(lane, x, y, z)
    x, y = fit(lane, x, y)
    return vec3(
        lane.coords.x + lane.rx * x + lane.fx * y,
        lane.coords.y + lane.ry * x + lane.fy * y,
        lane.coords.z + (z or 0.0)
    )
end

local function prepare(def)
    def.coords = vec3(def.coords.x, def.coords.y, def.coords.z)
    OrientLane(def)
    def.console = def.console and vec3(def.console.x, def.console.y, def.console.z)
        or LaneToWorld(def, 0.95, -4.5, 1.0)
    return def
end

function IsMyTurn(id)
    local st = State[id]
    if not st or st.status ~= 'playing' or st.busy then return false end
    local p = st.players[st.turn]
    return p ~= nil and p.src == cache.serverId
end

local function spawnPin(lane, i)
    lib.requestModel(Config.Props.pin)
    local spot = Physics.spots[i]
    local pos = LaneToWorld(lane, spot.x, spot.y, PinBase(lane))
    local obj = CreateObjectNoOffset(Config.Props.pin, pos.x, pos.y, pos.z, false, false, false)
    SetEntityHeading(obj, lane.heading)
    FreezeEntityPosition(obj, true)
    SetEntityCollision(obj, false, false)
    return obj
end

function SetRack(id, mask)
    local loaded, lane = Loaded[id], Lanes[id]
    if not loaded or not lane then return end

    for i = 1, 10 do
        local want = mask & (1 << (i - 1)) ~= 0
        local obj = loaded.pins[i]
        if want then
            if obj and DoesEntityExist(obj) then
                local spot = Physics.spots[i]
                local pos = LaneToWorld(lane, spot.x, spot.y, PinBase(lane))
                SetEntityCoordsNoOffset(obj, pos.x, pos.y, pos.z, false, false, false)
                SetEntityRotation(obj, 0.0, 0.0, lane.heading, 2, true)
                SetEntityVisible(obj, true, false)
            else
                loaded.pins[i] = spawnPin(lane, i)
            end
        elseif obj then
            if DoesEntityExist(obj) then DeleteEntity(obj) end
            loaded.pins[i] = nil
        end
    end
end

local function unload(id)
    local loaded = Loaded[id]
    if not loaded then return end
    for i = 1, 10 do
        local obj = loaded.pins[i]
        if obj and DoesEntityExist(obj) then DeleteEntity(obj) end
    end
    if loaded.ball and DoesEntityExist(loaded.ball) then DeleteEntity(loaded.ball) end
    Machine.detach(loaded)
    Loaded[id] = nil
    Screen.remove('s' .. id)
    Screen.remove('p' .. id)
end

local function sheetFor(id)
    local st = State[id]
    if not st or st.status == 'idle' then return nil end

    local rows = {}
    for i, p in ipairs(st.players) do
        local frames, total = Scoring.sheet(p.rolls)
        rows[i] = { name = p.name, frames = frames, total = total, active = st.status == 'playing' and i == st.turn }
    end
    return { lane = id, status = st.status, rows = rows, results = st.results }
end

local function panelFor(id)
    local st = State[id]
    local pane = { lane = id, status = st and st.status or 'idle' }

    if pane.status == 'idle' then
        pane.offer = Config.Fee > 0 and ('Book here  %s%d'):format(Config.Currency, Config.Fee) or 'Book here'
    elseif pane.status == 'lobby' then
        pane.count = #st.players
    elseif pane.status == 'playing' then
        local p = st.players[st.turn]
        if p then
            local at = Scoring.next(p.rolls)
            pane.now = { name = p.name, frame = at.frame, ball = at.ball, total = Scoring.total(p.rolls) }
        end
    elseif pane.status == 'finished' and st.results then
        pane.winner = st.results[1]
    end
    return pane
end

-- A paired lane shares the displays of the lane it is paired to.
function RefreshDisplays(id)
    local lane = Lanes[id]
    if not lane then return end

    local owner = lane.pairOwner or id
    local ownerLane = Lanes[owner]
    if not ownerLane then return end

    local ids = { owner }
    if ownerLane.pairWith and Lanes[ownerLane.pairWith] then ids[2] = ownerLane.pairWith end

    local boards, panels = {}, {}
    for i, laneId in ipairs(ids) do
        boards[i] = { lane = laneId, board = sheetFor(laneId) }
        panels[i] = panelFor(laneId)
    end

    Screen.send('s' .. owner, { type = 'panes', panes = boards })
    Screen.send('p' .. owner, { type = 'panes', panes = panels })
end

local function refreshBoard()
    local id = MyLane or Watching
    SendNUIMessage({ type = 'board', board = id and sheetFor(id) or nil })
end

local function findMyLane()
    for id, st in pairs(State) do
        for _, p in ipairs(st.players) do
            if p.src == cache.serverId then return id end
        end
    end
    return nil
end

local function applyState(id, st)
    State[id] = st

    local loaded = Loaded[id]
    if loaded and not loaded.replaying then SetRack(id, st.mask) end

    MyLane = findMyLane()
    if Watching and (not State[Watching] or State[Watching].status == 'idle') then Watching = nil end

    local mine = MyLane ~= nil and IsMyTurn(MyLane)
    if mine and not wasMyTurn then
        lib.notify({ title = 'Bowling', description = L('your_turn'), type = 'inform' })
    end
    wasMyTurn = mine

    refreshBoard()
    RefreshDisplays(id)
end

RegisterNetEvent('rsvx_bowling:lane', function(id, st)
    if not Lanes[id] then return end
    applyState(id, st)
end)

local function showLeaderboard()
    local rows = lib.callback.await('rsvx_bowling:leaderboard', false)
    local options = {}
    if #rows == 0 then
        options[1] = { title = L('board_empty'), readOnly = true }
    end
    for i, r in ipairs(rows) do
        options[#options + 1] = {
            title = ('%d. %s'):format(i, r.name),
            description = L('board_row', r.best, r.games, r.strikes),
            readOnly = true,
        }
    end
    lib.registerContext({ id = 'rsvx_bowling_board', title = L('board_title'), options = options })
    lib.showContext('rsvx_bowling_board')
end

local function status(id)
    return State[id] and State[id].status or 'idle'
end

local function addConsole(id, lane)
    -- Paired lanes share one control panel, so every option names its lane.
    local function label(text) return ('Lane %d: %s'):format(id, text) end
    local openLabel = label(Config.Fee > 0 and L('target_open', Config.Currency, Config.Fee) or L('target_open_free'))
    if zones[id] then exports.ox_target:removeZone(zones[id]) end
    zones[id] = exports.ox_target:addSphereZone({
        coords = lane.console,
        radius = 0.7,
        debug = false,
        options = {
            {
                name = 'rsvx_bowling_open_' .. id, icon = 'fa-solid fa-bowling-ball', label = openLabel, distance = 2.5,
                canInteract = function() return status(id) == 'idle' and not MyLane end,
                onSelect = function() TriggerServerEvent('rsvx_bowling:open', id) end,
            },
            {
                name = 'rsvx_bowling_join_' .. id, icon = 'fa-solid fa-user-plus', label = label(L('target_join')), distance = 2.5,
                canInteract = function() return status(id) == 'lobby' and not MyLane end,
                onSelect = function() TriggerServerEvent('rsvx_bowling:join', id) end,
            },
            {
                name = 'rsvx_bowling_start_' .. id, icon = 'fa-solid fa-play', label = label(L('target_start')), distance = 2.5,
                canInteract = function() return status(id) == 'lobby' and State[id].host == cache.serverId end,
                onSelect = function() TriggerServerEvent('rsvx_bowling:start', id) end,
            },
            {
                name = 'rsvx_bowling_leave_' .. id, icon = 'fa-solid fa-right-from-bracket', label = label(L('target_leave')), distance = 2.5,
                canInteract = function() return MyLane == id and status(id) ~= 'finished' end,
                onSelect = function()
                    Throw.cancel()
                    TriggerServerEvent('rsvx_bowling:leave')
                end,
            },
            {
                name = 'rsvx_bowling_watch_' .. id, icon = 'fa-solid fa-table-list', label = label(L('target_watch')), distance = 2.5,
                canInteract = function() return status(id) ~= 'idle' and MyLane ~= id end,
                onSelect = function()
                    Watching = Watching ~= id and id or nil
                    refreshBoard()
                end,
            },
            {
                name = 'rsvx_bowling_board_' .. id, icon = 'fa-solid fa-trophy', label = label(L('target_board')), distance = 2.5,
                onSelect = showLeaderboard,
            },
        },
    })
end

local function teardown()
    Throw.cancel()
    for id in pairs(Loaded) do unload(id) end
    for _, point in pairs(points) do point:remove() end
    for _, zone in pairs(zones) do exports.ox_target:removeZone(zone) end
    points, zones = {}, {}
    Lanes, State, MyLane, Watching = {}, {}, nil, nil
    SendNUIMessage({ type = 'board', board = nil })
end

local function setup(defs, states)
    teardown()

    for id, def in pairs(defs) do
        local lane = prepare(def)
        Lanes[id] = lane
        State[id] = states[id]

        addConsole(id, lane)

        local point = lib.points.new({ coords = lane.coords, distance = Config.RenderDistance })
        function point:onEnter()
            Loaded[id] = { pins = {}, replaying = false }
            Machine.attach(lane, Loaded[id])
            SetRack(id, State[id] and State[id].mask or Physics.FULL)
            if lane.screen then Screen.create('s' .. id, lane.screen, 'screen') end
            if lane.panel then Screen.create('p' .. id, lane.panel, 'panel') end
            RefreshDisplays(id)
        end
        function point:onExit()
            unload(id)
        end
        points[id] = point
    end

    MyLane = findMyLane()
    refreshBoard()
end

RegisterNetEvent('rsvx_bowling:lanes', setup)

-- A scoreboard or control panel was moved in game.
RegisterNetEvent('rsvx_bowling:display', function(id, kind, def)
    local lane = Lanes[id]
    if not lane then return end

    if kind == 'panel' then
        lane.panel = def
        -- The panel is where the lane (and its partner) is booked from.
        local spot = vec3(def.coords.x, def.coords.y, def.coords.z)
        for _, laneId in ipairs({ id, lane.pairWith }) do
            local l = Lanes[laneId]
            if l then
                l.console = spot
                addConsole(laneId, l)
            end
        end
    else
        lane.screen = def
    end

    if Loaded[id] then
        Screen.apply((kind == 'panel' and 'p' or 's') .. id, def, kind)
        RefreshDisplays(id)
    end
end)

CreateThread(function()
    -- Give the server side a moment on resource restart.
    Wait(500)
    local defs, states = lib.callback.await('rsvx_bowling:init', false)
    if defs then setup(defs, states) end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then teardown() end
end)

CreateThread(function()
    while true do
        local sleep = 500
        local show = false

        if MyLane and not Throw.active and IsMyTurn(MyLane) then
            local lane = Lanes[MyLane]
            local spot = LaneToWorld(lane, 0.0, -1.0, 1.0)
            if #(GetEntityCoords(cache.ped) - spot) < 2.5 then
                sleep = 0
                show = true
                if IsControlJustReleased(0, 38) then
                    show = false
                    Throw.begin(MyLane)
                end
            end
        end

        if show and not promptShown then
            lib.showTextUI(L('pickup'))
            promptShown = true
        elseif not show and promptShown then
            lib.hideTextUI()
            promptShown = false
        end

        Wait(sleep)
    end
end)
