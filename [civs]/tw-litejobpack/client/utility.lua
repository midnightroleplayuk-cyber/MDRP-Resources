local State = Tworst.State
local RequestId = 0
local serverRequests = {}
targetLoaded = false
showBar = false
TriggerServerCallback = function(eventName, ...)
    local prom = promise.new()

    local requestId = RequestId
    serverRequests[requestId] = function(...)
        prom:resolve(...)
    end
    TriggerServerEvent(_event('triggerServerCallback'), eventName, requestId, GetInvokingResource() or "unknown", ...)
    RequestId = RequestId + 1

    return Citizen.Await(prom)
end

RegisterNetEvent(_event('serverCallback'), function(requestId, invoker, ...)
    if not serverRequests[requestId] then
        return print(("[^1ERROR^7] Server Callback with requestId ^5%s^7 Was Called by ^5%s^7 but does not exist.")
            :format(requestId, invoker))
    end

    serverRequests[requestId](...)
    serverRequests[requestId] = nil
end)

jobData = {
    jobname = nil,
    job_grade_name = nil,
    job_grade = nil,
    job_label = nil
}

local Player = {}
local Loaded = false

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    Wait(1000)
    SetPlayerJob()
    TriggerServerEvent(_event('server:loadData'))
    Player = {
        Group = {
            [xPlayer.job.name] = xPlayer.job.grade,
        },
    }

    Loaded = true
    TriggerEvent('interact:groupsChanged', Player.Group)
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    Player = table.wipe(Player)

    TriggerEvent('interact:groupsChanged', {})
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    Wait(1000)
    SetPlayerJob()
    TriggerServerEvent(_event('server:loadData'))
end)

local tmcClientLoaded = false
RegisterNetEvent("TMC:Client:OnPlayerLoaded")
AddEventHandler("TMC:Client:OnPlayerLoaded", function()
    if tmcClientLoaded then return end
    tmcClientLoaded = true
    Wait(1000)
    SetPlayerJob()
    TriggerServerEvent(_event('server:loadData'))
end)

RegisterNetEvent("TMC:Client:OnPlayerSpawned")
AddEventHandler("TMC:Client:OnPlayerSpawned", function()
    if tmcClientLoaded then return end
    tmcClientLoaded = true
    Wait(1000)
    SetPlayerJob()
    TriggerServerEvent(_event('server:loadData'))
end)

-- vRP player loaded — multiple event names for cross-fork compatibility.
-- Different vRP forks fire different events; we listen to all known ones.
-- Server-side has its own vRP:playerSpawn handler as the primary path; these
-- client handlers are a fallback for forks where server events don't fire.
local vrpClientLoaded = false
local function vrpClientTriggerLoad()
    if vrpClientLoaded then return end
    vrpClientLoaded = true
    Wait(1000)
    TriggerServerEvent(_event('server:loadData'))
end

AddEventHandler("vRP:Active", function() vrpClientTriggerLoad() end)
AddEventHandler("vRP:playerSpawn", function(first_spawn) vrpClientTriggerLoad() end)
AddEventHandler("vRP:NUIready", function() vrpClientTriggerLoad() end)

if Config.Framework == 'standalone' then
    CreateThread(function()
        Wait(1000)
        TriggerServerEvent(_event('server:loadData'))
    end)
end

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    Player = table.wipe(Player)

    TriggerEvent('interact:groupsChanged', {})
end)

RegisterNetEvent('TMC:Client:OnPlayerUnloaded', function()
    tmcClientLoaded = false
    Player = table.wipe(Player)
    TriggerEvent('interact:groupsChanged', {})
end)

RegisterNetEvent('esx:setPlayerData', function(key, value)
    if not Loaded or GetInvokingResource() ~= 'es_extended' then return end

    if key ~= 'job' then return end

    Player.Group = { [value.name] = value.grade }

    TriggerEvent('interact:groupsChanged', Player.Group)
end)

