-- Courtrooms: laptops (open the court system), microphones (carry your voice across the room),
-- and the admin placement tool used by /courtrooms.
local CR = Config.Courtrooms or {}
if CR.enabled == false then return end

local rooms = {}
local zones, points, props = {}, {}, {}
local muted = {}            -- [roomId..':'..index] = true when this player switched a mic off
local activeMic = nil       -- key of the mic currently carrying our voice
local placing = false

local function key(roomId, i) return roomId .. ':' .. i end

-- client/screens.lua reads the rooms from here.
MoJRooms = function() return rooms end

local function propFor(p)
    if p.kind == 'screen' then
        local m = (CR.ScreenModels or {})[p.model or 1]
        return m and m.model
    end
    return p.kind == 'mic' and CR.MicProp or CR.LaptopProp
end
local function hasTarget() return GetResourceState('ox_target') == 'started' end

local function loadModel(name)
    local hash = type(name) == 'number' and name or joaat(name)
    if not IsModelInCdimage(hash) then return nil end
    RequestModel(hash)
    local t = GetGameTimer() + 5000
    while not HasModelLoaded(hash) and GetGameTimer() < t do Wait(10) end
    return HasModelLoaded(hash) and hash or nil
end

local function clear()
    for _, id in ipairs(zones) do pcall(function() exports.ox_target:removeZone(id) end) end
    for _, p in ipairs(points) do p:remove() end
    for _, e in ipairs(props) do if DoesEntityExist(e) then DeleteEntity(e) end end
    zones, points, props = {}, {}, {}
end

local function openLaptop(roomId, index)
    if MoJUI.IsOpen() then return end
    local r = lib.callback.await('vinewood-moj:server:openLaptop', false, roomId, index)
    if not r or r.error then
        return lib.notify({ title = Config.CourtsName, description = r and r.error or 'The laptop is not responding.', type = 'error' })
    end
    MoJUI.Open('staff', r.role, { device = (Config.UI and Config.UI.Device and Config.UI.Device.laptop) or 'laptop', room = r.room })
end

local function openDesk(roomId, index)
    if MoJUI.IsOpen() then return end
    local r = lib.callback.await('vinewood-moj:server:openDesk', false, roomId, index)
    if not r or r.error then
        return lib.notify({ title = Config.CourtsName, description = r and r.error or 'The desk is not responding.', type = 'error' })
    end
    MoJUI.Open('custody', r.role, { device = (Config.UI and Config.UI.Device and Config.UI.Device.laptop) or 'laptop', room = r.room, roomId = r.roomId })
end

local function toggleMic(roomId, index)
    local k = key(roomId, index)
    muted[k] = not muted[k] or nil
    lib.notify({ title = 'Microphone', description = muted[k] and 'Microphone off.' or 'Microphone on.', type = 'inform' })
end

local function build()
    clear()
    for _, r in ipairs(rooms) do
        for i, p in ipairs(r.points or {}) do
            local c = vec3(p.x, p.y, p.z)
            if p.prop then
                local hash = loadModel(propFor(p))
                if hash then
                    local e = CreateObjectNoOffset(hash, c.x, c.y, c.z, false, false, false)
                    SetEntityHeading(e, p.h or 0.0)
                    FreezeEntityPosition(e, true)
                    SetEntityInvincible(e, true)
                    SetModelAsNoLongerNeeded(hash)
                    props[#props + 1] = e
                end
            end
            local roomId, index = r.id, i
            if p.kind == 'screen' then goto continue end
            local option
            if p.kind == 'laptop' then
                option = { name = 'moj_laptop', icon = 'fas fa-laptop', label = p.label or 'Court laptop', onSelect = function() openLaptop(roomId, index) end }
            elseif p.kind == 'custody' then
                option = { name = 'moj_custody', icon = 'fas fa-user-lock', label = p.label or 'Court custody desk', onSelect = function() openDesk(roomId, index) end }
            else
                option = { name = 'moj_mic', icon = 'fas fa-microphone', label = 'Switch microphone on or off', onSelect = function() toggleMic(roomId, index) end }
            end
            if hasTarget() then
                zones[#zones + 1] = exports.ox_target:addSphereZone({
                    coords = c + vec3(0.0, 0.0, 0.15), radius = CR.TargetRadius or 0.7, debug = false, options = { option },
                })
            else
                -- No ox_target: press E at the spot.
                points[#points + 1] = lib.points.new({
                    coords = c, distance = 1.5,
                    onEnter = function() lib.showTextUI('[E] ' .. option.label) end,
                    onExit = function() lib.hideTextUI() end,
                    nearby = function() if IsControlJustReleased(0, 38) then option.onSelect() end end,
                })
            end
            ::continue::
        end
    end
