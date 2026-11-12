Cam = {}

local cam
local cur = { pos = vec3(0, 0, 0), rot = vec3(0, 0, 0), fov = 40.0 }
local job
local dof = { enabled = false, strength = 0.7, focus = nil }
local running = false
local lastFocus = 0

-- Maths ---------------------------------------------------------------------------------
local function lerp(a, b, t) return a + (b - a) * t end

local function angDelta(a, b) return (b - a + 180.0) % 360.0 - 180.0 end

-- returns b rewritten so every axis is the shortest turn away from a
local function unwrap(a, b)
    return vec3(a.x + angDelta(a.x, b.x), a.y + angDelta(a.y, b.y), a.z + angDelta(a.z, b.z))
end

local function catmull(p0, p1, p2, p3, t)
    local t2, t3 = t * t, t * t * t
    return (p1 * 2.0 + (p2 - p0) * t + (p0 * 2.0 - p1 * 5.0 + p2 * 4.0 - p3) * t2 + (p1 * 3.0 - p0 - p2 * 3.0 + p3) * t3) * 0.5
end

local function catmull1(a, b, c, d, t)
    local t2, t3 = t * t, t * t * t
    return 0.5 * (2 * b + (c - a) * t + (2 * a - 5 * b + 4 * c - d) * t2 + (3 * b - a - 3 * c + d) * t3)
end

function Cam.ToVec(t)
    if not t then return vec3(0, 0, 0) end
    if type(t) == 'vector3' then return t end
    return vec3(t.x + 0.0, t.y + 0.0, t.z + 0.0)
end
local V = Cam.ToVec

function Cam.LookRot(from, to)
    local d = to - from
    local pitch = math.deg(math.atan(d.z, math.sqrt(d.x * d.x + d.y * d.y)))
    local yaw = -math.deg(math.atan(d.x, d.y))
    return vec3(pitch, 0.0, yaw)
end

function Cam.RotToDir(rot)
    local z, x = math.rad(rot.z), math.rad(rot.x)
    local n = math.abs(math.cos(x))
    return vec3(-math.sin(z) * n, math.cos(z) * n, math.sin(x))
end

-- Apply ---------------------------------------------------------------------------------
local function apply()
    if not cam then return end
    SetCamCoord(cam, cur.pos.x, cur.pos.y, cur.pos.z)
    SetCamRot(cam, cur.rot.x, cur.rot.y, cur.rot.z, 2)
    SetCamFov(cam, cur.fov)
end

local function applyDof()
    if not cam or not dof.enabled or not dof.focus then return end
    SetUseHiDof()
    local d = #(cur.pos - dof.focus)
    SetCamNearDof(cam, math.max(0.05, d - 1.1))
    SetCamFarDof(cam, d + 1.8)
    SetCamDofStrength(cam, dof.strength)
end

-- Jobs ----------------------------------------------------------------------------------
local function stepTween(j, now)
    local t = j.dur <= 0 and 1.0 or math.min(1.0, (now - j.start) / j.dur)
    local e = j.ease(t)
    cur.pos = lerp(j.from.pos, j.to.pos, e)
    cur.rot = lerp(j.from.rot, j.to.rot, e)
    cur.fov = lerp(j.from.fov, j.to.fov, e)
    return t >= 1.0
end