CreateThread(function()
    if Config.Framework == 'standalone' then
        Core = true
    elseif Config.Framework ~= 'vrp' and Config.Framework ~= 'vrp2' then
        Core = GetCore()
    else
        Core = true
    end

    SetPlayerJob()
end)

AddEventHandler('onResourceStart', function(resource)
    if (resource == GetCurrentResourceName()) then
        Wait(3000)

        TriggerServerEvent(_event('server:loadData'))
    end
end)

function SetPlayerJob()
    while Core == nil do
        Wait(0)
    end
    Wait(500)
    while not nuiLoaded do
        Wait(50)
    end
    if not WaitPlayer() then return end

    if Config.Framework == 'standalone' then
        jobData.jobname = "scrapyard"
        jobData.job_grade_name = "Scrapyard Worker"
        jobData.job_grade = 0
    elseif Config.Framework == 'esx' or Config.Framework == 'oldesx' then
        local PlayerData = Core.GetPlayerData()
        jobData.jobname = PlayerData.job.name
        jobData.job_grade_name = PlayerData.job.label
        jobData.job_grade = tonumber(PlayerData.job.grade)
    elseif Config.Framework == 'qb' or Config.Framework == 'oldqb' then
        local PlayerData = Core.Functions.GetPlayerData()
        jobData.jobname = PlayerData["job"].name
        jobData.job_grade_name = PlayerData["job"].label
        jobData.job_grade = PlayerData["job"].grade.level
    elseif Config.Framework == 'tmc' then
        local job, grade = Core.Functions.IsOnDuty()
        if job then
            jobData.jobname = job
            jobData.job_grade_name = job
            jobData.job_grade = grade or 0
        else
            jobData.jobname = "unemployed"
            jobData.job_grade_name = "Unemployed"
            jobData.job_grade = 0
        end
    elseif Config.Framework == 'vrp' or Config.Framework == 'vrp2' then
        jobData.jobname = "scrapyard"
        jobData.job_grade_name = "Scrapyard"
        jobData.job_grade = 0
    end
end

function WaitPlayer()
    if Config.Framework == 'standalone' then
        return true
    elseif Config.Framework == "esx" or Config.Framework == 'oldesx' then
        local timeout = GetGameTimer() + 30000
        while Core == nil and GetGameTimer() < timeout do Wait(100) end
        while Core and Core.GetPlayerData() == nil and GetGameTimer() < timeout do Wait(100) end
        while Core and Core.GetPlayerData() and Core.GetPlayerData().job == nil and GetGameTimer() < timeout do Wait(100) end
        if GetGameTimer() >= timeout then
            print('[tw-litejobpack] WaitPlayer: player data not yet available, will retry when character loads')
            return false
        end
        return true
    elseif Config.Framework == "qb" or Config.Framework == "oldqb" then
        local timeout = GetGameTimer() + 30000
        while Core == nil and GetGameTimer() < timeout do Wait(100) end
        while Core and Core.Functions.GetPlayerData() == nil and GetGameTimer() < timeout do Wait(100) end
        while Core and Core.Functions.GetPlayerData() and Core.Functions.GetPlayerData().metadata == nil and GetGameTimer() < timeout do Wait(100) end
        if GetGameTimer() >= timeout then
            print('[tw-litejobpack] WaitPlayer: player data not yet available, will retry when character loads')
            return false
        end
        return true
    elseif Config.Framework == "tmc" then
        local timeout = GetGameTimer() + 30000
        while Core == nil and GetGameTimer() < timeout do Wait(100) end
        while Core and Core.Functions.GetPlayerData() == nil and GetGameTimer() < timeout do Wait(100) end
        while Core and Core.Functions.GetPlayerData() and Core.Functions.GetPlayerData().citizenid == nil and GetGameTimer() < timeout do Wait(100) end
        if GetGameTimer() >= timeout then
            print('[tw-litejobpack] WaitPlayer: player data not yet available, will retry when character loads')
            return false
        end
        return true
    elseif Config.Framework == "vrp" or Config.Framework == "vrp2" then
        return true
    end
    return true
