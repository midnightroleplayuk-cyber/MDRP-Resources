Editor = {}

local V = Cam.ToVec
local isOpen = false
local scene
local propEnts = {}   -- [i] = entity
local spotEnts = {}   -- [i] = { ped, prop }
local placing         -- { kind, index, ent, heading, z, rot, isNew }
local mode = 'ui'
local playing = false
local origin          -- { coords, heading }

local function tbl(v) return { x = VMC.Round(v.x, 4), y = VMC.Round(v.y, 4), z = VMC.Round(v.z, 4) } end

local function send(action, data) SendNUIMessage({ action = action, data = data }) end
local function sync() send('editor:scene', scene) end
local function toast(text, kind) send('toast', { text = text, type = kind or 'info' }) end

local function hint()
    local h
    if playing then
        h = { { 'Backspace', 'Stop preview' } }
    elseif placing then
        h = {
            { 'Mouse', 'Aim' }, { 'Scroll', 'Rotate' }, { 'Alt + Scroll', 'Fine rotate' },
            { 'Ctrl + Scroll', 'Raise / lower' }, { 'G', 'Snap to ground' },
            { 'Left click', 'Place' }, { 'Right click', 'Cancel' },
        }
    elseif mode == 'fly' then
        h = {
            { 'WASD', 'Move' }, { 'Q / E', 'Down / up' }, { 'Shift', 'Fast' }, { 'Alt', 'Slow' },
            { 'Scroll', 'Field of view' }, { 'Z / X', 'Roll' }, { 'R', 'Level' }, { 'C', 'Add keyframe here' }, { 'Tab', 'Back to panel' },
        }
    else
        h = { { 'Tab', 'Fly the camera' } }
    end
    send('editor:hint', { items = h, mode = playing and 'playing' or (placing and 'placing' or mode) })
end

local function setMode(m)
    mode = m
    if m == 'fly' then
        SetNuiFocus(false, false)
        Freecam.SetInput(true)
    else
        Freecam.SetInput(false)
        SetNuiFocus(true, true)
    end
    hint()
end

-- Entities -----------------------------------------------------------------------------
local function despawnProp(i)
    Scene.Delete(propEnts[i])
    propEnts[i] = nil
end

local function spawnProp(i)
    despawnProp(i)
    propEnts[i] = Scene.SpawnProp(scene.props[i])
end

local function despawnSpot(i)
    local e = spotEnts[i]
    if e then Scene.Delete(e.prop) Scene.Delete(e.ped) end
    spotEnts[i] = nil
end

local function spawnSpot(i)
    despawnSpot(i)
    local ped, prop = Scene.CreatePed(scene.spots[i], 'clone')
    spotEnts[i] = { ped = ped, prop = prop }
end

local function rebuildList(list, ents, despawn, spawn)
    for i in pairs(ents) do despawn(i) end
    for i = 1, #list do spawn(i) end
end

local function rebuildAll()
    rebuildList(scene.props, propEnts, despawnProp, spawnProp)
    rebuildList(scene.spots, spotEnts, despawnSpot, spawnSpot)
end

-- Placement -----------------------------------------------------------------------------
local function endPlacement(confirm)
    local p = placing
    if not p then return end
    placing = nil
    Freecam.ScrollHandler = nil

    if p.kind == 'prop' then
        if confirm then
            local c = GetEntityCoords(p.ent)
            local r = GetEntityRotation(p.ent, 2)
            scene.props[p.index].pos = tbl(c)
            scene.props[p.index].rot = tbl(r)
            spawnProp(p.index)
        elseif p.isNew then
            despawnProp(p.index)
            table.remove(scene.props, p.index)
            rebuildList(scene.props, propEnts, despawnProp, spawnProp)
        else
            spawnProp(p.index)
        end
    else
        if confirm then
            local c = GetEntityCoords(p.ent)
            scene.spots[p.index].pos = tbl(c)
            scene.spots[p.index].heading = VMC.Round(p.heading % 360, 2)
            spawnSpot(p.index)
        elseif p.isNew then
            despawnSpot(p.index)
            table.remove(scene.spots, p.index)
            rebuildList(scene.spots, spotEnts, despawnSpot, spawnSpot)
        else
            spawnSpot(p.index)
        end
    end
    sync()
    setMode('ui')
