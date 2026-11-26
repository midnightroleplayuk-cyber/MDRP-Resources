-- Pinsetter and sweeper. After each ball the sweeper drops, the deck lifts
-- the pins still standing, the sweeper clears the dead wood into the pit, and
-- the deck sets down whatever the next ball is thrown at.
--
-- Purely visual: the server has already scored the ball. Both parts are drawn
-- as shaded boxes unless a prop model is set in Config.Machine.models.

Machine = {}

local HEAD = Physics.HEAD
local PARK_Y = HEAD - 0.55            -- sweeper rest position, just in front of the head pin
local PIT_Y = Physics.PIT_Y + 0.12
local SWEEP_UP, SWEEP_DOWN = 0.62, 0.10
local DECK_Y = HEAD + 0.396           -- middle of the pin triangle
local DECK_GRAB, DECK_UP = 0.43, 0.95

local SWEEP_SIZE = { x = 0.58, y = 0.025, z = 0.09 }  -- half extents
local DECK_SIZE = { x = 0.58, y = 0.54, z = 0.03 }

local function ease(u)
    return u * u * (3.0 - 2.0 * u)
end

local function lerp(a, b, u)
    return a + (b - a) * u
end

local function shade(c, k)
    return math.floor(c[1] * k), math.floor(c[2] * k), math.floor(c[3] * k)
end

local function quad(a, b, c, d, r, g, bl)
    -- Both windings so the face shows from either side.
    DrawPoly(a.x, a.y, a.z, b.x, b.y, b.z, c.x, c.y, c.z, r, g, bl, 255)
    DrawPoly(a.x, a.y, a.z, c.x, c.y, c.z, b.x, b.y, b.z, r, g, bl, 255)
    DrawPoly(a.x, a.y, a.z, c.x, c.y, c.z, d.x, d.y, d.z, r, g, bl, 255)
    DrawPoly(a.x, a.y, a.z, d.x, d.y, d.z, c.x, c.y, c.z, r, g, bl, 255)
end

local function box(lane, x, y, z, size, colour)
    local x0, x1 = x - size.x, x + size.x
    local y0, y1 = y - size.y, y + size.y
    local z0, z1 = z - size.z, z + size.z

    local a, b = LaneToWorld(lane, x0, y0, z0), LaneToWorld(lane, x1, y0, z0)
    local c, d = LaneToWorld(lane, x1, y1, z0), LaneToWorld(lane, x0, y1, z0)
    local e, f = LaneToWorld(lane, x0, y0, z1), LaneToWorld(lane, x1, y0, z1)
    local g, h = LaneToWorld(lane, x1, y1, z1), LaneToWorld(lane, x0, y1, z1)

    local r, gr, bl = shade(colour, 1.0)
    quad(e, f, g, h, r, gr, bl)          -- top
    r, gr, bl = shade(colour, 0.45)
    quad(a, b, c, d, r, gr, bl)          -- underside
    r, gr, bl = shade(colour, 0.8)
    quad(a, b, f, e, r, gr, bl)          -- face towards the bowler
    quad(d, c, g, h, r, gr, bl)          -- face towards the pit
    r, gr, bl = shade(colour, 0.62)
    quad(a, d, h, e, r, gr, bl)          -- left
    quad(b, c, g, f, r, gr, bl)          -- right
end

local function placeProp(obj, lane, x, y, z)
    local pos = LaneToWorld(lane, x, y, z)
    SetEntityCoordsNoOffset(obj, pos.x, pos.y, pos.z, false, false, false)
end

local function draw(lane, m)
    local cfg = Config.Machine
    if m.sweeperObj then
        placeProp(m.sweeperObj, lane, 0.0, m.sweepY, m.sweepZ)
    else
        box(lane, 0.0, m.sweepY, m.sweepZ, SWEEP_SIZE, cfg.sweeperColour)
    end

    if m.deckObj then
        placeProp(m.deckObj, lane, 0.0, DECK_Y, m.deckZ)
    else
        box(lane, 0.0, DECK_Y, m.deckZ, DECK_SIZE, cfg.deckColour)
    end
end

CreateThread(function()
    while true do
        local sleep = 500
        if Config.Machine.enabled then
            for id, loaded in pairs(Loaded) do
                local m, lane = loaded.machine, Lanes[id]
                if m and lane and (m.busy or Config.Machine.showParked) then
                    sleep = 0
                    draw(lane, m)
                end
            end
        end
        Wait(sleep)
    end
end)

local function spawnProp(model, lane)
    lib.requestModel(model)
    local obj = CreateObjectNoOffset(model, lane.coords.x, lane.coords.y, lane.coords.z, false, false, false)
    SetEntityHeading(obj, lane.heading)
    FreezeEntityPosition(obj, true)
    SetEntityCollision(obj, false, false)
    return obj
end

