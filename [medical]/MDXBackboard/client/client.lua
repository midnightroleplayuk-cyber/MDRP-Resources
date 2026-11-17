local MODEL = `combicarrier2`
local placing = false
local loading = false
local activeboard = nil
local previewEntity = nil

local function notify(description, ntype)
    lib.notify({ title = 'Backboard', description = description, type = ntype or 'inform' })
end

local function camDirection()
    local rot = GetGameplayCamRot(2)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

local function raycast(ignore)
    local cam = GetGameplayCamCoord()
    local dest = cam + (camDirection() * 12.0)
    local handle = StartShapeTestRay(cam.x, cam.y, cam.z, dest.x, dest.y, dest.z, 1, ignore or PlayerPedId(), 0)
    local _, hit, coords = GetShapeTestResult(handle)
    if hit == 1 then
        return true, coords
    end
    return false, dest
end

local function loadModel(model)
    if HasModelLoaded(model) then
        return true
    end
    RequestModel(model)
    local timeout = GetGameTimer() + 4000
    while not HasModelLoaded(model) do
        if GetGameTimer() > timeout then
            return false
        end
        Wait(0)
    end
    return true
end

local function deleteEntity(ent)
    if ent and DoesEntityExist(ent) then
        SetEntityAsMissionEntity(ent, true, true)
        DeleteEntity(ent)
    end
end

local function closestPlayerNear(coords, maxDist)
    local closest, closestDist, closestId
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if ped ~= PlayerPedId() and DoesEntityExist(ped) then
            local dist = #(GetEntityCoords(ped) - coords)
            if dist <= maxDist and (not closestDist or dist < closestDist) then
                closest = ped
                closestDist = dist
                closestId = GetPlayerServerId(player)
            end
        end
    end
    return closest, closestId
end

local function attachBoardToPed(board, ped)
    local bone = GetPedBoneIndex(ped, 0)
    AttachEntityToEntity(board, ped, bone, 0.0, -0.1, 0.0, 2.0, 78.0, 92.0, false, false, false, false, 2, true)
end

local function ensureControl(entity)
    if not entity or not DoesEntityExist(entity) then return false end
    local timeout = GetGameTimer() + 1500
    while not NetworkHasControlOfEntity(entity) and GetGameTimer() < timeout do
        NetworkRequestControlOfEntity(entity)
        Wait(0)
    end
    return NetworkHasControlOfEntity(entity)
end

local function cannotPlace()
    local ped = PlayerPedId()
    return IsEntityDead(ped) or IsPedInAnyVehicle(ped, false) or IsPedRagdoll(ped)
        or IsPedCuffed(ped) or LocalPlayer.state.onBackboard
end

local function runPlacement()
    if placing then
        notify('You are already placing a backboard.', 'error')
        return
    end
    if cannotPlace() then
        notify('You cannot place a backboard right now.', 'error')
        return
    end
    if not loadModel(MODEL) then
        notify('Backboard model failed to load.', 'error')
        return
    end

    placing = true
    local heading = GetEntityHeading(PlayerPedId())
    local preview = CreateObject(MODEL, 0.0, 0.0, 0.0, false, false, false)
    previewEntity = preview
    SetEntityCollision(preview, false, false)
    SetEntityAlpha(preview, 180, false)

    local confirmed = false
    local stopPlacement = false
    repeat
        placing = true
        confirmed = false
        lib.showTextUI('[E] Place    [Scroll] Rotate    [Left/Right] Turn    [Backspace] Cancel')

        while placing do
            if cannotPlace() then
                stopPlacement = true
                placing = false
                break
            end
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 14, true)
            DisableControlAction(0, 15, true)
            DisableControlAction(0, 37, true)

            local _, coords = raycast(preview)
            if coords then
                SetEntityCoordsNoOffset(preview, coords.x, coords.y, coords.z, false, false, false)
                SetEntityHeading(preview, heading)
            end

            if IsDisabledControlJustPressed(0, 14) then
                heading = heading + 5.0
            elseif IsDisabledControlJustPressed(0, 15) then
                heading = heading - 5.0
            end
            if IsControlPressed(0, 174) then
                heading = heading - 1.0
            elseif IsControlPressed(0, 175) then
                heading = heading + 1.0
            end

            if IsControlJustPressed(0, 38) then
                confirmed = true
                placing = false
            elseif IsControlJustPressed(0, 177) or IsControlJustPressed(0, 202) then
                stopPlacement = true
                placing = false
            end
            Wait(0)
        end

        lib.hideTextUI()
        if stopPlacement then
            break
        end

        placing = true
        local placePos = GetEntityCoords(preview)
        TaskTurnPedToFaceCoord(PlayerPedId(), placePos.x, placePos.y, placePos.z, 600)
        Wait(350)
        local finished = lib.progressCircle({
            duration = 1800,
            label = 'Placing backboard',
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = { move = true, car = true, combat = true },
            anim = {
                dict = 'pickup_object',
                clip = 'pickup_low',
            },
        })
        if finished then
            confirmed = true
            placing = false
            break
        end
        confirmed = false
        notify('Keep positioning the backboard.', 'inform')
    until false

    if not confirmed then
        deleteEntity(preview)
        previewEntity = nil
        placing = false
        return
    end

    local pos = GetEntityCoords(preview)
    deleteEntity(preview)
    previewEntity = nil

    local board = CreateObject(MODEL, pos.x, pos.y, pos.z, true, true, false)
    SetModelAsNoLongerNeeded(MODEL)
    SetEntityHeading(board, heading)
    PlaceObjectOnGroundProperly(board)
    FreezeEntityPosition(board, true)
    SetEntityCollision(board, true, true)

    local timeout = GetGameTimer() + 3000
    local netId = NetworkGetNetworkIdFromEntity(board)
    while (not netId or netId == 0) and GetGameTimer() < timeout do
        Wait(0)
        netId = NetworkGetNetworkIdFromEntity(board)
    end
    if not netId or netId == 0 then
        deleteEntity(board)
        placing = false
        notify('Could not place the backboard.', 'error')
        return
    end
    SetNetworkIdExistsOnAllMachines(netId, true)
    SetNetworkIdCanMigrate(netId, true)
    TriggerServerEvent('MDXBackboard:Server:placed', netId)
    placing = false
