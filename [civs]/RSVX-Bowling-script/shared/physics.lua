-- Top-down lane simulation. Runs on the server to decide the result and on
-- every nearby client to draw it, so it must stay deterministic: fixed step,
-- no trig, no randomness in here.
--
-- Lane space: x is across the lane (negative = bowler's left), y runs from
-- the foul line (0) towards the pins. Units are metres.

Physics = {}
local P = Physics
local sqrt, abs = math.sqrt, math.abs

P.DT = 1 / 60
local SUB = 4
local H = P.DT / SUB

P.LANE_HALF = 0.5334
P.HEAD = 18.288
P.BALL_R = 0.1085
P.PIN_R = 0.0605

local SPACING = 0.3048
local ROW = 0.26396
-- A toppled pin sweeps a wider path than a standing one. This is the main
-- difficulty dial: bigger means more pins carried and more strikes.
local DOWN_R = (Config.Difficulty and Config.Difficulty.carry) or 0.09
local BALL_M, PIN_M = 6.8, 1.6
local WALL_X = 0.80
local PIT_Y = 19.9
local GUTTER_X = 0.65
local HOOK, HOOK_START = 1.1, 7.0
local BALL_FRIC, PIN_FRIC = 0.25, 2.5
local E_BALL, E_PIN, E_WALL = 0.7, 0.75, 0.45
local TOPPLE_SPEED, TOPPLE_DIST = 0.8, 0.04

P.PIT_Y = PIT_Y

-- Pin spots, standard numbering: 1 is the head pin, 7-10 the back row left to right.
P.spots = {}
for r = 0, 3 do
    for i = 0, r do
        P.spots[#P.spots + 1] = { x = (i - r / 2) * SPACING, y = P.HEAD + r * ROW }
    end
end

P.FULL = 1023

function P.count(mask)
    local c = 0
    while mask ~= 0 do
        c = c + (mask & 1)
        mask = mask >> 1
    end
    return c
end

---@param throw { x: number, vx: number, vy: number, spin: number }
---@param mask integer standing pins, bit 0 = pin 1
function P.new(throw, mask)
    local s = {
        t = 0,
        done = false,
        impact = 0,
        ball = { x = throw.x, y = 0, vx = throw.vx, vy = throw.vy, spin = throw.spin, gutter = false, gone = false },
        pins = {},
    }
    for i = 1, 10 do
        if mask & (1 << (i - 1)) ~= 0 then
            local sp = P.spots[i]
            s.pins[i] = { x = sp.x, y = sp.y, ox = sp.x, oy = sp.y, vx = 0, vy = 0, down = false, gone = false, fx = 0, fy = 1 }
        else
            s.pins[i] = false
        end
    end
    return s
end

local function collide(a, b, ra, rb, ma, mb, e, s)
    local dx, dy = b.x - a.x, b.y - a.y
    local d2 = dx * dx + dy * dy
    local r = ra + rb
    if d2 >= r * r or d2 == 0 then return end

    local d = sqrt(d2)
    local nx, ny = dx / d, dy / d
    local ima, imb = 1 / ma, 1 / mb

    local pen = (r - d) / (ima + imb)
    a.x = a.x - nx * pen * ima
    a.y = a.y - ny * pen * ima
    b.x = b.x + nx * pen * imb
    b.y = b.y + ny * pen * imb

    local vn = (b.vx - a.vx) * nx + (b.vy - a.vy) * ny
    if vn < 0 then
        local j = -(1 + e) * vn / (ima + imb)
        a.vx = a.vx - j * nx * ima
        a.vy = a.vy - j * ny * ima
        b.vx = b.vx + j * nx * imb
        b.vy = b.vy + j * ny * imb
        if j > s.impact then s.impact = j end
    end
end

local function substep(s)
    local b = s.ball

    if not b.gone then
        if not b.gutter then
            local ramp = (b.y - HOOK_START) / (P.HEAD - HOOK_START)
            if ramp < 0 then ramp = 0 elseif ramp > 1 then ramp = 1 end
            b.vx = b.vx + b.spin * HOOK * ramp * H
        end

        local sp = sqrt(b.vx * b.vx + b.vy * b.vy)
        if sp > 0 then
            local ns = sp - BALL_FRIC * H
            if ns < 0 then ns = 0 end
            local k = ns / sp
            b.vx = b.vx * k
            b.vy = b.vy * k
            sp = ns
        end

        b.x = b.x + b.vx * H
        b.y = b.y + b.vy * H

        if not b.gutter and abs(b.x) > P.LANE_HALF then
            b.gutter = true
            b.x = b.x > 0 and GUTTER_X or -GUTTER_X
            b.vx = 0
            if b.vy < 1.5 then b.vy = 1.5 end
        end

        if b.y > PIT_Y or b.y < -1 or sp < 0.25 then b.gone = true end
    end

    for i = 1, 10 do
        local p = s.pins[i]
        if p and not p.gone then
            local sp2 = p.vx * p.vx + p.vy * p.vy
            if sp2 > 0 then
                local sp = sqrt(sp2)
                if not p.down and sp > TOPPLE_SPEED then
                    p.down = true
                    p.fx, p.fy = p.vx / sp, p.vy / sp
                end

                local ns = sp - PIN_FRIC * H
                if ns < 0 then ns = 0 end
                local k = ns / sp
                p.vx = p.vx * k
                p.vy = p.vy * k
                p.x = p.x + p.vx * H
                p.y = p.y + p.vy * H

                local lim = WALL_X - P.PIN_R
                if p.x > lim then
                    p.x = lim
                    p.vx = -p.vx * E_WALL
                elseif p.x < -lim then
                    p.x = -lim
                    p.vx = -p.vx * E_WALL
                end

                if p.y > PIT_Y then
                    p.gone = true
                    p.down = true
                end

                if not p.down then
                    local dx, dy = p.x - p.ox, p.y - p.oy
                    if dx * dx + dy * dy > TOPPLE_DIST * TOPPLE_DIST or abs(p.x) > P.LANE_HALF then
                        p.down = true
                        p.fx, p.fy = 0, 1
                    end
                end
            end
        end
    end

    if not b.gone and not b.gutter then
        for i = 1, 10 do
            local p = s.pins[i]
            if p and not p.gone then
                collide(b, p, P.BALL_R, P.PIN_R, BALL_M, PIN_M, E_BALL, s)
            end
        end
    end

    for i = 1, 10 do
        local a = s.pins[i]
        if a and not a.gone then
            for j = i + 1, 10 do
                local q = s.pins[j]
                if q and not q.gone then
                    collide(a, q, a.down and DOWN_R or P.PIN_R, q.down and DOWN_R or P.PIN_R, PIN_M, PIN_M, E_PIN, s)
                end
            end
        end
    end
end

-- Advance one 60 Hz frame. s.impact holds the hardest hit of the frame (for sound).
function P.step(s)
    s.impact = 0
    for _ = 1, SUB do substep(s) end
    s.t = s.t + P.DT

    if s.t > 12 then
        s.done = true
    elseif s.ball.gone then
        local moving = false
        for i = 1, 10 do
            local p = s.pins[i]
            if p and not p.gone and p.vx * p.vx + p.vy * p.vy > 0.0025 then
                moving = true
                break
            end
        end
        if not moving then s.done = true end
    end
end

-- Pins still standing, as a mask.
function P.standing(s)
    local m = 0
    for i = 1, 10 do
        local p = s.pins[i]
        if p and not p.down then m = m | (1 << (i - 1)) end
    end
    return m
end

function P.run(throw, mask)
    local s = P.new(throw, mask)
    while not s.done do P.step(s) end
    return s
end
