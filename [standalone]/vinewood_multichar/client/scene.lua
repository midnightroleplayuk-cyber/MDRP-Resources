Scene = {}

local V = Cam.ToVec
local active        -- scene table
local props = {}    -- entities
local spotPeds = {} -- [spotIndex] = { ped, prop, slot }
local chars = {}    -- [slot] = character
local envThread = false
local pinned

-- Helpers -------------------------------------------------------------------------------
local function fadeEntity(ent, from, to, ms)
    local start = GetGameTimer()
    while true do
        if not DoesEntityExist(ent) then return end
        local t = math.min(1.0, (GetGameTimer() - start) / ms)
        SetEntityAlpha(ent, math.floor(from + (to - from) * t), false)
        if t >= 1.0 then break end
        Wait(0)
    end
    if to >= 255 then ResetEntityAlpha(ent) end
end
Scene.Fade = fadeEntity

local function deleteEnt(ent)
    if ent and DoesEntityExist(ent) then
        SetEntityAsMissionEntity(ent, true, true)
        DeleteEntity(ent)
    end
end
Scene.Delete = deleteEnt

function Scene.SpotFor(slot)
    if not active or #active.spots == 0 then return 1 end
    return ((slot - 1) % #active.spots) + 1
end

function Scene.Get() return active end

-- The preview ped currently showing this slot's character (nil while it's swapping in)
function Scene.GetPed(slot)
    local sp = spotPeds[Scene.SpotFor(slot)]
    if sp and sp.slot == slot and DoesEntityExist(sp.ped) then return sp.ped end
end

function Scene.Anchor()
    return active and active.spots[1] and V(active.spots[1].pos) or nil
end

-- Keeps the real player ped hidden and parked at the scene. Call every frame while selecting.
function Scene.HidePlayer()
    local ped = PlayerPedId()
    SetEntityLocallyInvisible(ped)
    if IsEntityVisible(ped) then SetEntityVisible(ped, false, false) end
    FreezeEntityPosition(ped, true)
    SetEntityCollision(ped, false, false)
    SetEntityInvincible(ped, true)
    local anchor = Scene.Anchor()
    if anchor and #(GetEntityCoords(ped) - anchor) > 3.0 then
        SetEntityCoordsNoOffset(ped, anchor.x, anchor.y, anchor.z - 8.0, false, false, false)
    end
end

-- Streaming ------------------------------------------------------------------------------
function Scene.Stream(pos)
    pos = V(pos)
    SetFocusPosAndVel(pos.x, pos.y, pos.z, 0.0, 0.0, 0.0)
    RequestCollisionAtCoord(pos.x, pos.y, pos.z)
    NewLoadSceneStartSphere(pos.x, pos.y, pos.z, 80.0, 0)
    local t = GetGameTimer() + 6000
    while not IsNewLoadSceneLoaded() and GetGameTimer() < t do Wait(0) end
    NewLoadSceneStop()

    local interior = GetInteriorAtCoords(pos.x, pos.y, pos.z)
    if interior ~= 0 then
        PinInteriorInMemory(interior)
        pinned = interior
        local t2 = GetGameTimer() + 5000
        while not IsInteriorReady(interior) and GetGameTimer() < t2 do Wait(0) end
    end
end

-- Environment ----------------------------------------------------------------------------
local envData
function Scene.StartEnv(env)
    envData = env or {}
    if envThread then return end
    envThread = true
    CreateThread(function()
        while envThread and envData do
            local w = envData.weather or 'CLEAR'
            SetOverrideWeather(w)
            SetWeatherTypeNowPersist(w)
            if envData.freeze ~= false then
                NetworkOverrideClockTime(envData.hour or 19, envData.minute or 0, 0)
            end
            Wait(250)
        end
        envThread = false
    end)
end

function Scene.StopEnv()
    envData = nil
    envThread = false
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    NetworkClearClockTimeOverride()
end

-- Props ------------------------------------------------------------------------------------
function Scene.SpawnProp(p)
    local hash = Appearance.LoadModel(p.model)
    if not hash then
        if Config.Debug then print('[vinewood_multichar] bad prop model: ' .. tostring(p.model)) end
        return nil
    end
    local pos, rot = V(p.pos), V(p.rot)
    local obj = CreateObjectNoOffset(hash, pos.x, pos.y, pos.z, false, false, false)
    SetEntityRotation(obj, rot.x, rot.y, rot.z, 2, true)
    FreezeEntityPosition(obj, true)
    SetEntityCollision(obj, p.collision ~= false, p.collision ~= false)
    SetEntityInvincible(obj, true)
    SetModelAsNoLongerNeeded(hash)
    return obj