end

local function startPlacement(kind, index, isNew)
    if placing then endPlacement(false) end
    local ent, heading, rot
    if kind == 'prop' then
        ent = propEnts[index]
        if not ent then return toast('That model could not be loaded. Check the name.', 'error') end
        rot = GetEntityRotation(ent, 2)
        heading = rot.z
        SetEntityAlpha(ent, 170, false)
        SetEntityCollision(ent, false, false)
    else
        local e = spotEnts[index]
        ent = e and e.ped
        if not ent then return end
        heading = scene.spots[index].heading or 0.0
        ClearPedTasksImmediately(ent)
        SetEntityAlpha(ent, 190, false)
        SetEntityCollision(ent, false, false)
        FreezeEntityPosition(ent, true)
    end

    placing = { kind = kind, index = index, ent = ent, heading = heading, rot = rot, z = 0.0, isNew = isNew, ground = false }
    Freecam.ScrollHandler = function(dir, ctrl, alt)
        if not placing then return end
        if ctrl then
            placing.z = placing.z + dir * (alt and 0.01 or 0.05)
        else
            placing.heading = placing.heading + dir * (alt and 1.0 or 7.5)
        end
    end
    setMode('fly')

    CreateThread(function()
        while placing and placing.ent == ent do
            local hit, coords = Freecam.Raycast(ent, 80.0)
            if hit then
                local base = placing.kind == 'spot' and 1.0 or 0.0
                local z = coords.z + base + placing.z
                SetEntityCoordsNoOffset(ent, coords.x, coords.y, z, false, false, false)
                if placing.kind == 'prop' then
                    SetEntityRotation(ent, placing.rot.x, placing.rot.y, placing.heading, 2, true)
                    if placing.ground then PlaceObjectOnGroundProperly(ent) end
                else
                    SetEntityHeading(ent, placing.heading)
                end
            end
            if IsDisabledControlJustPressed(0, 47) and placing.kind == 'prop' then
                placing.ground = not placing.ground
                toast(placing.ground and 'Snapping to ground' or 'Free placement')
            end
            if IsDisabledControlJustPressed(0, 24) then endPlacement(true) break end
            if IsDisabledControlJustPressed(0, 25) or IsDisabledControlJustPressed(0, 177) then endPlacement(false) break end
            Wait(0)
        end
    end)
end

-- Preview ---------------------------------------------------------------------------------
local function spotCam(i)
    local s = scene.spots[i]
    if not s then return nil end
    if s.cam and s.cam.pos then return { pos = V(s.cam.pos), rot = V(s.cam.rot), fov = s.cam.fov } end
    return Cam.AutoSpotCam(s.pos, s.heading)
end

local function waitCam()
    while Cam.IsBusy() and playing do Wait(0) end
end

local function stopPlaying()
    if not playing then return end
    playing = false
    Cam.Stop()
    Cam.SetShake(0)
    Cam.SetDof(false)
    Freecam.SyncFromCam()
    send('editor:playing', false)
    setMode('ui')
end

