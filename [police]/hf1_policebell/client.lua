local bell, zone, current, editing = nil, nil, nil, false

local function notify(title, description, kind)
    lib.notify({title = title, description = description, type = kind or 'inform', duration = Config.NotificationDuration, position = 'top-right'})
end

local function loadModel(name)
    local hash = joaat(name)
    if not IsModelInCdimage(hash) or not IsModelValid(hash) then return nil end
    lib.requestModel(hash, 5000)
    if not HasModelLoaded(hash) then return nil end
    return hash
end

local function clearBell()
    if zone then exports.ox_target:removeZone(zone); zone = nil end
    if bell and DoesEntityExist(bell) then DeleteEntity(bell) end
    bell = nil
end

local function spawnBell(p)
    local hash = loadModel(p.model)
    if not hash then
        notify('Police Bell', 'Invalid prop model: ' .. p.model, 'error')
        return nil
    end
    local obj = CreateObjectNoOffset(hash, p.x, p.y, p.z, false, false, false)
    SetEntityRotation(obj, p.rx or 0.0, p.ry or 0.0, p.h, 2, true)
    FreezeEntityPosition(obj, true)
    SetEntityCollision(obj, true, true)
    SetModelAsNoLongerNeeded(hash)
    return obj
end

local function showBell(p)
    current = p
    if editing then return end
    clearBell()
    bell = spawnBell(p)
    if not bell then return end
    zone = exports.ox_target:addSphereZone({
        coords = vec3(p.x, p.y, p.z), radius = Config.TargetRadius,
        options = {{name = 'hf1_policebell_press', icon = 'fa-solid fa-bell', label = 'Press for Attention.',
            distance = Config.InteractDistance,
            onSelect = function() TriggerServerEvent('hf1_policebell:server:press') end}}
    })
end

RegisterNetEvent('hf1_policebell:client:setPlacement', function(p) showBell(p) end)
RegisterNetEvent('hf1_policebell:client:playSound', function(pos)
    if not Config.SoundFile or Config.SoundFile == '' then return end
    local ped = PlayerPedId()
    local distance = #(GetEntityCoords(ped) - vec3(pos.x, pos.y, pos.z))
    local maxDistance = math.max(0.1, Config.SoundDistance or 15.0)
    if distance > maxDistance then return end
    local volume = math.max(0.0, math.min(1.0, Config.SoundVolume or 0.65)) * (1.0 - distance / maxDistance)
    SendNUIMessage({action = 'playBell', file = Config.SoundFile, volume = volume})
end)

RegisterNetEvent('hf1_policebell:client:pressed', function() notify('Police', 'Someone will be with you shortly. Please take a seat.', 'success') end)
RegisterNetEvent('hf1_policebell:client:alertPolice', function() notify('Police Station', 'Someone is at the Front Counter.', 'inform') end)
RegisterNetEvent('hf1_policebell:client:cooldown', function(s) notify('Police', ('Please wait %d seconds before pressing again.'):format(s), 'error') end)
RegisterNetEvent('hf1_policebell:client:denied', function() notify('Police Bell', 'Placement editor is disabled or you lack permission.', 'error') end)
RegisterNetEvent('hf1_policebell:client:saveFailed', function() notify('Police Bell', 'Unable to save placement.json. Check resource write permissions.', 'error') end)
RegisterNetEvent('hf1_policebell:client:saved', function() notify('Police Bell', 'Bell placement saved permanently.', 'success') end)

RegisterCommand('policebellplace', function()
    TriggerServerEvent('hf1_policebell:server:startEditor')
end, false)