end

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
    Wait(1000)
    SetPlayerJob()
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate")
AddEventHandler("QBCore:Client:OnJobUpdate", function(data)
    Wait(1000)
    SetPlayerJob()
end)

function canOpen()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        return false
    end
    return true
end

function SetBlipAttributes(blip, id)
    SetBlipSprite(blip, 1)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 26)
    ShowNumberOnBlip(blip, id)
    SetBlipShowCone(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(base.resource .. " : " .. id)
    EndTextCommandSetBlipName(blip)
end

RegisterNetEvent(_event('openMenu'), function()
    if canOpen() then
        openJobMenu()
    end
end)

function WaitForModel(model)
    if not IsModelValid(model) then
        return
    end

    if not HasModelLoaded(model) then
        RequestModel(model)
    end

    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) and GetGameTimer() < timeout do
        Citizen.Wait(10)
    end
end

function showProgressBar(title, time)
    if showBar then return end
    showBar = true
    NuiMessage('showProgressBar', { label = title, time = time })

    Citizen.SetTimeout(time * 1000, function()
        showBar = false
    end)
end

function LoadAnimation(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
end

function table.contains(table, element)
    for _i, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function GetVehicles()
    return GetGamePool('CVehicle')
end

function GetVehiclesInArea(coords, maxDistance)
    return EnumerateEntitiesWithinDistance(GetVehicles(), false, coords, maxDistance)
end

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
    local nearbyEntities = {}

    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        local playerPed = PlayerPedId()
        coords = GetEntityCoords(playerPed)
    end
    for k, entity in pairs(entities) do
        local distance = #(coords - GetEntityCoords(entity))

        if distance <= maxDistance then
            nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
        end
    end
    return nearbyEntities
end

function v2(coords) return vec3(coords.x, coords.y, 0.0) end

function CreateProp(modelHash, ...)
    if not IsModelInCdimage(modelHash) then
        return
    end
    RequestModel(modelHash)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(modelHash) and GetGameTimer() < timeout do Wait(10) end
    if not HasModelLoaded(modelHash) then return end
    local obj = CreateObject(modelHash, ...)
    SetModelAsNoLongerNeeded(modelHash)
    return obj
end

function GiveJobClothing()
    if Config.ChangeClothesSystem then
        local gender
        if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
            gender = 'male'
        elseif GetEntityModel(PlayerPedId()) == GetHashKey("mp_f_freemode_01") then
            gender = 'female'
        else
            return
        end
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerEvent("esx_skin:setLastSkin", skin)
        end)

        local clothes = Config.JobClothes[gender]
        if clothes then
            for _i, cloth in ipairs(clothes) do
                for part, id in pairs(cloth) do
                    if part ~= "texture" then
                        ChangeClothes(part, id, cloth.texture)
                    end
                end
            end
        end
    end
end

function ChangeClothes(key, value, texture)
    local playerPed = PlayerPedId()
    value = tonumber(value)
    texture = tonumber(texture)

    if key == 'jacket' then
        SetPedComponentVariation(playerPed, 11, value, texture, 2)
    end
    if key == 'shirt' then
        SetPedComponentVariation(playerPed, 8, value, texture, 2)
    end
    if key == 'arms' then
        SetPedComponentVariation(playerPed, 3, value, texture, 2)
    end
    if key == 'legs' then
        SetPedComponentVariation(playerPed, 4, value, texture, 2)
    end
    if key == 'shoes' then
        SetPedComponentVariation(playerPed, 6, value, texture, 2)
    end
    if key == 'mask' then
        SetPedComponentVariation(playerPed, 1, value, texture, 2)
    end
    if key == 'chain' then
        SetPedComponentVariation(playerPed, 7, value, texture, 2)
    end
    if key == 'decals' then
        SetPedComponentVariation(playerPed, 10, value, texture, 2)
    end
    if key == 'helmet' then
        SetPedPropIndex(playerPed, 0, value, texture, 2)
    end
    if key == 'glasses' then
        SetPedPropIndex(playerPed, 1, value, texture, 2)
    end
    if key == 'watches' then
        SetPedPropIndex(playerPed, 6, value, texture, 2)
    end
    if key == 'bracelets' then
        SetPedPropIndex(playerPed, 7, value, texture, 2)
    end