function Machine.attach(lane, loaded)
    if not Config.Machine.enabled then return end
    local models = Config.Machine.models
    loaded.machine = {
        sweepY = PARK_Y, sweepZ = SWEEP_UP, deckZ = DECK_UP, busy = false,
        sweeperObj = models.sweeper and spawnProp(models.sweeper, lane) or nil,
        deckObj = models.deck and spawnProp(models.deck, lane) or nil,
    }
end

function Machine.detach(loaded)
    local m = loaded.machine
    if not m then return end
    if m.sweeperObj and DoesEntityExist(m.sweeperObj) then DeleteEntity(m.sweeperObj) end
    if m.deckObj and DoesEntityExist(m.deckObj) then DeleteEntity(m.deckObj) end
    loaded.machine = nil
end

-- Back to rest, for when a new ball arrives before a cycle has finished.
function Machine.park(loaded)
    local m = loaded.machine
    if not m then return end
    m.sweepY, m.sweepZ, m.deckZ, m.busy = PARK_Y, SWEEP_UP, DECK_UP, false
end

local function tween(ms, alive, fn)
    local t0 = GetGameTimer()
    while true do
        if not alive() then return false end
        local u = (GetGameTimer() - t0) / ms
        if u >= 1.0 then
            fn(1.0)
            return true
        end
        fn(ease(u))
        Wait(0)
    end
end

local function liftPins(lane, loaded, mask, lift)
    for i = 1, 10 do
        local obj = loaded.pins[i]
        if obj and mask & (1 << (i - 1)) ~= 0 and DoesEntityExist(obj) then
            local spot = Physics.spots[i]
            local pos = LaneToWorld(lane, spot.x, spot.y, PinBase(lane) + lift)
            SetEntityCoordsNoOffset(obj, pos.x, pos.y, pos.z, false, false, false)
        end
    end
end

---@param sim table finished simulation, for where the fallen pins ended up
---@param after integer pins left standing
---@param nextMask integer pins the next ball is thrown at
---@param alive fun(): boolean false once this cycle should be abandoned
---@return boolean finished
function Machine.cycle(id, lane, loaded, sim, after, nextMask, alive)
    local m = loaded.machine
    if not m then return true end

    local t = Config.Machine.timing
    m.busy = true

    -- Dead wood: fallen pins that are still on the deck.
    local dead = {}
    for i = 1, 10 do
        local p, obj = sim.pins[i], loaded.pins[i]
        if p and obj and after & (1 << (i - 1)) == 0 and DoesEntityExist(obj) then
            if p.gone or p.y < PARK_Y + 0.1 then
                SetEntityVisible(obj, false, false)
            else
                dead[#dead + 1] = { obj = obj, x = p.x, y = p.y }
            end
        end
    end

    if not tween(t.sweeperDrop, alive, function(u) m.sweepZ = lerp(SWEEP_UP, SWEEP_DOWN, u) end) then return false end

    if not tween(t.deckMove, alive, function(u) m.deckZ = lerp(DECK_UP, DECK_GRAB, u) end) then return false end
    for i = 1, 10 do
        local obj = loaded.pins[i]
        if obj and after & (1 << (i - 1)) ~= 0 and DoesEntityExist(obj) then
            SetEntityRotation(obj, 0.0, 0.0, lane.heading, 2, true)
        end
    end
    if not tween(t.deckMove, alive, function(u)
        m.deckZ = lerp(DECK_GRAB, DECK_UP, u)
        liftPins(lane, loaded, after, m.deckZ - DECK_GRAB)
    end) then return false end

    local z = PinBase(lane) + Physics.PIN_R
    if not tween(t.sweep, alive, function(u)
        m.sweepY = lerp(PARK_Y, PIT_Y, u)
        for _, d in ipairs(dead) do
            if not d.done then
                local edge = m.sweepY + 0.09
                if d.y < edge then d.y = edge end
                if d.y > Physics.PIT_Y then
                    d.done = true
                    SetEntityVisible(d.obj, false, false)
                else
                    local pos = LaneToWorld(lane, d.x, d.y, z)
                    SetEntityCoordsNoOffset(d.obj, pos.x, pos.y, pos.z, false, false, false)
                end
            end
        end
    end) then return false end

    if not tween(t.sweepReturn, alive, function(u) m.sweepY = lerp(PIT_Y, PARK_Y, u) end) then return false end

    -- Deck sets down the next rack: the same pins for a second ball, or a full ten.
    SetRack(id, nextMask)
    liftPins(lane, loaded, nextMask, DECK_UP - DECK_GRAB)
    if not tween(t.deckMove, alive, function(u)
        m.deckZ = lerp(DECK_UP, DECK_GRAB, u)
        liftPins(lane, loaded, nextMask, m.deckZ - DECK_GRAB)
    end) then return false end

    if not tween(t.deckMove, alive, function(u) m.deckZ = lerp(DECK_GRAB, DECK_UP, u) end) then return false end
    if not tween(t.sweeperDrop, alive, function(u) m.sweepZ = lerp(SWEEP_DOWN, SWEEP_UP, u) end) then return false end

    m.busy = false
    return true
end