end

RegisterNetEvent('MDXBackboard:Client:UseBackboard', function()
    runPlacement()
end)

exports('useBackboard', function()
    runPlacement()
end)

RegisterNetEvent('MDXBackboard:Client:OccupyBoard', function(netId)
    netId = tonumber(netId)
    if not netId then return end

    local timeout = GetGameTimer() + 3000
    while not NetworkDoesNetworkIdExist(netId) and GetGameTimer() < timeout do
        Wait(0)
    end
    local board = NetworkGetEntityFromNetworkId(netId)
    local animOk = pcall(lib.requestAnimDict, 'anim@gangops@morgue@table@', 2000)
    if not animOk or not board or board == 0 or not DoesEntityExist(board) then
        TriggerServerEvent('MDXBackboard:Server:release')
        return
    end

    local ped = PlayerPedId()
    local start = GetGameTimer()
    while not NetworkHasControlOfEntity(board) and GetGameTimer() - start < 1000 do
        NetworkRequestControlOfEntity(board)
        Wait(0)
    end

    local coords = GetEntityCoords(board)
    local heading = GetEntityHeading(board)
    SetEntityCoords(ped, coords.x, coords.y, coords.z + 0.15, false, false, false, false)
    SetEntityHeading(ped, heading)

    FreezeEntityPosition(board, false)
    attachBoardToPed(board, ped)
    StopAnimTask(ped, 'dead', 'dead_a', 1.0)
    StopAnimTask(ped, 'combat@damage@writhe', 'writhe_loop', 1.0)
    TaskPlayAnim(ped, 'anim@gangops@morgue@table@', 'body_search', 8.0, 8.0, -1, 1, 0.0, false, false, false)
    LocalPlayer.state:set('onBackboard', true, true)
    activeboard = board

    CreateThread(function()
        local missing = 0
        while LocalPlayer.state.onBackboard do
            ped = PlayerPedId()
            if not DoesEntityExist(board) then
                missing = missing + 1
                if missing >= 4 then
                    activeboard = nil
                    TriggerServerEvent('MDXBackboard:Server:release')
                    return
                end
            else
                missing = 0
                if not IsEntityAttachedToEntity(board, ped) then
                    ensureControl(board)
                    attachBoardToPed(board, ped)
                end
            end
            if IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3) or IsEntityPlayingAnim(ped, 'combat@damage@writhe', 'writhe_loop', 3) or not IsEntityPlayingAnim(ped, 'anim@gangops@morgue@table@', 'body_search', 3) then
                StopAnimTask(ped, 'dead', 'dead_a', 1.0)
                StopAnimTask(ped, 'combat@damage@writhe', 'writhe_loop', 1.0)
                TaskPlayAnim(ped, 'anim@gangops@morgue@table@', 'body_search', 8.0, 8.0, -1, 1, 0.0, false, false, false)
            end
            Wait(800)
        end
    end)
end)