end

function RefreshSkin()
    Config.RefreshSkin()
end

function waitForClient(cb, errMessage, timeout)
    local value = cb()
    if value ~= nil then return value end

    if timeout or timeout == nil then
        if type(timeout) ~= 'number' then timeout = 1000 end
    end

    local startTime = timeout and GetGameTimer()

    while value == nil do
        Wait(0)

        if timeout then
            local elapsed = GetGameTimer() - startTime
            if elapsed > timeout then
                return error(('%s (waited %.1fms)'):format(errMessage or 'failed to resolve callback', elapsed), 2)
            end
        end

        value = cb()
    end

    return value
end

local function CreateNPCCam(targetCoords, targetHeading)
    local cfg = Config.NPCCamera
    local angle = math.rad(targetHeading)
    local sideOffset = cfg.sideOffset or 0.5
    local camX = targetCoords.x - math.sin(angle) * cfg.distance + math.cos(angle) * sideOffset
    local camY = targetCoords.y + math.cos(angle) * cfg.distance + math.sin(angle) * sideOffset
    local camZ = targetCoords.z + cfg.height

    local c = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(c, camX, camY, camZ)
    SetCamRot(c, cfg.pitch, 0.0, targetHeading - 180.0, 2)
    SetCamNearClip(c, 0.1)
    SetCamFarClip(c, 1000.0)
    SetCamFov(c, cfg.fov)
    SetCamDofFnumberOfLens(c, cfg.dofLens)
    SetCamDofFocalLengthMultiplier(c, cfg.dofFocalLength)
    SetCamActive(c, true)
    RenderScriptCams(true, true, cfg.transitionMs, true, true)

    if cfg.hidePlayer then
        local playerPed = PlayerPedId()
        SetEntityAlpha(playerPed, 0, false)
        SetLocalPlayerInvisibleLocally(true)
    end

    return c
end

local function CreatePlayerCam()
    local playerPed = PlayerPedId()
    local targetCoords = GetEntityCoords(playerPed)
    local targetHeading = GetEntityHeading(playerPed)

    local cfg = Config.NPCCamera
    local angle = math.rad(targetHeading)
    local sideOffset = cfg.sideOffset or 0.0
    local camX = targetCoords.x - math.sin(angle) * cfg.distance + math.cos(angle) * sideOffset
    local camY = targetCoords.y + math.cos(angle) * cfg.distance + math.sin(angle) * sideOffset
    local camZ = targetCoords.z + cfg.height

    local c = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(c, camX, camY, camZ)
    SetCamRot(c, cfg.pitch, 0.0, targetHeading - 180.0, 2)
    SetCamNearClip(c, 0.1)
    SetCamFarClip(c, 1000.0)
    SetCamFov(c, cfg.fov)
    SetCamDofFnumberOfLens(c, cfg.dofLens)
    SetCamDofFocalLengthMultiplier(c, cfg.dofFocalLength)
    SetCamActive(c, true)
    RenderScriptCams(true, true, cfg.transitionMs, true, true)

    if cfg.hidePlayer then
        SetEntityAlpha(playerPed, 0, false)
        SetLocalPlayerInvisibleLocally(true)
    end

    return c
end

camTargetPed = nil -- the NPC ped the camera is currently pointed at
camFrozenVehicle = nil -- vehicle frozen by CreateFinishCamInternal; ExitCamera must unfreeze even if player has since exited

