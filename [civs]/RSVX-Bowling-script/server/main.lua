local RES = GetCurrentResourceName()
local FULL = Physics.FULL

local defs = {}        -- lane definitions sent to clients, by id
local lanes = {}       -- live game state, by id
local saved = {}       -- lanes placed in game (data/lanes.json)
local screenEdits = {} -- screens moved in game (data/screens.json), keyed by lane position
local layout = { pairs = {}, panels = {}, cfg = {} } -- lane pairs, control panels, and in-game edits to config lanes (data/layout.json)
local playerLane = {}  -- src -> lane id

local function plain(v)
    return v and { x = v.x + 0.0, y = v.y + 0.0, z = v.z + 0.0 } or nil
end

local function newLane(id)
    return { id = id, status = 'idle', host = nil, players = {}, turn = 1, mask = FULL, busy = false, seq = 0, token = 0 }
end

local function public(lane)
    local players = {}
    for i, p in ipairs(lane.players) do
        local rolls = p.rolls
        -- Hold back the roll that is still travelling down the lane.
        if lane.busy and i == lane.turn and #rolls > 0 then
            rolls = { table.unpack(rolls, 1, #rolls - 1) }
        end
        players[i] = { src = p.src, name = p.name, rolls = rolls }
    end
    return {
        status = lane.status,
        host = lane.host,
        turn = lane.turn,
        mask = lane.mask,
        busy = lane.busy,
        seq = lane.seq,
        players = players,
        results = lane.results,
    }
end

local function push(lane)
    TriggerClientEvent('rsvx_bowling:lane', -1, lane.id, public(lane))
end

local function notifyLane(lane, text, kind)
    for _, p in ipairs(lane.players) do
        Framework.notify(p.src, text, kind)
    end
end

local function nearLane(src, id)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    local pos = GetEntityCoords(ped)
    local d = defs[id]
    if #(pos - vec3(d.coords.x, d.coords.y, d.coords.z)) <= Config.InteractRange then return true end
    if d.console and #(pos - vec3(d.console.x, d.console.y, d.console.z)) <= 3.0 then return true end
    return false
end

local function num(v, lo, hi)
    if type(v) ~= 'number' or v ~= v then return nil end
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

-- Lane ids shift when lanes are removed, so moved screens are filed under
-- the lane's position instead.
local function laneKey(d)
    return ('%.2f:%.2f:%.2f'):format(d.coords.x, d.coords.y, d.coords.z)
end

local function anyBusy()
    for _, lane in pairs(lanes) do
        if lane.status ~= 'idle' then return true end
    end
    return false
end

local function buildDefs()
    defs = {}
    for i, l in ipairs(Config.Lanes) do
        -- A config lane lined up in game keeps its adjustments in layout.cfg.
        local o = layout.cfg[tostring(i)] or {}
        defs[#defs + 1] = {
            cfgIndex = i,
            noScreen = l.screen == false,
            coords = o.coords or plain(l.coords),
            heading = o.heading or (l.heading + 0.0),
            length = o.length or l.length,
            pinScale = o.pinScale or l.pinScale,
            pinZ = o.pinZ or l.pinZ,
            console = plain(l.console),
            screen = l.screen and {
                coords = plain(l.screen.coords),
                heading = l.screen.heading + 0.0,
                width = l.screen.width or 1.6,
                height = l.screen.height or 0.8,
                tilt = l.screen.tilt or 0.0,
            } or nil,
        }
    end
    for i, l in ipairs(saved) do
        defs[#defs + 1] = {
            coords = l.coords, heading = l.heading, console = l.console, screen = l.screen, savedIndex = i,
            length = l.length, pinScale = l.pinScale, pinZ = l.pinZ,
        }
    end

    lanes, playerLane = {}, {}
    local byKey = {}
    for id, d in ipairs(defs) do
        d.id = id
        byKey[laneKey(d)] = d
        lanes[id] = newLane(id)
    end

    -- Pairs: the first lane owns the shared scoreboard and control panel.
    for _, d in ipairs(defs) do
        local partner = byKey[layout.pairs[laneKey(d)] or '']
        if partner and partner ~= d and not d.pairOwner and not partner.pairWith and not partner.pairOwner then
            d.pairWith = partner.id
            partner.pairOwner = d.id
        end
    end

    for _, d in ipairs(defs) do
        local key = laneKey(d)

        if d.pairOwner then
            d.screen = nil
        elseif screenEdits[key] then
            d.screen = screenEdits[key]
        elseif Config.Screens.auto and not d.screen and not d.noScreen then
            -- Default scoreboard: above the pins, facing back up the lane. For a
            -- pair it sits between the two lanes and is wide enough for both.
            local cfg = Config.Screens
            local h = math.rad(d.heading)
            local y = (d.length or Physics.HEAD) + cfg.setback
            local x, yy = d.coords.x - math.sin(h) * y, d.coords.y + math.cos(h) * y
            local width = cfg.width
            if d.pairWith then
                local p = defs[d.pairWith]
                x = x + (p.coords.x - d.coords.x) / 2
                yy = yy + (p.coords.y - d.coords.y) / 2
                width = cfg.pairWidth
            end
            d.screen = {
                coords = { x = x, y = yy, z = d.coords.z + cfg.height },
                heading = (d.heading + 180.0) % 360.0,
                width = width,
                height = cfg.tall,
                tilt = cfg.tilt or 0.0,
            }
        end

        -- A control panel is also where its lane (and partner) is booked from.
        d.panel = (not d.pairOwner) and layout.panels[key] or nil
        local panel = d.panel or (d.pairOwner and layout.panels[laneKey(defs[d.pairOwner])])
        if panel then d.console = panel.coords end
    end
end

local function allStates()
    local out = {}
    for id, lane in pairs(lanes) do out[id] = public(lane) end
    return out
end

local function loadSaved()
    local raw = LoadResourceFile(RES, 'data/lanes.json')
    saved = raw and json.decode(raw) or {}
    if type(saved) ~= 'table' then saved = {} end
end

local function loadScreens()
    local raw = LoadResourceFile(RES, 'data/screens.json')
    screenEdits = raw and json.decode(raw) or {}
    if type(screenEdits) ~= 'table' then screenEdits = {} end
end

local function writeScreens()
    SaveResourceFile(RES, 'data/screens.json', json.encode(screenEdits, { indent = true }), -1)
end

local function loadLayout()
    local raw = LoadResourceFile(RES, 'data/layout.json')
    local data = raw and json.decode(raw)
    if type(data) ~= 'table' then data = {} end
    layout = {
        pairs = type(data.pairs) == 'table' and data.pairs or {},
        panels = type(data.panels) == 'table' and data.panels or {},
        cfg = type(data.cfg) == 'table' and data.cfg or {},
    }
end

local function writeLayout()
    SaveResourceFile(RES, 'data/layout.json', json.encode(layout, { indent = true }), -1)
end

local function unpair(key)
    layout.pairs[key] = nil
    for k, v in pairs(layout.pairs) do
        if v == key then layout.pairs[k] = nil end
    end
end

local function rebuildAndSync()
    buildDefs()
    TriggerClientEvent('rsvx_bowling:lanes', -1, defs, allStates())
end

local function writeSaved()
    SaveResourceFile(RES, 'data/lanes.json', json.encode(saved, { indent = true }), -1)
end

loadSaved()
loadScreens()
loadLayout()
buildDefs()

lib.callback.register('rsvx_bowling:init', function()
    return defs, allStates()
end)

local advance, startTurn

local function resetLane(lane)
    for _, p in ipairs(lane.players) do playerLane[p.src] = nil end
    lane.status, lane.host, lane.players = 'idle', nil, {}
    lane.turn, lane.mask, lane.busy, lane.results = 1, FULL, false, nil
    lane.token = lane.token + 1
    push(lane)
end

local function endGame(lane)
    local results = {}
    for _, p in ipairs(lane.players) do
        local score = Scoring.total(p.rolls)
        results[#results + 1] = { name = p.name, score = score }
        Stats.record(p.cid, p.name, score, p.strikes)
    end
    table.sort(results, function(a, b) return a.score > b.score end)

    if #results > 1 then
        notifyLane(lane, L('winner', results[1].name, lane.id, results[1].score), 'success')
    elseif results[1] then
        notifyLane(lane, L('solo_done', results[1].score), 'success')
    end

    lane.status, lane.busy, lane.results, lane.mask = 'finished', false, results, FULL
    lane.token = lane.token + 1
    local token = lane.token
    push(lane)

    SetTimeout(Config.Timing.results * 1000, function()
        if lane.token == token and lanes[lane.id] == lane then resetLane(lane) end
    end)
end

-- Moves lane.turn on to the next player who still has frames left.
local function nextPlayer(lane)
    local n = #lane.players
    for k = 1, n do
        local idx = ((lane.turn - 1 + k) % n) + 1
        if not lane.players[idx].finished then
            lane.turn = idx
            return true
        end
    end
    return false
end

function startTurn(lane)
    lane.busy = false
    lane.token = lane.token + 1
    local token = lane.token
    push(lane)

    SetTimeout(Config.Timing.turn * 1000, function()
        if lane.token ~= token or lane.status ~= 'playing' or lane.busy then return end
        local p = lane.players[lane.turn]
        if not p then return end
        notifyLane(lane, L('missed_turn', p.name), 'warning')
        p.rolls[#p.rolls + 1] = 0
        advance(lane, lane.mask)
    end)
end

-- Called once a ball has finished: works out who bowls next and at what.
function advance(lane, after)
    local current = lane.players[lane.turn]
    local st = Scoring.next(current.rolls)
    current.finished = st.finished or false

    local pass = st.finished or st.ball == 1
    local currentLeft = current.left

    for i = #lane.players, 1, -1 do
        if lane.players[i].left then
            table.remove(lane.players, i)
            if i < lane.turn then lane.turn = lane.turn - 1 end
        end
    end
    if #lane.players == 0 then return resetLane(lane) end

    if currentLeft then
        lane.turn = lane.turn - 1
        pass = true
    end

    if pass then
        if not nextPlayer(lane) then return endGame(lane) end
        lane.mask = FULL
    else
        lane.mask = st.fresh and FULL or after
    end

    startTurn(lane)
end

local function leave(src, dropped)
    local id = playerLane[src]
    if not id then return end
    playerLane[src] = nil

    local lane = lanes[id]
    if not lane then return end

    local idx
    for i, p in ipairs(lane.players) do
        if p.src == src then idx = i break end
    end
    if not idx then return end
    local p = lane.players[idx]

    if lane.status == 'lobby' then
        if not dropped then Framework.refund(src, Config.Fee, 'bowling-refund') end
        table.remove(lane.players, idx)
        if #lane.players == 0 then return resetLane(lane) end
        if lane.host == src then lane.host = lane.players[1].src end
        notifyLane(lane, L('left', p.name))
        return push(lane)
    end

    if lane.status == 'finished' then return end

    -- Mid-game. If their ball is still rolling, tidy up when it stops.
    if lane.busy then
        p.left = true
        return
    end

    table.remove(lane.players, idx)
    if #lane.players == 0 then return resetLane(lane) end
    notifyLane(lane, L('left', p.name))

    if idx < lane.turn then
        lane.turn = lane.turn - 1
        push(lane)
    elseif idx == lane.turn then
        lane.turn = lane.turn - 1
        if not nextPlayer(lane) then return endGame(lane) end
        lane.mask = FULL
        startTurn(lane)
    else
        push(lane)
    end
end

local function seat(src, lane)
    local cid, name = Framework.identity(src)
    if not cid then return false end

    if not Framework.charge(src, Config.Fee, 'bowling') then
        Framework.notify(src, L('no_money', Config.Currency, Config.Fee), 'error')
        return false
    end
    if Config.Fee > 0 then Framework.notify(src, L('paid', Config.Currency, Config.Fee)) end

    lane.players[#lane.players + 1] = { src = src, cid = cid, name = name, rolls = {}, strikes = 0 }
    playerLane[src] = lane.id
    return true, name
end

RegisterNetEvent('rsvx_bowling:open', function(id)
    local src = source
    local lane = lanes[id]
    if not lane then return end
    if playerLane[src] then return Framework.notify(src, L('already_playing'), 'error') end
    if lane.status ~= 'idle' then return Framework.notify(src, L('lane_taken'), 'error') end
    if not nearLane(src, id) then return Framework.notify(src, L('too_far'), 'error') end

    if not seat(src, lane) then return end
    lane.status, lane.host = 'lobby', src
    Framework.notify(src, L('booked', id), 'success')
    push(lane)
end)

RegisterNetEvent('rsvx_bowling:join', function(id)
    local src = source
    local lane = lanes[id]
    if not lane or lane.status ~= 'lobby' then return end
    if playerLane[src] then return Framework.notify(src, L('already_playing'), 'error') end
    if #lane.players >= Config.MaxPlayers then return Framework.notify(src, L('lane_full'), 'error') end
    if not nearLane(src, id) then return Framework.notify(src, L('too_far'), 'error') end

    local ok, name = seat(src, lane)
    if not ok then return end
    notifyLane(lane, L('joined', name, id))
    push(lane)
end)

RegisterNetEvent('rsvx_bowling:start', function(id)
    local src = source
    local lane = lanes[id]
    if not lane or lane.status ~= 'lobby' then return end
    if lane.host ~= src then return Framework.notify(src, L('not_host'), 'error') end

    lane.status, lane.turn, lane.mask = 'playing', 1, FULL
    notifyLane(lane, L('started', lane.players[1].name), 'success')
    startTurn(lane)
end)

RegisterNetEvent('rsvx_bowling:leave', function()
    leave(source, false)
end)

AddEventHandler('playerDropped', function()
    leave(source, true)
end)

RegisterNetEvent('rsvx_bowling:throw', function(id, input)
    local src = source
    local lane = lanes[id]
    if not lane or lane.status ~= 'playing' or lane.busy then return end

    local p = lane.players[lane.turn]
    if not p or p.src ~= src then return end
    if type(input) ~= 'table' or not nearLane(src, id) then return end

    local cfg = Config.Throw
    local offset = num(input.offset, -cfg.maxOffset, cfg.maxOffset)
    local aim = num(input.aim, -1.0, 1.0)
    local power = num(input.power, 0.0, 1.0)
    local spin = num(input.spin, -1.0, 1.0)
    if not (offset and aim and power and spin) then return end

    local diff = Config.Difficulty
    aim = aim + (math.random() * 2 - 1) * diff.wobble
    offset = offset + (math.random() * 2 - 1) * diff.drift
    local angle = math.rad(aim * cfg.maxAngle)
    local speed = cfg.minSpeed + (cfg.maxSpeed - cfg.minSpeed) * power
    local throw = { x = offset, vx = speed * math.sin(angle), vy = speed * math.cos(angle), spin = spin }

    local before = lane.mask
    local sim = Physics.run(throw, before)
    local after = Physics.standing(sim)
    local knocked = Physics.count(before) - Physics.count(after)

    p.rolls[#p.rolls + 1] = knocked

    local label
    if after == 0 and before == FULL then
        label = L('strike')
        p.strikes = p.strikes + 1
    elseif after == 0 then
        label = L('spare')
    elseif knocked == 0 and sim.ball.gutter then
        label = L('gutter')
    else
        label = L('pins', knocked)
    end

    -- What the pinsetter should put down once this ball is cleared.
    local st = Scoring.next(p.rolls)
    local nextMask = (st.finished or st.ball == 1 or st.fresh) and FULL or after

    lane.busy = true
    lane.seq = lane.seq + 1
    lane.token = lane.token + 1

    TriggerClientEvent('rsvx_bowling:throw', -1, id, {
        seq = lane.seq,
        src = src,
        name = p.name,
        throw = throw,
        before = before,
        after = after,
        next = nextMask,
        label = label,
    })
    push(lane)

    SetTimeout(math.floor(sim.t * 1000) + Config.Timing.settle, function()
        if lanes[id] == lane and lane.status == 'playing' then advance(lane, after) end
    end)
end)

lib.addCommand(Config.AdminCommand, {
    help = 'Place or remove bowling lanes',
    restricted = 'group.admin',
    params = {
        { name = 'action', type = 'string', help = 'add | remove | edit | copy | list | preview | pair | unpair | screen | screenreset | panel | panelremove' },
        { name = 'value', type = 'number', help = 'lane count (add) or lane id', optional = true },
        { name = 'second', type = 'number', help = 'second lane id (pair, copy)', optional = true },
    },
}, function(source, args)
    if source == 0 then return end
    local action = args.action

    if action == 'preview' then
        return TriggerClientEvent('rsvx_bowling:preview', source)
    end

    if action == 'list' then
        for id, d in ipairs(defs) do
            Framework.notify(source, ('Lane %d: %.2f, %.2f, %.2f (h %.1f)%s'):format(
                id, d.coords.x, d.coords.y, d.coords.z, d.heading, d.savedIndex and '' or ' [config]'))
        end
        return
    end

    if action == 'edit' then
        local id = args.value and math.floor(args.value)
        if not id or not defs[id] then return Framework.notify(source, L('admin_no_lane'), 'error') end
        if anyBusy() then return Framework.notify(source, L('lane_taken'), 'error') end
        return TriggerClientEvent('rsvx_bowling:editLane', source, id)
    end

    if action == 'copy' then
        local from = args.value and defs[math.floor(args.value)]
        if not from then return Framework.notify(source, L('admin_no_lane'), 'error') end
        if anyBusy() then return Framework.notify(source, L('lane_taken'), 'error') end

        -- One target if a second id is given, otherwise every other lane.
        local targets = {}
        if args.second then
            local to = defs[math.floor(args.second)]
            if not to or to == from then return Framework.notify(source, L('admin_no_lane'), 'error') end
            targets[1] = to
        else
            for _, d in ipairs(defs) do
                if d ~= from then targets[#targets + 1] = d end
            end
        end

        -- Copies the direction and the pin setup. Each lane keeps its own position.
        for _, d in ipairs(targets) do
            if d.savedIndex then
                local l = saved[d.savedIndex]
                l.heading, l.length, l.pinScale, l.pinZ = from.heading, from.length, from.pinScale, from.pinZ
            else
                layout.cfg[tostring(d.cfgIndex)] = {
                    coords = d.coords, heading = from.heading,
                    length = from.length, pinScale = from.pinScale, pinZ = from.pinZ,
                }
            end
        end
        writeSaved()
        writeLayout()
        rebuildAndSync()
        return Framework.notify(source, L('admin_copied', from.id, #targets), 'success')
    end

    local displayActions = { pair = true, unpair = true, screen = true, screenreset = true, panel = true, panelremove = true }
    if displayActions[action] then
        local id = args.value and math.floor(args.value)
        local d = id and defs[id]
        if not d then return Framework.notify(source, L('admin_no_lane'), 'error') end

        -- A paired lane's displays belong to the first lane of the pair.
        local owner = d.pairOwner and defs[d.pairOwner] or d

        if action == 'screen' or action == 'panel' then
            return TriggerClientEvent('rsvx_bowling:editDisplay', source, owner.id, action)
        end

        -- Everything below changes the lane list, so no games may be running.
        if anyBusy() then return Framework.notify(source, L('lane_taken'), 'error') end

        if action == 'pair' then
            local other = args.second and defs[math.floor(args.second)]
            if not other or other == d then return Framework.notify(source, L('admin_pair_usage', Config.AdminCommand), 'error') end
            unpair(laneKey(d))
            unpair(laneKey(other))
            layout.pairs[laneKey(d)] = laneKey(other)
            -- The pair gets a fresh shared scoreboard between the two lanes.
            screenEdits[laneKey(d)], screenEdits[laneKey(other)] = nil, nil
            layout.panels[laneKey(other)] = nil
            writeScreens()
            writeLayout()
            rebuildAndSync()
            return Framework.notify(source, L('admin_paired', d.id, other.id), 'success')
        elseif action == 'unpair' then
            unpair(laneKey(d))
            screenEdits[laneKey(owner)] = nil
            writeScreens()
            writeLayout()
            rebuildAndSync()
            return Framework.notify(source, L('admin_unpaired', id), 'success')
        elseif action == 'screenreset' then
            screenEdits[laneKey(owner)] = nil
            writeScreens()
            rebuildAndSync()
            return Framework.notify(source, L('admin_screen_reset', owner.id), 'success')
        else
            layout.panels[laneKey(owner)] = nil
            writeLayout()
            rebuildAndSync()
            return Framework.notify(source, L('admin_panel_removed', owner.id), 'success')
        end
    end

    if action ~= 'add' and action ~= 'remove' then
        return Framework.notify(source, L('admin_usage', Config.AdminCommand))
    end
    if anyBusy() then return Framework.notify(source, L('lane_taken'), 'error') end

    if action == 'add' then
        local count = math.max(1, math.min(12, math.floor(args.value or 1)))
        -- Where the admin is standing becomes the foul line of the first lane;
        -- the rest are laid out to their right.
        local spot = lib.callback.await('rsvx_bowling:placement', source)
        if not spot then return end

        local h = math.rad(spot.h)
        local rx, ry = math.cos(h), math.sin(h)
        for i = 0, count - 1 do
            local off = i * Config.LaneSpacing
            saved[#saved + 1] = {
                coords = { x = spot.x + rx * off, y = spot.y + ry * off, z = spot.z },
                heading = spot.h,
            }
        end
        writeSaved()
        buildDefs()
        TriggerClientEvent('rsvx_bowling:lanes', -1, defs, allStates())
        Framework.notify(source, L('admin_added', count, #defs - count + 1), 'success')
    else
        local d = args.value and defs[math.floor(args.value)]
        if not d or not d.savedIndex then return Framework.notify(source, L('admin_missing'), 'error') end
        table.remove(saved, d.savedIndex)
        writeSaved()
        screenEdits[laneKey(d)] = nil
        layout.panels[laneKey(d)] = nil
        unpair(laneKey(d))
        writeScreens()
        writeLayout()
        buildDefs()
        TriggerClientEvent('rsvx_bowling:lanes', -1, defs, allStates())
        Framework.notify(source, L('admin_removed', math.floor(args.value)), 'success')
    end
end)

-- Sent by the in-game editor when the admin presses save.
RegisterNetEvent('rsvx_bowling:saveDisplay', function(id, kind, screen)
    local src = source
    if not IsPlayerAceAllowed(src, 'command.' .. Config.AdminCommand) then return end
    if kind ~= 'screen' and kind ~= 'panel' then return end

    local d = defs[id]
    if not d or d.pairOwner or type(screen) ~= 'table' then return end

    local x, y, z = num(screen.x, -10000.0, 10000.0), num(screen.y, -10000.0, 10000.0), num(screen.z, -500.0, 3000.0)
    local heading = num(screen.heading, -720.0, 720.0)
    local width, height = num(screen.width, 0.2, 8.0), num(screen.height, 0.1, 4.0)
    local tilt = num(screen.tilt or 0.0, -80.0, 80.0)
    if not (x and y and z and heading and width and height and tilt) then return end

    local def = { coords = { x = x, y = y, z = z }, heading = heading % 360.0, width = width, height = height, tilt = tilt }

    -- Displays don't affect play, so this goes out without touching any game in progress.
    if kind == 'screen' then
        screenEdits[laneKey(d)] = def
        writeScreens()
        d.screen = def
    else
        layout.panels[laneKey(d)] = def
        writeLayout()
        d.panel = def
        d.console = def.coords
        if d.pairWith then defs[d.pairWith].console = def.coords end
    end

    TriggerClientEvent('rsvx_bowling:display', -1, id, kind, def)
    Framework.notify(src, L(kind == 'screen' and 'admin_screen_saved' or 'admin_panel_saved', id), 'success')
end)

-- Sent by the in-game lane editor when the admin presses save.
RegisterNetEvent('rsvx_bowling:saveLane', function(id, data)
    local src = source
    if not IsPlayerAceAllowed(src, 'command.' .. Config.AdminCommand) then return end

    local d = defs[id]
    if not d or type(data) ~= 'table' then return end
    if anyBusy() then return Framework.notify(src, L('lane_taken'), 'error') end

    local x, y, z = num(data.x, -10000.0, 10000.0), num(data.y, -10000.0, 10000.0), num(data.z, -500.0, 3000.0)
    local heading = num(data.heading, -720.0, 720.0)
    local length, pinScale, pinZ = num(data.length, 5.0, 30.0), num(data.pinScale, 0.6, 1.6), num(data.pinZ, -0.5, 0.5)
    if not (x and y and z and heading and length and pinScale and pinZ) then return end

    local oldKey = laneKey(d)
    local edit = { coords = { x = x, y = y, z = z }, heading = heading % 360.0, length = length, pinScale = pinScale, pinZ = pinZ }

    if d.savedIndex then
        local l = saved[d.savedIndex]
        l.coords, l.heading, l.length, l.pinScale, l.pinZ = edit.coords, edit.heading, length, pinScale, pinZ
        writeSaved()
    else
        layout.cfg[tostring(d.cfgIndex)] = edit
    end

    -- Scoreboards, panels and pairings are filed under the lane's position, so
    -- carry them over to the new one.
    local newKey = laneKey(edit)
    if newKey ~= oldKey then
        screenEdits[newKey], screenEdits[oldKey] = screenEdits[oldKey], nil
        layout.panels[newKey], layout.panels[oldKey] = layout.panels[oldKey], nil
        layout.pairs[newKey], layout.pairs[oldKey] = layout.pairs[oldKey], nil
        for k, v in pairs(layout.pairs) do
            if v == oldKey then layout.pairs[k] = newKey end
        end
        writeScreens()
    end
    writeLayout()

    rebuildAndSync()
    Framework.notify(src, L('admin_lane_saved', id), 'success')
end)
