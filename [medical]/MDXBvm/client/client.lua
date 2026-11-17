local bvmActive = false
local bvmTargetCam = nil
local lastUse = 0

local function RotationToDirection(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local absX = math.abs(math.cos(x))
    return vector3(-math.sin(z) * absX, math.cos(z) * absX, math.sin(x))
end

local function GetPedFromServerId(serverId)
    serverId = tonumber(serverId)
    if not serverId then return end
    local player = GetPlayerFromServerId(serverId)
    if not player or player == -1 then return end
    local ped = GetPlayerPed(player)
    if ped and ped ~= 0 then
        return ped
    end
end

local function PlayBvmSound(ped, soundCounter)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local sound = Config.SoundName
    if Config.SoundSystem == 'evo_sound' and GetResourceState('evo_sound_addon') == 'started' then
        exports.evo_sound_addon:PlaySoundOnNetworkEntity(
            'bvm_squeeze_' .. soundCounter,
            ('https://cfx-nui-%s/sounds/bvmSqueeze.ogg'):format(GetCurrentResourceName()),
            0.4,
            false,
            NetworkGetNetworkIdFromEntity(ped)
        )
    elseif Config.SoundSystem == 'InteractSound' or GetResourceState('interact-sound') == 'started' then
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, sound, 0.4)
    elseif Config.SoundSystem == 'TMC' and TMC then
        TMC.Functions.TriggerServerEvent('core_game:playSoundInArea', nil, { soundId = sound, sound = sound, volume = 0.3 }, playerCoords, 5)
    end
end

local function selectTarget()
    local ped = PlayerPedId()
    local targetEntity = nil
    local selectedTarget = nil

    if Config.UseHelperText then
        exports['CHelperText']:CreateHelperText('bvm_target_select', {
            { key = 'E', label = 'Select Target' },
            { key = 'ESC', label = 'Cancel' },
        })
    else
        lib.showTextUI('[E] Select patient   [ESC] Cancel')
    end

    while true do
        Wait(0)

        local camCoords = GetGameplayCamCoord()
        local camRot = GetGameplayCamRot(2)
        local camDir = RotationToDirection(camRot)
        local destCoords = camCoords + (camDir * 10.0)

        local rayHandle = StartShapeTestRay(
            camCoords.x, camCoords.y, camCoords.z,
            destCoords.x, destCoords.y, destCoords.z,
            12, ped, 4
        )

        local _, hit, _, _, hitEntity = GetShapeTestResult(rayHandle)

        targetEntity = nil

        if hit == 1 and hitEntity ~= 0 and IsEntityAPed(hitEntity) and hitEntity ~= ped then
            targetEntity = hitEntity
            local coords = GetEntityCoords(hitEntity)
            DrawMarker(1, coords.x, coords.y, coords.z + 1.2, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 255, 0, 180, false, true, 2, false, nil, nil, false)
        end

        if IsControlJustPressed(0, 38) then
            if targetEntity and targetEntity ~= 0 then
                selectedTarget = targetEntity
            end
            break
        end

        if IsControlJustPressed(0, 200) then
            break
        end
    end

    if Config.UseHelperText then
        exports['CHelperText']:RemoveHelperText('bvm_target_select')
    else
        lib.hideTextUI()
    end

    return selectedTarget
end