end

RegisterNetEvent('vinewood-moj:client:courtrooms', function(list)
    rooms = list or {}
    build()
end)

CreateThread(function()
    Wait(2000)
    rooms = lib.callback.await('vinewood-moj:server:courtrooms', false) or {}
    build()
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    clear()
    if activeMic and GetResourceState('pma-voice') == 'started' then exports['pma-voice']:clearProximityOverride() end
end)

---------------------------------------------------------------------------
-- Microphones: within MicReach of a live mic, your voice carries across the room.
---------------------------------------------------------------------------
local function setMic(k, range, label)
    if k == activeMic then return end
    if GetResourceState('pma-voice') ~= 'started' then return end
    if k then
        exports['pma-voice']:overrideProximityRange(range + 0.0, true)
        SendNUIMessage({ action = 'mic', on = true, label = label })
    else
        exports['pma-voice']:clearProximityOverride()
        SendNUIMessage({ action = 'mic', on = false })
    end
    activeMic = k
end

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local here = GetEntityCoords(ped)
        local bestK, bestRange, bestLabel, bestD
        for _, r in ipairs(rooms) do
            local c = r.centre
            if c and c.x and #(here - vec3(c.x, c.y, c.z)) <= r.radius + 10.0 then
                sleep = 250
                for i, p in ipairs(r.points or {}) do
                    if p.kind == 'mic' then
                        local d = #(here - vec3(p.x, p.y, p.z))
                        local k = key(r.id, i)
                        if d <= (CR.MicReach or 1.6) and not muted[k] and (not bestD or d < bestD) then
                            bestK, bestD = k, d
                            bestRange = p.range or CR.MicRange or r.radius
                            bestLabel = ('%s · %s'):format(r.label, p.label or 'Microphone')
                        end
                    end
                end
            end
        end
        if IsEntityDead(ped) then bestK = nil end
        setMic(bestK, bestRange, bestLabel)
        Wait(sleep)
    end
end)

---------------------------------------------------------------------------
-- Placement (admins): aim a laser, scroll to rotate, arrows to raise or lower, E to place.
---------------------------------------------------------------------------
local function rotToDir(rot)
    local z, x = math.rad(rot.z), math.rad(rot.x)
    local n = math.abs(math.cos(x))
    return vec3(-math.sin(z) * n, math.cos(z) * n, math.sin(x))
end

local function aim()
    local from = GetGameplayCamCoord()
    local to = from + rotToDir(GetGameplayCamRot(2)) * 12.0
    local ray = StartExpensiveSynchronousShapeTestLosProbe(from.x, from.y, from.z, to.x, to.y, to.z, -1, PlayerPedId(), 4)
    local _, hit, at = GetShapeTestResult(ray)
    return hit == 1 and at or nil
end