-- Sample the spline between point i and i+1 at local t (0..1)
local function samplePath(p, i, t)
    local a, b = p[math.max(1, i - 1)], p[i]
    local c, d = p[i + 1], p[math.min(#p, i + 2)]
    local pos = catmull(a.pos, b.pos, c.pos, d.pos, t)
    local fov = catmull1(a.fov, b.fov, c.fov, d.fov, t)
    local rot
    if b.aim or c.aim then
        -- tracking: point the camera at a moving/blended target so orbits and reveals stay locked on
        local roll = lerp(b.rot.y, c.rot.y, t)
        if b.aim and c.aim then
            rot = Cam.LookRot(pos, lerp(b.aim, c.aim, t))
        else
            local rb = b.aim and Cam.LookRot(pos, b.aim) or b.rot
            local rc = c.aim and Cam.LookRot(pos, c.aim) or c.rot
            rot = lerp(rb, unwrap(rb, rc), t)
        end
        rot = vec3(rot.x, roll, rot.z)
    else
        rot = catmull(a.rot, b.rot, c.rot, d.rot, t)
    end
    return pos, rot, fov
end

local function stepPath(j, now)
    local elapsed = now - j.start
    local p = j.points
    for _, run in ipairs(j.runs) do
        if elapsed <= run.dur then
            if run.kind == 'hold' then
                cur.pos, cur.rot, cur.fov = samplePath(p, math.min(run.i, #p - 1), run.i >= #p and 1.0 or 0.0)
                return false
            end
            -- one easing curve across the whole run, so the camera never stops at keyframes inside it
            local u = run.dur <= 0 and 1.0 or run.ease(elapsed / run.dur)
            local tAt = u * run.dur
            for _, seg in ipairs(run.segs) do
                if tAt <= seg.dur or seg == run.segs[#run.segs] then
                    local t = seg.dur <= 0 and 1.0 or math.min(1.0, tAt / seg.dur)
                    cur.pos, cur.rot, cur.fov = samplePath(p, seg.i, t)
                    return false
                end
                tAt = tAt - seg.dur
            end
        end
        elapsed = elapsed - run.dur
    end
    cur.pos, cur.rot, cur.fov = samplePath(p, #p - 1, 1.0)
    return true
end

local function loop()
    if running then return end
    running = true
    CreateThread(function()
        while cam do
            local now = GetGameTimer()
            if job then
                local done
                if job.kind == 'tween' then done = stepTween(job, now) else done = stepPath(job, now) end
                apply()
                if now - lastFocus > 400 then
                    SetFocusPosAndVel(cur.pos.x, cur.pos.y, cur.pos.z, 0.0, 0.0, 0.0)
                    lastFocus = now
                end
                if done then
                    local cb = job.cb
                    job = nil
                    if cb then cb() end
                end
            end
            applyDof()
            Wait(0)
        end
        running = false
    end)
end

-- Public API ------------------------------------------------------------------------------
function Cam.Create(pos, rot, fov)
    if cam then return cam end
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    cur.pos = pos and V(pos) or GetGameplayCamCoord()
    cur.rot = rot and V(rot) or GetGameplayCamRot(2)
    cur.fov = fov or Config.Camera.Fov
    apply()
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
    loop()
    return cam
end

function Cam.Exists() return cam ~= nil end

function Cam.Get() return { pos = cur.pos, rot = cur.rot, fov = cur.fov } end

function Cam.Set(pos, rot, fov)
    job = nil
    cur.pos, cur.rot, cur.fov = V(pos), V(rot), fov or cur.fov
    apply()
end

function Cam.Stop() job = nil end

function Cam.IsBusy() return job ~= nil end

-- Tween to a target { pos, rot, fov }
function Cam.TweenTo(target, duration, easeName, cb)
    local from = { pos = cur.pos, rot = cur.rot, fov = cur.fov }
    local to = { pos = V(target.pos), rot = unwrap(cur.rot, V(target.rot)), fov = target.fov or cur.fov }
    job = { kind = 'tween', from = from, to = to, dur = duration or Config.Camera.Transition, ease = VMC.GetEase(easeName), start = GetGameTimer(), cb = cb }
end

-- Play a keyframe path.
-- frames = { { pos, rot, fov, duration, hold, ease, aim = vec3|nil }, ... }
-- opts   = { fromCurrent = bool, flow = bool, ease = 'easeInOutSine' }
--   flow:   one easing curve per run of keyframes, no stopping at each keyframe (holds still pause)
--   normal: each keyframe eases in and out on its own
function Cam.PlayPath(frames, cb, opts)
    if type(opts) ~= 'table' then opts = { fromCurrent = opts == true } end
    if not frames or #frames == 0 then if cb then cb() end return end
    local points = {}
    if opts.fromCurrent then points[1] = { pos = cur.pos, rot = cur.rot, fov = cur.fov, hold = 0 } end
    for _, f in ipairs(frames) do
        local prev = points[#points]
        local rot = V(f.rot)
        if prev then rot = unwrap(prev.rot, rot) end
        points[#points + 1] = {
            pos = V(f.pos), rot = rot, fov = (f.fov or 40.0) + 0.0,
            hold = f.hold or 0, duration = f.duration or 2000, ease = f.ease,
            aim = f.aim and V(f.aim) or nil,
        }
    end
    if #points == 1 then points[2] = points[1] end

    local runs, current = {}, nil
    local flowEase = VMC.GetEase(opts.ease or 'easeInOutSine')
    for i = 1, #points - 1 do
        if (points[i].hold or 0) > 0 then
            current = nil
            runs[#runs + 1] = { kind = 'hold', i = i, dur = points[i].hold }
        end
        local seg = { i = i, dur = points[i + 1].duration or 2000 }
        if opts.flow then
            if not current then
                current = { kind = 'run', segs = {}, dur = 0, ease = flowEase }
                runs[#runs + 1] = current
            end
            current.segs[#current.segs + 1] = seg
            current.dur = current.dur + seg.dur
        else
            runs[#runs + 1] = { kind = 'run', segs = { seg }, dur = seg.dur, ease = VMC.GetEase(points[i + 1].ease or 'easeInOutSine') }
        end
    end
    local last = points[#points]
    if (last.hold or 0) > 0 then runs[#runs + 1] = { kind = 'hold', i = #points, dur = last.hold } end

    if not opts.fromCurrent then
        cur.pos, cur.rot, cur.fov = samplePath(points, 1, 0.0)
        apply()
    end
    job = { kind = 'path', points = points, runs = runs, start = GetGameTimer(), cb = cb }
end

function Cam.SetShake(amount)
    if not cam then return end
    if (amount or 0) > 0 then
        ShakeCam(cam, 'HAND_SHAKE', amount)
    else
        StopCamShaking(cam, true)
    end
end

function Cam.SetDof(enabled, strength)
    dof.enabled = enabled and true or false
    dof.strength = strength or dof.strength
    if cam then SetCamUseShallowDofMode(cam, dof.enabled) end
end

function Cam.SetFocus(vec)
    dof.focus = vec and V(vec) or nil
end

function Cam.Destroy(blend)
    if not cam then return end
    job = nil
    StopCamShaking(cam, true)
    SetCamUseShallowDofMode(cam, false)
    RenderScriptCams(false, (blend or 0) > 0, blend or 0, true, true)
    DestroyCam(cam, false)
    cam = nil
    dof.focus = nil
    ClearFocus()
end

-- Builds a nice default camera for a character standing at pos/heading
function Cam.AutoSpotCam(pos, heading)
    pos = V(pos)
    local h = math.rad(heading or 0.0)
    local fwd = vec3(-math.sin(h), math.cos(h), 0.0)
    local right = vec3(math.cos(h), math.sin(h), 0.0)
    local camPos = pos + fwd * 2.4 + right * 0.55 + vec3(0.0, 0.0, 0.45)
    local target = pos + vec3(0.0, 0.0, 0.35)
    return { pos = camPos, rot = Cam.LookRot(camPos, target), fov = Config.Camera.Fov }
end