local function StartBvm(target)
    if bvmActive then return end
    if not target or target == 0 then
        lib.notify({ title = 'BVM', description = 'No patient selected.', type = 'error' })
        return
    end

    local ped = PlayerPedId()
    local srcAnim = {
        dict = 'mdx@bvmhead',
        name = 'bvmhead_clip',
    }
    local targetAnim = {
        dict = 'anim@gangops@morgue@table@',
        name = 'body_search',
    }

    local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(target))
    if not targetServerId or targetServerId <= 0 then
        lib.notify({ title = 'BVM', description = 'That is not a player.', type = 'error' })
        return
    end

    RequestAnimDict(srcAnim.dict)
    while not HasAnimDictLoaded(srcAnim.dict) do
        Wait(0)
    end

    RequestAnimDict(targetAnim.dict)
    while not HasAnimDictLoaded(targetAnim.dict) do
        Wait(0)
    end

    local hash = joaat('capital_hj_bvm')
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(100)
        RequestModel(hash)
    end
    local bvmProp = CreateObject(hash, GetEntityCoords(ped), true, true, true)
    AttachEntityToEntity(bvmProp, ped, GetPedBoneIndex(ped, 57005), 0.12, 0.06, -0.09, 6.0, 0.0, -96.0, true, true, false, false, 1, true)
    SetModelAsNoLongerNeeded(hash)

    bvmActive = true
    TaskPlayAnim(ped, srcAnim.dict, srcAnim.name, 3.0, 3.0, -1, 1, 0, false, false, false)
    TriggerServerEvent('MDXBvm:Server:PlayBvmTargetAnim', targetServerId, targetAnim.dict, targetAnim.name)

    local attachCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.110, 0.0)
    SetEntityCoordsNoOffset(target, attachCoords.x, attachCoords.y, attachCoords.z, false, false, false)
    SetEntityHeading(target, GetEntityHeading(ped))

    local cam
    local soundCounter = 0

    if Config.UseCam then
        local pedCoords = GetEntityCoords(ped)
        local pedHeading = math.rad(GetEntityHeading(ped))
        local offsetX = 0.027901
        local offsetY = 0.341229
        local offsetZ = -0.317932
        local rotatedX = offsetX * math.cos(pedHeading) - offsetY * math.sin(pedHeading)
        local rotatedY = offsetX * math.sin(pedHeading) + offsetY * math.cos(pedHeading)
        cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', pedCoords.x + rotatedX, pedCoords.y + rotatedY, pedCoords.z + offsetZ, -73.543297, 0.0, 1.259845 + GetEntityHeading(ped), 45.0, true, 2)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)
    end

    if Config.UseHelperText then
        exports['CHelperText']:CreateHelperText('bvm_active', {
            { key = 'E', label = 'Ventilate' },
            { key = 'X', label = 'Stop BVM' },
        })
    else
        lib.showTextUI('[E] Ventilate   [X] Stop')
    end

    CreateThread(function()
        while bvmActive do
            Wait(0)

            if IsControlJustPressed(0, 38) then
                soundCounter = soundCounter + 1
                PlayBvmSound(ped, soundCounter)
                TriggerServerEvent('MDXBvm:Server:Ventilate', targetServerId)
                if Config.MeMessage then
                    ExecuteCommand('me Oxygenating patient')
                end
            end

            if IsControlJustPressed(0, 73) or not DoesEntityExist(target) then
                bvmActive = false
                StopAnimTask(ped, srcAnim.dict, srcAnim.name, 3.0)
                if Config.UseHelperText then
                    exports['CHelperText']:RemoveHelperText('bvm_active')
                else
                    lib.hideTextUI()
                end
                if DoesEntityExist(bvmProp) then
                    DeleteObject(bvmProp)
                end
                if Config.UseCam and cam then
                    RenderScriptCams(false, true, 500, true, true)
                    DestroyCam(cam, false)
                end
                TriggerServerEvent('MDXBvm:Server:StopBvmTarget', targetServerId)
                break
            end
        end
        bvmActive = false
    end)
end

local function UseBvm(targetServerId)
    local now = GetGameTimer()
    if now - lastUse < 1500 or bvmActive then
        return
    end
    lastUse = now
    local target = GetPedFromServerId(targetServerId)
    if not target then
        target = selectTarget()
    end
    StartBvm(target)
end

if Config.Framework == 'Standalone' or Config.Command.enabled then
    RegisterCommand(Config.Command.command, function()
        UseBvm()
    end, false)
end

RegisterNetEvent('MDXBvm:Client:UseBvm', function(targetServerId)
    UseBvm(targetServerId)
end)

exports('useBvm', function()
    UseBvm()
end)

RegisterNetEvent('MDXBvm:Client:PlayBvmTargetAnim', function(dict, name, srcNetId, srcCoords, srcHeading)
    local ped = PlayerPedId()

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end

    local pedHeadingRad = math.rad(srcHeading)
    local offsetX = 0.0
    local offsetY = 1.110
    local rotatedX = offsetX * math.cos(pedHeadingRad) - offsetY * math.sin(pedHeadingRad)
    local rotatedY = offsetX * math.sin(pedHeadingRad) + offsetY * math.cos(pedHeadingRad)
    SetEntityCoordsNoOffset(ped, srcCoords.x + rotatedX, srcCoords.y + rotatedY, srcCoords.z, false, false, false)
    SetEntityHeading(ped, srcHeading)

    Wait(100)

    TaskPlayAnim(ped, dict, name, 3.0, 3.0, -1, 1, 0, false, false, false)

    local pedCoords = GetEntityCoords(ped)
    local pedHeading = math.rad(GetEntityHeading(ped))
    local ox = 0.023924
    local oy = -0.696734
    local oz = -0.762145
    local rx = ox * math.cos(pedHeading) - oy * math.sin(pedHeading)
    local ry = ox * math.sin(pedHeading) + oy * math.cos(pedHeading)
    if Config.UseCam then
        bvmTargetCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', pedCoords.x + rx, pedCoords.y + ry, pedCoords.z + oz, 84.566925, 0.0, -368.031372 + GetEntityHeading(ped), 45.0, true, 2)
        SetCamActive(bvmTargetCam, true)
        RenderScriptCams(true, true, 500, true, true)
    end
end)

RegisterNetEvent('MDXBvm:Client:StopBvmTarget', function()
    if not (BodyDamage and (BodyDamage.isDead or BodyDamage.inLastStand)) then
        ClearPedTasks(PlayerPedId())
    end
    if bvmTargetCam then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(bvmTargetCam, false)
        bvmTargetCam = nil
    end
end)