local function place(kind, withProp, model)
    if placing then return nil end
    placing = true
    local ghost
    if withProp or kind == 'screen' then
        local hash = loadModel(propFor({ kind = kind, model = model }))
        if hash then
            local p = GetEntityCoords(PlayerPedId())
            ghost = CreateObjectNoOffset(hash, p.x, p.y, p.z, false, false, false)
            SetEntityAlpha(ghost, 170, false)
            SetEntityCollision(ghost, false, false)
            FreezeEntityPosition(ghost, true)
            SetModelAsNoLongerNeeded(hash)
        end
    end
    local heading, lift = GetEntityHeading(PlayerPedId()), 0.0
    SendNUIMessage({ action = 'hint', text = ('Placing %s · aim at the spot · scroll to rotate · ↑/↓ raise or lower · E to place · Backspace to cancel')
        :format(kind == 'laptop' and 'a laptop' or kind == 'custody' and 'the custody desk' or kind == 'screen' and 'a screen' or 'a microphone') })
    local result
    while true do
        Wait(0)
        DisableControlAction(0, 24, true); DisableControlAction(0, 25, true)
        DisableControlAction(0, 14, true); DisableControlAction(0, 15, true)
        DisableControlAction(0, 140, true); DisableControlAction(0, 141, true); DisableControlAction(0, 142, true)
        local at = aim()
        if IsDisabledControlPressed(0, 15) then heading = (heading + 4.0) % 360 end
        if IsDisabledControlPressed(0, 14) then heading = (heading - 4.0) % 360 end
        if IsControlPressed(0, 172) then lift = math.min(1.5, lift + 0.005) end
        if IsControlPressed(0, 173) then lift = math.max(-0.5, lift - 0.005) end
        if at then
            local c = at + vec3(0.0, 0.0, lift)
            DrawMarker(28, c.x, c.y, c.z, 0, 0, 0, 0, 0, 0, 0.08, 0.08, 0.08, 255, 221, 0, 220, false, false, 2, false, nil, nil, false)
            local f = c + vec3(-math.sin(math.rad(heading)) * 0.35, math.cos(math.rad(heading)) * 0.35, 0.0)
            DrawLine(c.x, c.y, c.z, f.x, f.y, f.z, 29, 112, 184, 255)
            if kind == 'mic' then
                DrawMarker(1, c.x, c.y, c.z - 0.9, 0, 0, 0, 0, 0, 0, (CR.MicReach or 1.6) * 2, (CR.MicReach or 1.6) * 2, 0.15, 0, 112, 60, 90, false, false, 2, false, nil, nil, false)
            end
            if ghost then SetEntityCoordsNoOffset(ghost, c.x, c.y, c.z, false, false, false) SetEntityHeading(ghost, heading) end
            if IsControlJustReleased(0, 38) then
                result = { x = c.x, y = c.y, z = c.z, h = heading }
                break
            end
        end
        if IsControlJustReleased(0, 177) or IsControlJustReleased(0, 200) then break end
    end
    if ghost and DoesEntityExist(ghost) then DeleteEntity(ghost) end
    SendNUIMessage({ action = 'hint', text = false })
    placing = false
    return result
end

---------------------------------------------------------------------------
-- Picking an object that's already in the map (MLO furniture): aim at it, it's outlined, E selects it.
---------------------------------------------------------------------------
local KNOWN = {}   -- model hash -> readable name, for the hint
CreateThread(function()
    for _, m in ipairs(CR.ScreenModels or {}) do KNOWN[joaat(m.model)] = m.label or m.model end
    if CR.LaptopProp then KNOWN[joaat(CR.LaptopProp)] = CR.LaptopProp end
    if CR.MicProp then KNOWN[joaat(CR.MicProp)] = CR.MicProp end
end)

local function modelName(hash)
    return KNOWN[hash] or ('model 0x%08X'):format(hash & 0xFFFFFFFF)
end

local function aimEntity()
    local from = GetGameplayCamCoord()
    local to = from + rotToDir(GetGameplayCamRot(2)) * 15.0
    -- 16 = objects; also try everything, as some MLO furniture only answers the full probe.
    for _, flags in ipairs({ 16, -1 }) do
        local ray = StartExpensiveSynchronousShapeTestLosProbe(from.x, from.y, from.z, to.x, to.y, to.z, flags, PlayerPedId(), 4)
        local _, hit, at, _, ent = GetShapeTestResult(ray)
        if hit == 1 and ent and ent ~= 0 and DoesEntityExist(ent) and GetEntityType(ent) == 3 then return ent, at end
    end
end

local function setOutline(ent, on)
    if not ent or not DoesEntityExist(ent) then return end
    SetEntityDrawOutline(ent, on)
    if on then
        SetEntityDrawOutlineColor(255, 221, 0, 255)
        SetEntityDrawOutlineShader(1)
    end
end

--- Returns { x, y, z, h, modelHash } for the chosen object, or nil if cancelled.
local function pick(kind)
    if placing then return nil end
    placing = true
    local what = kind == 'screen' and 'the TV' or kind == 'laptop' and 'the laptop or computer' or kind == 'custody' and 'the custody desk computer' or 'the microphone'
    local lit, result, lastHint
    while true do
        Wait(0)
        DisableControlAction(0, 24, true); DisableControlAction(0, 25, true)
        DisableControlAction(0, 140, true); DisableControlAction(0, 141, true); DisableControlAction(0, 142, true)
        local ent = aimEntity()
        if ent ~= lit then
            setOutline(lit, false)
            setOutline(ent, true)
            lit = ent
        end
        local hint = ent and ('Selecting %s · %s · E to use this · Backspace to cancel'):format(what, modelName(GetEntityModel(ent)))
            or ('Aim at %s in the room · Backspace to cancel'):format(what)
        if hint ~= lastHint then SendNUIMessage({ action = 'hint', text = hint }) lastHint = hint end
        if ent then
            local c = GetEntityCoords(ent)
            DrawMarker(28, c.x, c.y, c.z, 0, 0, 0, 0, 0, 0, 0.05, 0.05, 0.05, 255, 221, 0, 220, false, false, 2, false, nil, nil, false)
            if IsControlJustReleased(0, 38) then
                result = { x = c.x, y = c.y, z = c.z, h = GetEntityHeading(ent), modelHash = GetEntityModel(ent) }
                break
            end
        end
        if IsControlJustReleased(0, 177) or IsControlJustReleased(0, 200) then break end
    end
    setOutline(lit, false)
    SendNUIMessage({ action = 'hint', text = false })
    placing = false
    return result