RegisterNetEvent('hf1_policebell:client:edit', function(p)
    if editing then return end
    local model = Config.DefaultModel
    local hash = loadModel(model)
    if not hash then notify('Police Bell', 'That prop model is not valid or is not streamed.', 'error'); return end
    editing = true
    clearBell()
    local ped = PlayerPedId()
    local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.0, 0.0)
    local x, y, z = pos.x, pos.y, pos.z
    local rx, ry, h = (p and p.rx) or 0.0, (p and p.ry) or 0.0, (p and p.h) or GetEntityHeading(ped)
    -- Always begin near the editor, even when an old placement exists elsewhere.
    -- Existing rotation is retained for convenient adjustments.
    local ghost = CreateObjectNoOffset(hash, x, y, z, false, false, false)
    if not DoesEntityExist(ghost) then
        editing = false
        notify('Police Bell', 'Could not create preview prop. Check the model and game build.', 'error')
        if current then showBell(current) end
        return
    end
    SetModelAsNoLongerNeeded(hash)
    ResetEntityAlpha(ghost)
    SetEntityVisible(ghost, true, false)
    SetEntityCollision(ghost, false, false)
    FreezeEntityPosition(ghost, true)
    lib.showTextUI('WASD Move | Q/E Height | LEFT/RIGHT Yaw | NUM 8/2 Tilt X | NUM 4/6 Tilt Y | SHIFT Fast | ENTER Save | BACKSPACE Cancel', {position = 'top-center'})
    local saved = false
    while editing do
        Wait(0)
        local fast = IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21)
        local step = fast and 0.045 or 0.012
        local turn = fast and 2.0 or 0.7
        -- Disable movement/combat inputs while editing, but still read them via disabled-control natives.
        for _, key in ipairs({21, 24, 25, 32, 33, 34, 35, 38, 44, 174, 175, 177, 191, 201, 194, 111, 112, 108, 109}) do DisableControlAction(0, key, true) end
        local heading = math.rad(GetGameplayCamRot(2).z)
        local forwardX, forwardY = -math.sin(heading), math.cos(heading)
        local rightX, rightY = math.cos(heading), math.sin(heading)
        if IsDisabledControlPressed(0, 32) then x = x + forwardX * step; y = y + forwardY * step end
        if IsDisabledControlPressed(0, 33) then x = x - forwardX * step; y = y - forwardY * step end
        if IsDisabledControlPressed(0, 34) then x = x - rightX * step; y = y - rightY * step end
        if IsDisabledControlPressed(0, 35) then x = x + rightX * step; y = y + rightY * step end
        if IsDisabledControlPressed(0, 44) then z = z - step end
        if IsDisabledControlPressed(0, 38) then z = z + step end
        if IsDisabledControlPressed(0, 174) then h = (h - turn) % 360 end
        if IsDisabledControlPressed(0, 175) then h = (h + turn) % 360 end
        if IsDisabledControlPressed(0, 111) then rx = (rx + turn) % 360 end
        if IsDisabledControlPressed(0, 112) then rx = (rx - turn) % 360 end
        if IsDisabledControlPressed(0, 108) then ry = (ry + turn) % 360 end
        if IsDisabledControlPressed(0, 109) then ry = (ry - turn) % 360 end
        SetEntityCoordsNoOffset(ghost, x, y, z, false, false, false)
        SetEntityVisible(ghost, true, false)
        DrawMarker(28, x, y, z + 0.08, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.22, 0.22, 0.22, 50, 220, 120, 150, false, false, 2, false, nil, nil, false)
        SetEntityRotation(ghost, rx, ry, h, 2, true)
        if IsDisabledControlJustPressed(0, 191) or IsDisabledControlJustPressed(0, 201) then
            saved = true
            TriggerServerEvent('hf1_policebell:server:save', {model = model, x = x, y = y, z = z, h = h, rx = rx, ry = ry})
            editing = false
        elseif IsDisabledControlJustPressed(0, 177) or IsDisabledControlJustPressed(0, 194) then
            editing = false
        end
    end
    lib.hideTextUI()
    DeleteEntity(ghost)
    if not saved and current then showBell(current) end
    if saved and current then
        -- Rebuild once server broadcasts the saved placement.
    end
end)

CreateThread(function()
    Wait(750)
    TriggerServerEvent('hf1_policebell:server:sync')
end)

AddEventHandler('onResourceStop', function(name)
    if name ~= GetCurrentResourceName() then return end
    if lib.isTextUIOpen() then lib.hideTextUI() end
    clearBell()
end)