end

-- Poses -------------------------------------------------------------------------------------
function Scene.ResolvePose(pose)
    pose = pose or {}
    if pose.type == 'preset' then return VMC.PoseById[pose.preset or ''] or { type = 'none' } end
    return pose
end

function Scene.ApplyPose(ped, spot)
    ClearPedTasksImmediately(ped)
    local pos = V(spot.pos)
    SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z, false, false, false)
    SetEntityHeading(ped, spot.heading or 0.0)
    local def = Scene.ResolvePose(spot.pose)
    if def.type == 'anim' and def.dict and def.clip then
        local ok = pcall(lib.requestAnimDict, def.dict, 5000)
        if ok then
            TaskPlayAnim(ped, def.dict, def.clip, 8.0, 8.0, -1, def.flag or 1, 0.0, false, false, false)
        end
    elseif def.type == 'scenario' and def.scenario then
        TaskStartScenarioAtPosition(ped, def.scenario, pos.x, pos.y, def.sitting and (pos.z - 0.5) or pos.z, spot.heading or 0.0, 0, def.sitting or false, true)
    end
end

function Scene.AttachProp(ped, spot)
    if not spot.prop or not spot.prop.model then return nil end
    local hash = Appearance.LoadModel(spot.prop.model)
    if not hash then return nil end
    local c = GetEntityCoords(ped)
    local obj = CreateObject(hash, c.x, c.y, c.z, false, false, false)
    local o, r = V(spot.prop.offset), V(spot.prop.rot)
    AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, spot.prop.bone or 57005), o.x, o.y, o.z, r.x, r.y, r.z, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(hash)
    return obj
end

local function preparePed(ped)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanRagdoll(ped, false)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCanBeTargetted(ped, false)
    SetEntityCanBeDamaged(ped, false)
    SetPedConfigFlag(ped, 185, true) -- no helmet on bikes etc
end

-- Creates a preview ped for a character (or a clone of the player when char == 'clone')
function Scene.CreatePed(spot, char)
    local pos = V(spot.pos)
    local ped
    if char == 'clone' then
        ped = ClonePed(PlayerPedId(), false, false, true)
    else
        local hash = Appearance.LoadModel(Appearance.ModelFor(char)) or Appearance.LoadModel('mp_m_freemode_01')
        ped = CreatePed(4, hash, pos.x, pos.y, pos.z, spot.heading or 0.0, false, true)
        SetModelAsNoLongerNeeded(hash)
        Appearance.Apply(ped, char)
    end
    preparePed(ped)
    Scene.ApplyPose(ped, spot)
    local prop = Scene.AttachProp(ped, spot)
    return ped, prop
end

