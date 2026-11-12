Freecam = {}

local running = false
local input = false
local pos, rot, fov = vec3(0, 0, 0), vec3(0, 0, 0), 45.0
Freecam.ScrollHandler = nil -- function(dir, ctrl, alt) set by placement mode

local function clampPitch(p) return math.max(-89.0, math.min(89.0, p)) end

function Freecam.Start(startPos, startRot, startFov)
    pos = startPos or GetGameplayCamCoord()
    rot = startRot or GetGameplayCamRot(2)
    fov = startFov or 45.0
    Cam.Create(pos, rot, fov)
    Cam.Set(pos, rot, fov)
    if running then return end
    running = true
    CreateThread(function()
        local ed = Config.Editor
        local lastFocus = 0
        while running do
            if GetGameTimer() - lastFocus > 400 then
                SetFocusPosAndVel(pos.x, pos.y, pos.z, 0.0, 0.0, 0.0)
                lastFocus = GetGameTimer()
            end
            DisableAllControlActions(0)
            EnableControlAction(0, 249, true) -- push to talk
            EnableControlAction(0, 245, true) -- chat

            if input and not Cam.IsBusy() then
                local lx = GetDisabledControlNormal(0, 1)
                local ly = GetDisabledControlNormal(0, 2)
                local roll = rot.y
                if IsDisabledControlPressed(0, 20) then roll = roll - 1.2 end -- Z
                if IsDisabledControlPressed(0, 73) then roll = roll + 1.2 end -- X
                if IsDisabledControlJustPressed(0, 45) then roll = 0.0 end    -- R
                roll = math.max(-90.0, math.min(90.0, roll))
                rot = vec3(clampPitch(rot.x - ly * ed.Sensitivity), roll, rot.z - lx * ed.Sensitivity)

                local speed = ed.Speed
                if IsDisabledControlPressed(0, 21) then speed = speed * ed.FastMultiplier end
                if IsDisabledControlPressed(0, 19) then speed = speed * ed.SlowMultiplier end

                local fwd = Cam.RotToDir(rot)
                local h = math.rad(rot.z)
                local right = vec3(math.cos(h), math.sin(h), 0.0)
                local move = vec3(0.0, 0.0, 0.0)
                if IsDisabledControlPressed(0, 32) then move = move + fwd end
                if IsDisabledControlPressed(0, 33) then move = move - fwd end
                if IsDisabledControlPressed(0, 34) then move = move - right end
                if IsDisabledControlPressed(0, 35) then move = move + right end
                if IsDisabledControlPressed(0, 38) then move = move + vec3(0.0, 0.0, 1.0) end -- E
                if IsDisabledControlPressed(0, 44) then move = move - vec3(0.0, 0.0, 1.0) end -- Q
                pos = pos + move * (speed * GetFrameTime() * 60.0)

                local up = IsDisabledControlJustPressed(0, 241)
                local down = IsDisabledControlJustPressed(0, 242)
                if up or down then
                    local dir = up and 1 or -1
                    if Freecam.ScrollHandler then
                        Freecam.ScrollHandler(dir, IsDisabledControlPressed(0, 36), IsDisabledControlPressed(0, 19))
                    else
                        fov = math.max(10.0, math.min(110.0, fov - dir * 2.0))
                    end
                end

                Cam.Set(pos, rot, fov)
            elseif not Cam.IsBusy() then
                Cam.Set(pos, rot, fov)
            end
            Wait(0)
        end
    end)
end

function Freecam.Stop()
    running = false
    input = false
    Freecam.ScrollHandler = nil
end

function Freecam.SetInput(state) input = state end
function Freecam.HasInput() return input end

function Freecam.GetView() return { pos = pos, rot = rot, fov = fov } end

function Freecam.SetView(p, r, f)
    pos, rot, fov = Cam.ToVec(p), Cam.ToVec(r), f or fov
    Cam.Set(pos, rot, fov)
end

-- Sync freecam to wherever a camera animation ended
function Freecam.SyncFromCam()
    local c = Cam.Get()
    pos, rot, fov = c.pos, vec3(c.rot.x, c.rot.y, c.rot.z), c.fov
end

function Freecam.Raycast(ignore, dist)
    local dir = Cam.RotToDir(rot)
    local to = pos + dir * (dist or 60.0)
    local handle = StartShapeTestLosProbe(pos.x, pos.y, pos.z, to.x, to.y, to.z, 1 + 16, ignore or 0, 4)
    local status, hit, coords, _, entity
    repeat
        status, hit, coords, _, entity = GetShapeTestResult(handle)
        if status == 1 then Wait(0) end
    until status ~= 1
    return hit == 1, coords, entity
end