end

-- Shared with client/boards.lua (listing boards use the same placing tools).
MoJPlace = { place = function(...) return place(...) end, pick = function(...) return pick(...) end }

---------------------------------------------------------------------------
-- Editor (/courtrooms): the NUI talks to the server through here.
---------------------------------------------------------------------------
local function openEditor(roomId)
    local r = lib.callback.await('vinewood-moj:server:roomsAdmin', false, 'list')
    if not r or r.error then
        return lib.notify({ title = Config.ServiceName, description = r and r.error or 'No response.', type = 'error' })
    end
    MoJUI.Open('rooms', nil, { roomId = roomId })
end

if CR.AdminCommand then RegisterCommand(CR.AdminCommand, function() openEditor() end, false) end

RegisterNUICallback('rooms', function(d, cb)
    cb(lib.callback.await('vinewood-moj:server:roomsAdmin', false, d.action, d.data) or { error = 'No response.' })
end)

-- Leave the editor, place a point in the world, save it, come back to the room.
RegisterNUICallback('roomsPlace', function(d, cb)
    cb('ok')
    MoJUI.Suspend()
    CreateThread(function()
        local mode = d.mode or (d.prop and 'spawn' or 'spot')
        local at
        if mode == 'pick' then at = pick(d.kind) else at = place(d.kind, mode == 'spawn', tonumber(d.model)) end
        if at then
            local point = { kind = d.kind, mode = mode, prop = mode == 'spawn', label = d.label, roles = d.roles, range = d.range,
                model = tonumber(d.model), target = d.target }
            for k, v in pairs(at) do point[k] = v end
            -- Screens: fit the picture to this TV before saving (overlay mode).
            if d.kind == 'screen' and MoJScreens and MoJScreens.Overlay() then
                local m = (CR.ScreenModels or {})[point.model or 1]
                local roomLabel
                for _, r in ipairs(rooms) do if r.id == d.id then roomLabel = r.label end end
                point.geo = MoJScreens.Adjust(point, mode == 'spawn' and m and m.model or nil, roomLabel)
            end
            local r = lib.callback.await('vinewood-moj:server:roomsAdmin', false, 'addPoint', { id = d.id, point = point })
            if r and r.error then lib.notify({ title = 'Courtroom', description = r.error, type = 'error' })
            else lib.notify({ title = 'Courtroom', description = 'Placed.', type = 'success' }) end
        end
        Wait(150)
        MoJUI.Open('rooms', nil, { roomId = d.id })
    end)
end)

-- Re-fit the picture on a screen that's already placed.
RegisterNUICallback('roomsAdjust', function(d, cb)
    cb('ok')
    local room, point
    for _, r in ipairs(rooms) do if r.id == d.id then room = r end end
    point = room and room.points[tonumber(d.index) or 0]
    if not point or point.kind ~= 'screen' then return end
    MoJUI.Suspend()
    CreateThread(function()
        local copy = {}
        for k, v in pairs(point) do copy[k] = v end
        local geo = MoJScreens.Adjust(copy, nil, room.label)
        if geo then
            local r = lib.callback.await('vinewood-moj:server:roomsAdmin', false, 'updatePoint', { id = d.id, index = tonumber(d.index), geo = geo })
            if r and r.error then lib.notify({ title = 'Courtroom', description = r.error, type = 'error' })
            else lib.notify({ title = 'Courtroom', description = 'Screen fitted.', type = 'success' }) end
        end
        Wait(150)
        MoJUI.Open('rooms', nil, { roomId = d.id })
    end)
end)