RegisterNetEvent('MDXBackboard:Client:StopBackboard', function()
    local ped = PlayerPedId()
    LocalPlayer.state:set('onBackboard', false, true)
    DetachEntity(ped, true, false)
    if activeboard and DoesEntityExist(activeboard) then
        DetachEntity(activeboard, true, false)
        deleteEntity(activeboard)
        activeboard = nil
    end
    if IsEntityPlayingAnim(ped, 'anim@gangops@morgue@table@', 'body_search', 3) then
        ClearPedTasks(ped)
    end
end)

local function registerTargets()
    exports.ox_target:addModel('combicarrier2', {
        {
            label = 'Put closest patient on',
            icon = 'fa-solid fa-user-plus',
            distance = 2.5,
            canInteract = function(entity)
                local state = Entity(entity).state
                return not placing and not loading and state.placedBackboard and not state.backboardOccupied
            end,
            onSelect = function(data)
                local entity = data.entity
                if loading or not entity or not DoesEntityExist(entity) then return end
                local _, serverId = closestPlayerNear(GetEntityCoords(entity), 3.0)
                if not serverId then
                    notify('No patient close enough.', 'error')
                    return
                end
                loading = true
                CreateThread(function()
                    TaskTurnPedToFaceEntity(PlayerPedId(), entity, 600)
                    Wait(300)
                    local finished = lib.progressCircle({
                        duration = 1800,
                        label = 'Loading patient',
                        position = 'bottom',
                        useWhileDead = false,
                        canCancel = true,
                        disable = { move = true, car = true, combat = true },
                        anim = {
                            dict = 'pickup_object',
                            clip = 'pickup_low',
                        },
                    })
                    loading = false
                    if not finished or not DoesEntityExist(entity) then return end
                    TriggerServerEvent('MDXBackboard:Server:putOnBoard', serverId, NetworkGetNetworkIdFromEntity(entity))
                end)
            end,
        },
        {
            label = 'Pick up backboard',
            icon = 'fa-solid fa-hand',
            distance = 2.5,
            canInteract = function(entity)
                local state = Entity(entity).state
                return not placing and state.placedBackboard and not state.backboardOccupied
            end,
            onSelect = function(data)
                TriggerServerEvent('MDXBackboard:Server:pickup', NetworkGetNetworkIdFromEntity(data.entity))
            end,
        },
    })

    exports.ox_target:addGlobalPlayer({
        {
            label = 'Remove backboard',
            icon = 'fa-solid fa-xmark',
            distance = 2.5,
            canInteract = function(entity)
                local playerIndex = NetworkGetPlayerIndexFromPed(entity)
                if playerIndex == -1 then return false end
                local playerState = Player(GetPlayerServerId(playerIndex))
                return playerState and playerState.state.onBackboard
            end,
            onSelect = function(data)
                local serverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                TriggerServerEvent('MDXBackboard:Server:StopBackboard', serverId)
            end,
        },
    })
end

local targetsReady = false
local function ensureTargets()
    if targetsReady then return end
    while GetResourceState('ox_target') ~= 'started' do
        Wait(200)
    end
    if targetsReady then return end
    targetsReady = true
    registerTargets()
end

CreateThread(ensureTargets)

AddEventHandler('onClientResourceStart', function(resource)
    if resource == 'ox_target' then
        CreateThread(ensureTargets)
    end
end)

local function releaseOnRespawn()
    if LocalPlayer.state.onBackboard then
        TriggerServerEvent('MDXBackboard:Server:release')
    end
end
AddEventHandler('hospital:client:RespawnAtHospital', releaseOnRespawn)
AddEventHandler('hospital:client:RespawnAtCoords', releaseOnRespawn)

AddEventHandler('onResourceStop', function(resource)
    if resource == 'ox_target' then
        targetsReady = false
        return
    end
    if resource ~= GetCurrentResourceName() then return end
    if previewEntity then
        deleteEntity(previewEntity)
        lib.hideTextUI()
    end
    if LocalPlayer.state.onBackboard then
        local ped = PlayerPedId()
        LocalPlayer.state:set('onBackboard', false, true)
        DetachEntity(ped, true, false)
        if IsEntityPlayingAnim(ped, 'anim@gangops@morgue@table@', 'body_search', 3) then
            ClearPedTasks(ped)
        end
    end
end)

if Config.Framework == 'Standalone' or Config.Command.enabled then
    RegisterCommand(Config.Command.command, function()
        runPlacement()
    end, false)
end

RegisterCommand(Config.Command.removeCommand, function()
    local _, serverId = closestPlayerNear(GetEntityCoords(PlayerPedId()), 3.0)
    if not serverId then
        notify('No patient close enough.', 'error')
        return
    end
    TriggerServerEvent('MDXBackboard:Server:StopBackboard', serverId)
end, false)