local function play(full)
    if playing then return end
    if placing then endPlacement(false) end
    playing = true
    SetNuiFocus(false, false)
    Freecam.SetInput(false)
    send('editor:playing', true)
    hint()

    CreateThread(function()
        while playing do
            DisableAllControlActions(0)
            if IsDisabledControlJustPressed(0, 177) then stopPlaying() end
            Wait(0)
        end
    end)

    CreateThread(function()
        local camCfg = scene.camera
        Cam.SetShake(camCfg.shake)
        Cam.SetDof(camCfg.dof.enabled, camCfg.dof.strength)
        if scene.spots[1] then Cam.SetFocus(V(scene.spots[1].pos) + vec3(0.0, 0.0, 0.5)) end

        local glided = false
        if #camCfg.intro > 0 then
            local frames, opts
            frames, opts, glided = Scene.IntroFrames(scene, scene.spots[1] and spotCam(1))
            Cam.PlayPath(frames, nil, opts)
            waitCam()
        end
        if full then
            for i = 1, #scene.spots do
                if not playing then break end
                local target = spotCam(i)
                Cam.SetFocus(V(scene.spots[i].pos) + vec3(0.0, 0.0, 0.5))
                Cam.TweenTo(target, (i == 1 and (glided or #camCfg.intro == 0)) and 0 or camCfg.transition, camCfg.ease)
                waitCam()
                local t = GetGameTimer() + 1800
                while playing and GetGameTimer() < t do Wait(0) end
            end
        end
        stopPlaying()
    end)
end

-- Draw helpers ---------------------------------------------------------------------------------
local function text3d(pos, txt)
    SetDrawOrigin(pos.x, pos.y, pos.z, 0)
    SetTextFont(4)
    SetTextScale(0.0, 0.32)
    SetTextColour(255, 255, 255, 230)
    SetTextOutline()
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(txt)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

local function drawLoop()
    CreateThread(function()
        while isOpen do
            SetEntityLocallyInvisible(PlayerPedId())
            if not playing then
                for i, s in ipairs(scene.spots) do
                    local p = V(s.pos)
                    DrawMarker(25, p.x, p.y, p.z - 0.98, 0, 0, 0, 0, 0, 0, 0.9, 0.9, 0.9, 242, 169, 59, 140, false, false, 2, false, nil, nil, false)
                    text3d(p + vec3(0.0, 0.0, 1.15), ('Spot %d'):format(i))
                    if s.cam and s.cam.pos then
                        local c = V(s.cam.pos)
                        DrawLine(c.x, c.y, c.z, p.x, p.y, p.z + 0.4, 143, 163, 184, 160)
                        DrawMarker(28, c.x, c.y, c.z, 0, 0, 0, 0, 0, 0, 0.08, 0.08, 0.08, 143, 163, 184, 200, false, false, 2, false, nil, nil, false)
                    end
                end
                local intro = scene.camera.intro
                for i, k in ipairs(intro) do
                    local p = V(k.pos)
                    DrawMarker(28, p.x, p.y, p.z, 0, 0, 0, 0, 0, 0, 0.12, 0.12, 0.12, 255, 255, 255, 200, false, false, 2, false, nil, nil, false)
                    text3d(p + vec3(0.0, 0.0, 0.2), ('Key %d'):format(i))
                    if intro[i + 1] then
                        local n = V(intro[i + 1].pos)
                        DrawLine(p.x, p.y, p.z, n.x, n.y, n.z, 255, 255, 255, 150)
                    end
                    local tgt = (k.aim or 0) > 0 and scene.spots[k.aim]
                    if tgt then
                        local t = V(tgt.pos) + vec3(0.0, 0.0, 0.45)
                        DrawLine(p.x, p.y, p.z, t.x, t.y, t.z, 242, 169, 59, 70)
                    end
                end
            end

            -- fly-mode hotkeys
            if mode == 'fly' and not placing and not playing then
                if IsDisabledControlJustPressed(0, 37) then setMode('ui') end
                if IsDisabledControlJustPressed(0, 26) then Editor.Op({ op = 'addKeyframe' }) end
            end
            Wait(0)
        end
    end)
end

-- Open / close --------------------------------------------------------------------------------
local function blankScene()
    return VMC.SanitiseScene({
        name = 'New scene',
        env = { hour = 20, minute = 0, weather = 'CLEAR', freeze = true },
        camera = { transition = Config.Camera.Transition, ease = Config.Camera.Ease, shake = Config.Camera.Shake, dof = Config.Camera.Dof, intro = {} },
        spots = {}, props = {},
    })
end

function Editor.Open(data)
    if isOpen then return end
    isOpen = true
    local id = data and data.id
    scene = VMC.SanitiseScene(data or blankScene())
    scene.id = id

    local ped = PlayerPedId()
    origin = { coords = GetEntityCoords(ped), heading = GetEntityHeading(ped) }
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)

    local startPos, startRot = GetGameplayCamCoord(), GetGameplayCamRot(2)
    if scene.spots[1] then
        local c = spotCam(1)
        startPos, startRot = c.pos, c.rot
        Scene.Stream(scene.spots[1].pos)
    end
    Freecam.Start(startPos, vec3(startRot.x, 0.0, startRot.z), 45.0)
    Scene.StartEnv(scene.env)
    rebuildAll()

    send('editor:open', {
        scene = scene,
        poses = VMC.Poses,
        bones = VMC.Bones,
        eases = VMC.EaseNames,
        weathers = Config.Weathers,
        limits = Config.Editor,
    })
    setMode('ui')
    drawLoop()
end

function Editor.Close()
    if not isOpen then return end
    if placing then endPlacement(false) end
    playing = false
    isOpen = false
    for i in pairs(propEnts) do despawnProp(i) end
    for i in pairs(spotEnts) do despawnSpot(i) end
    Freecam.Stop()
    Cam.Destroy(0)
    Scene.StopEnv()
    ClearFocus()

    local ped = PlayerPedId()
    if origin then
        SetEntityCoordsNoOffset(ped, origin.coords.x, origin.coords.y, origin.coords.z, false, false, false)
        SetEntityHeading(ped, origin.heading)
    end
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    send('editor:close')
    SetNuiFocus(false, false)
end

function Editor.IsOpen() return isOpen end

-- Operations from the NUI --------------------------------------------------------------------
local function view() return Freecam.GetView() end

local ops = {}

ops.focus = function(d) setMode(d.fly and 'fly' or 'ui') end

ops.meta = function(d)
    if d.name then scene.name = d.name end
    if d.enabled ~= nil then scene.enabled = d.enabled end
    if d.weight then scene.weight = d.weight end
    if d.env then for k, v in pairs(d.env) do scene.env[k] = v end end
    if d.camera then
        for k, v in pairs(d.camera) do
            if k == 'dof' then for dk, dv in pairs(v) do scene.camera.dof[dk] = dv end
            elseif k ~= 'intro' then scene.camera[k] = v end
        end
    end
    local clean = VMC.SanitiseScene(scene)
    clean.id = scene.id
    scene = clean
    Scene.StartEnv(scene.env)
end

-- Props
ops.addProp = function(d)
    if #scene.props >= Config.Editor.MaxProps then return toast('Prop limit reached for this scene.', 'error') end
    local model = VMC.Str(d.model, 64)
    if not model or model == '' then return toast('Type a prop model name first.', 'error') end
    if not IsModelInCdimage(joaat(model)) then return toast(('"%s" is not a valid model.'):format(model), 'error') end
    local v = view()
    local pos = v.pos + Cam.RotToDir(v.rot) * 3.0
    scene.props[#scene.props + 1] = { model = model, pos = tbl(pos), rot = { x = 0, y = 0, z = 0 }, collision = true }
    local i = #scene.props
    spawnProp(i)
    startPlacement('prop', i, true)
end

ops.moveProp = function(d) if scene.props[d.index] then startPlacement('prop', d.index, false) end end

ops.removeProp = function(d)
    if not scene.props[d.index] then return end
    table.remove(scene.props, d.index)
    rebuildList(scene.props, propEnts, despawnProp, spawnProp)
end

ops.updateProp = function(d)
    local p = scene.props[d.index]
    if not p then return end
    local f = d.fields or {}
    if f.pos then p.pos = VMC.XYZ(f.pos, p.pos) end
    if f.rot then p.rot = VMC.XYZ(f.rot, p.rot) end
    if f.collision ~= nil then p.collision = f.collision end
    spawnProp(d.index)
end

ops.duplicateProp = function(d)
    local p = scene.props[d.index]
    if not p or #scene.props >= Config.Editor.MaxProps then return end
    scene.props[#scene.props + 1] = VMC.Copy(p)
    local i = #scene.props
    spawnProp(i)
    startPlacement('prop', i, true)
end

-- Spots
ops.addSpot = function()
    if #scene.spots >= Config.Editor.MaxSpots then return toast('Character spot limit reached.', 'error') end
    local v = view()
    local pos = v.pos + Cam.RotToDir(v.rot) * 3.0
    scene.spots[#scene.spots + 1] = { pos = tbl(pos), heading = VMC.Round((v.rot.z + 180.0) % 360, 2), pose = { type = 'preset', preset = 'idle' } }
    local i = #scene.spots
    spawnSpot(i)
    startPlacement('spot', i, true)
end

ops.moveSpot = function(d) if scene.spots[d.index] then startPlacement('spot', d.index, false) end end

ops.removeSpot = function(d)
    if not scene.spots[d.index] then return end
    table.remove(scene.spots, d.index)
    rebuildList(scene.spots, spotEnts, despawnSpot, spawnSpot)
end

ops.updateSpot = function(d)
    local s = scene.spots[d.index]
    if not s then return end
    local f = d.fields or {}
    if f.pos then s.pos = VMC.XYZ(f.pos, s.pos) end
    if f.heading then s.heading = VMC.Num(f.heading, s.heading, -720, 720) % 360 end
    if f.pose then s.pose = f.pose end
    if f.prop == false then s.prop = nil elseif type(f.prop) == 'table' then s.prop = f.prop end
    local clean = VMC.SanitiseScene({ spots = { s } }).spots[1]
    if clean then
        clean.cam = s.cam
        scene.spots[d.index] = clean
    end
    spawnSpot(d.index)
end

ops.spotCam = function(d)
    local s = scene.spots[d.index]
    if not s then return end
    if d.auto then
        s.cam = nil
        toast(('Spot %d uses the automatic camera.'):format(d.index))
    else
        local v = view()
        s.cam = { pos = tbl(v.pos), rot = tbl(v.rot), fov = VMC.Round(v.fov, 2) }
        toast(('Spot %d camera set from your view.'):format(d.index))
    end
end

ops.gotoSpot = function(d)
    local c = spotCam(d.index)
    if c then Freecam.SetView(c.pos, c.rot, c.fov) end
end

-- Keyframes
ops.addKeyframe = function()
    local intro = scene.camera.intro
    if #intro >= Config.Editor.MaxKeyframes then return toast('Keyframe limit reached.', 'error') end
    local v = view()
    intro[#intro + 1] = { pos = tbl(v.pos), rot = tbl(v.rot), fov = VMC.Round(v.fov, 2), duration = #intro == 0 and 0 or 2500, hold = 0, ease = 'easeInOutSine' }
    toast(('Keyframe %d added.'):format(#intro))
end

ops.updateKeyframe = function(d)
    local k = scene.camera.intro[d.index]
    if not k then return end
    local f = d.fields or {}
    if f.duration then k.duration = math.floor(VMC.Num(f.duration, k.duration, 0, 60000)) end
    if f.hold then k.hold = math.floor(VMC.Num(f.hold, k.hold, 0, 30000)) end
    if f.fov then k.fov = VMC.Num(f.fov, k.fov, 5, 130) end
    if f.ease and VMC.Ease[f.ease] then k.ease = f.ease end
    if f.aim ~= nil then k.aim = math.floor(VMC.Num(f.aim, 0, 0, #scene.spots)) end
    if f.roll ~= nil then k.rot.y = VMC.Num(f.roll, 0, -90, 90) end
end

-- Builds an orbit of keyframes around a spot, all tracking the character
ops.orbit = function(d)
    local o = d.orbit or {}
    local spot = scene.spots[tonumber(o.spot) or 1]
    if not spot then return toast('Add a character spot first.', 'error') end
    local n = math.floor(VMC.Num(o.points, 8, 3, 24))
    local intro = scene.camera.intro
    if not o.replace and #intro + n + 1 > Config.Editor.MaxKeyframes then return toast('That would go over the keyframe limit.', 'error') end
    local r = VMC.Num(o.radius, 3.0, 0.5, 40.0)
    local height = VMC.Num(o.height, 0.6, -10.0, 30.0)
    local endHeight = VMC.Num(o.endHeight, height, -10.0, 30.0)
    local degrees = VMC.Num(o.degrees, 180, 10, 720)
    local total = VMC.Num(o.duration, 8000, 500, 60000)
    local dir = o.dir == 'ccw' and -1 or 1
    local fov = VMC.Num(o.fov, 40, 10, 110)
    local centre = V(spot.pos) + vec3(0.0, 0.0, 0.45)
    local base = (spot.heading or 0.0) + VMC.Num(o.start, 0, -360, 360)

    if o.replace then scene.camera.intro = {} intro = scene.camera.intro end
    local first = #intro == 0
    for k = 0, n do
        local frac = k / n
        local a = math.rad(base + dir * degrees * frac)
        local pos = centre + vec3(-math.sin(a) * r, math.cos(a) * r, height + (endHeight - height) * frac)
        local rot = Cam.LookRot(pos, centre)
        intro[#intro + 1] = {
            pos = tbl(pos), rot = tbl(rot), fov = fov,
            duration = (first and k == 0) and 0 or (k == 0 and 1500 or math.floor(total / n)),
            hold = 0, ease = 'linear', aim = tonumber(o.spot) or 1,
        }
    end
    scene.camera.flow = true
    toast(('Orbit added: %d keyframes.'):format(n + 1), 'success')
end

-- Spreads the path's total time by distance, so the camera moves at an even speed
ops.evenSpeed = function()
    local intro = scene.camera.intro
    if #intro < 3 then return toast('Needs at least three keyframes.', 'error') end
    local total, lens, sum = 0, {}, 0
    for i = 2, #intro do
        total = total + (intro[i].duration or 0)
        local l = #(V(intro[i].pos) - V(intro[i - 1].pos))
        lens[i] = l
        sum = sum + l
    end
    if sum <= 0.01 then return end
    for i = 2, #intro do intro[i].duration = math.max(100, math.floor(total * lens[i] / sum)) end
    toast('Travel times evened out by distance.', 'success')
end

ops.clearPath = function()
    scene.camera.intro = {}
    toast('Path cleared.')
end

ops.replaceKeyframe = function(d)
    local k = scene.camera.intro[d.index]
    if not k then return end
    local v = view()
    k.pos, k.rot, k.fov = tbl(v.pos), tbl(v.rot), VMC.Round(v.fov, 2)
    toast(('Keyframe %d moved to your view.'):format(d.index))
end

ops.removeKeyframe = function(d) table.remove(scene.camera.intro, d.index) end

ops.moveKeyframe = function(d)
    local intro, i, j = scene.camera.intro, d.index, d.index + (d.dir or 0)
    if intro[i] and intro[j] then intro[i], intro[j] = intro[j], intro[i] end
end

ops.gotoKeyframe = function(d)
    local k = scene.camera.intro[d.index]
    if k then Freecam.SetView(k.pos, k.rot, k.fov) end
end

ops.playIntro = function() play(false) end
ops.preview = function() play(true) end

ops.save = function()
    if #scene.spots == 0 then return toast('Add at least one character spot before saving.', 'error') end
    local ok, saved = lib.callback.await('vmc:admin:saveScene', false, scene)
    if ok and saved then
        scene.id = saved.id
        toast(('Saved "%s".'):format(saved.name), 'success')
    else
        toast('The scene could not be saved.', 'error')
    end
end

ops.exit = function()
    Editor.Close()
    OpenAdmin()
end

function Editor.Op(d)
    if not isOpen or type(d) ~= 'table' then return end
    local fn = ops[d.op]
    if not fn then return end
    fn(d)
    if d.op ~= 'exit' and isOpen then sync() hint() end
end

RegisterNUICallback('editor', function(d, cb)
    cb(1)
    CreateThread(function() Editor.Op(d) end)
end)