-- Scene lifecycle ------------------------------------------------------------------------------
function Scene.Load(scene)
    Scene.Unload()
    active = VMC.Copy(scene)
    active.spots = active.spots or {}
    active.props = active.props or {}
    if #active.spots == 0 then active.spots = VMC.Copy(Config.FallbackScene.spots) end

    local anchor = V(active.spots[1].pos)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    SetEntityCollision(ped, false, false)
    SetEntityVisible(ped, false, false)
    SetEntityCoordsNoOffset(ped, anchor.x, anchor.y, anchor.z - 8.0, false, false, false)
    Scene.Stream(anchor)
    Scene.StartEnv(active.env)

    for _, p in ipairs(active.props) do
        local obj = Scene.SpawnProp(p)
        if obj then props[#props + 1] = obj end
    end
end

function Scene.ClearPeds()
    for i, sp in pairs(spotPeds) do
        deleteEnt(sp.prop)
        deleteEnt(sp.ped)
        spotPeds[i] = nil
    end
end

function Scene.Unload()
    Scene.ClearPeds()
    for _, obj in ipairs(props) do deleteEnt(obj) end
    props = {}
    Scene.StopEnv()
    if pinned then UnpinInterior(pinned) pinned = nil end
    active = nil
    chars = {}
    ClearFocus()
end

-- Characters on spots ---------------------------------------------------------------------------
function Scene.SetCharacters(list)
    Scene.ClearPeds()
    chars = {}
    for _, c in ipairs(list or {}) do chars[c.slot] = c end
    if not active then return end
    -- first character mapped to each spot is shown
    local slots = {}
    for slot in pairs(chars) do slots[#slots + 1] = slot end
    table.sort(slots)
    for _, slot in ipairs(slots) do
        local s = Scene.SpotFor(slot)
        if not spotPeds[s] then
            local ped, prop = Scene.CreatePed(active.spots[s], chars[slot])
            spotPeds[s] = { ped = ped, prop = prop, slot = slot }
        end
    end
end

function Scene.SpotCam(i)
    local spot = active and active.spots[i]
    if not spot then return nil end
    if spot.cam and spot.cam.pos then
        return { pos = V(spot.cam.pos), rot = V(spot.cam.rot), fov = spot.cam.fov or Config.Camera.Fov }
    end
    return Cam.AutoSpotCam(spot.pos, spot.heading)
end

-- Show this slot's character on its spot and move the camera there
function Scene.Focus(slot, instant)
    if not active then return end
    local s = Scene.SpotFor(slot)
    local spot = active.spots[s]
    local current = spotPeds[s]
    local char = chars[slot]

    if not current or current.slot ~= slot then
        CreateThread(function()
            if current then
                fadeEntity(current.ped, 255, 0, 180)
                deleteEnt(current.prop)
                deleteEnt(current.ped)
                spotPeds[s] = nil
            end
            if char then
                local ped, prop = Scene.CreatePed(spot, char)
                SetEntityAlpha(ped, 0, false)
                spotPeds[s] = { ped = ped, prop = prop, slot = slot }
                fadeEntity(ped, 0, 255, 260)
            end
        end)
    end

    local target = Scene.SpotCam(s)
    Cam.SetFocus(V(spot.pos) + vec3(0.0, 0.0, 0.5))
    if instant then
        Cam.Set(target.pos, target.rot, target.fov)
    else
        local camCfg = active.camera or {}
        Cam.TweenTo(target, camCfg.transition or Config.Camera.Transition, camCfg.ease or Config.Camera.Ease)
    end
end

-- Turns a scene's intro keyframes into camera frames: resolves spot tracking and,
-- with glide on, adds the character's own shot as the final point so there's no stop at the end.
function Scene.IntroFrames(sc, endCam)
    local camCfg = sc.camera or {}
    local frames = {}
    for _, k in ipairs(camCfg.intro or {}) do
        local f = { pos = k.pos, rot = k.rot, fov = k.fov, duration = k.duration, hold = k.hold, ease = k.ease }
        local spot = (k.aim or 0) > 0 and sc.spots[k.aim]
        if spot then f.aim = V(spot.pos) + vec3(0.0, 0.0, 0.45) end
        frames[#frames + 1] = f
    end
    local glided = false
    if #frames > 0 and camCfg.glide ~= false and endCam then
        frames[#frames + 1] = { pos = endCam.pos, rot = endCam.rot, fov = endCam.fov, duration = camCfg.transition or Config.Camera.Transition }
        glided = true
    end
    return frames, { flow = camCfg.flow ~= false, ease = camCfg.pathEase or 'easeInOutSine' }, glided
end

-- Plays the intro path (if any) then settles on the slot's spot
function Scene.PlayIntro(slot, cb)
    local camCfg = active and active.camera or {}
    local intro = camCfg.intro or {}
    Cam.SetShake(camCfg.shake or Config.Camera.Shake)
    local dofCfg = camCfg.dof or Config.Camera.Dof
    Cam.SetDof(dofCfg.enabled ~= false, dofCfg.strength)
    if #intro == 0 then
        Scene.Focus(slot, true)
        if cb then cb() end
        return
    end
    local s = Scene.SpotFor(slot)
    Cam.SetFocus(V(active.spots[s].pos) + vec3(0.0, 0.0, 0.5))
    local frames, opts, glided = Scene.IntroFrames(active, Scene.SpotCam(s))
    Cam.PlayPath(frames, function()
        Scene.Focus(slot, glided) -- already there if the path glided in
        if cb then cb() end
    end, opts)
end