function CreateCamera(npcPed)
    if cam then return end

    camTargetPed = npcPed
    local cfg = Config.NPCCamera
    if cfg and cfg.enabled and npcPed and DoesEntityExist(npcPed) then
        local targetCoords = GetEntityCoords(npcPed)
        local targetHeading = GetEntityHeading(npcPed)
        cam = CreateNPCCam(targetCoords, targetHeading)
    else
        cam = CreatePlayerCam()
    end

    FreezeEntityPosition(PlayerPedId(), true)
end

local function CreateFinishCamInternal()
    local playerPed = PlayerPedId()
    local inVehicle = IsPedInAnyVehicle(playerPed, false)

    if inVehicle then

        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local vehCoords = GetEntityCoords(vehicle)
        local vehHeading = GetEntityHeading(vehicle)

        local min, max = GetModelDimensions(GetEntityModel(vehicle))
        local vehLength = max.y - min.y
        local vehHeight = math.min(max.z - min.z, 3.0)
        local vehWidth = max.x - min.x

        local isLargeVehicle = vehLength > 6.0 or vehHeight > 2.5

        local dist, heightOffset, fov, pitchAngle
        if isLargeVehicle then
            dist = math.max(5.0, math.min(9.0, vehLength * 1.3 + vehWidth * 0.5))
            heightOffset = math.max(1.2, math.min(2.5, vehHeight * 0.7))
            fov = 55.0
            pitchAngle = -5.0
        else
            dist = math.max(3.5, math.min(7.0, vehLength * 1.2 + vehWidth * 0.5))
            heightOffset = math.max(0.8, math.min(2.0, vehHeight * 0.6))
            fov = 50.0
            pitchAngle = -2.0
        end

        local coords = GetOffsetFromEntityInWorldCoords(vehicle, -vehWidth * 0.8, dist, 0.0)

        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(cam, coords.x, coords.y, coords.z + heightOffset)
        SetCamRot(cam, pitchAngle, 0.0, vehHeading + 180.0, 2)
        SetCamNearClip(cam, 0.1)
        SetCamFarClip(cam, 1000.0)
        SetCamFov(cam, fov)
        SetCamDofFnumberOfLens(cam, 24.0)
        SetCamDofFocalLengthMultiplier(cam, 50.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)

        FreezeEntityPosition(vehicle, true)
        camFrozenVehicle = vehicle
    else

        local coords = GetOffsetFromEntityInWorldCoords(playerPed, 0.3, -2.0, 0.0)
        local heading = GetEntityHeading(playerPed)

        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.5)
        SetCamRot(cam, -2.0, 0.0, heading, 2)
        SetCamNearClip(cam, 0.1)
        SetCamFarClip(cam, 1000.0)
        SetCamFov(cam, 40.0)
        SetCamDofFnumberOfLens(cam, 24.0)
        SetCamDofFocalLengthMultiplier(cam, 50.0)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)

        SetEntityHeading(playerPed, heading + 180.0)
        FreezeEntityPosition(playerPed, true)
    end
end

function CreateFinishModalCamera()
    if cam then ExitCamera() end
    CreateFinishCamInternal()
end

function CreateFinishCamera()
    if cam then ExitCamera() end
    CreateFinishCamInternal()
end

function ExitCamera()
    if cam then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(cam, false)
        cam = nil
        camTargetPed = nil
    end

    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, false)
    SetEntityAlpha(playerPed, 255, false)
    SetLocalPlayerInvisibleLocally(false)

    if camFrozenVehicle and DoesEntityExist(camFrozenVehicle) then
        FreezeEntityPosition(camFrozenVehicle, false)
    end
    camFrozenVehicle = nil

    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle and vehicle ~= 0 then
            FreezeEntityPosition(vehicle, false)
        end
    end
end

function ClearCache()

    CoopDataClient = {}
    clientTemp = {}

    if cleanupJobObjects then
        cleanupJobObjects()
    end
end
