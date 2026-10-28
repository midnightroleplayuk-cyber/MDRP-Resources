local uiOpen = false
local uiMode
local zoneAdded = false
local zoneId
local tabletObject
local tabletAnimDict
local animationToken = 0

local function stopTabletAnimation()
    animationToken = animationToken + 1
    local ped = PlayerPedId()

    if tabletAnimDict and IsEntityPlayingAnim(ped, tabletAnimDict, 'base', 3) then
        StopAnimTask(ped, tabletAnimDict, 'base', 2.0)
    end
    tabletAnimDict = nil

    if tabletObject and DoesEntityExist(tabletObject) then
        DeleteEntity(tabletObject)
    end
    tabletObject = nil
end

local function startTabletAnimation()
    stopTabletAnimation()
    animationToken = animationToken + 1
    local token = animationToken
    local ped = PlayerPedId()
    local gender = IsPedMale(ped) and 'male' or 'female'
    local animDict = ('amb@code_human_in_bus_passenger_idles@%s@tablet@base'):format(gender)
    local model = joaat('prop_cs_tablet')
    local deadline = GetGameTimer() + 5000

    CreateThread(function()
        RequestAnimDict(animDict)
        RequestModel(model)

        while (not HasAnimDictLoaded(animDict) or not HasModelLoaded(model))
            and GetGameTimer() < deadline do
            Wait(50)
        end

        if not HasAnimDictLoaded(animDict) or not HasModelLoaded(model) then
            print('[uk_complaints] Could not load the tablet animation or prop.')
            SetModelAsNoLongerNeeded(model)
            return
        end

        if token ~= animationToken or not uiOpen or uiMode ~= 'officer' then
            SetModelAsNoLongerNeeded(model)
            RemoveAnimDict(animDict)
            return
        end

        local coords = GetEntityCoords(ped)
        tabletObject = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)
        if not tabletObject or not DoesEntityExist(tabletObject) then
            print('[uk_complaints] Could not create the tablet prop.')
            SetModelAsNoLongerNeeded(model)
            RemoveAnimDict(animDict)
            return
        end

        SetEntityAsMissionEntity(tabletObject, true, true)
        AttachEntityToEntity(
            tabletObject,
            ped,
            GetPedBoneIndex(ped, 28422),
            0.03, 0.002, -0.0,
            10.0, 160.0, 0.0,
            true, true, false, true, 1, true
        )
        TaskPlayAnim(ped, animDict, 'base', 8.0, -8.0, -1, 49, 0.0, false, false, false)
        tabletAnimDict = animDict
        SetModelAsNoLongerNeeded(model)
        RemoveAnimDict(animDict)
    end)
end

local function openUi(mode)
    if uiOpen then
        if uiMode ~= mode then
            uiMode = mode
            if mode == 'officer' then
                startTabletAnimation()
            else
                stopTabletAnimation()
            end
        end
        SendNUIMessage({ action = 'open', mode = mode })
        return
    end

    uiOpen = true
    uiMode = mode
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', mode = mode })

    if mode == 'officer' then
        startTabletAnimation()
    end
end

local function closeUi()
    if not uiOpen then return end
    uiOpen = false
    uiMode = nil
    stopTabletAnimation()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

RegisterCommand(Config.PublicCommand, function()
    openUi('submit')
end, false)

RegisterCommand(Config.OfficerCommand, function()
    TriggerServerEvent('uk_complaints:requestAccess')
end, false)

RegisterNetEvent('uk_complaints:openPanel', function()
    openUi('officer')
end)

RegisterNetEvent('uk_complaints:notify', function(message, kind)
    lib.notify({
        title = kind == 'success' and 'Success' or kind == 'error' and 'Error' or 'Police complaints',
        description = message,
        type = kind or 'inform',
        duration = 5000
    })
    SendNUIMessage({ action = 'toast', message = message, kind = kind })
end)

RegisterNetEvent('uk_complaints:forceClose', closeUi)

RegisterNUICallback('close', function(_, cb)
    closeUi()
    cb({ ok = true })
end)

RegisterNUICallback('submit', function(data, cb)
    local result = lib.callback.await('uk_complaints:submit', false, data)
    cb(result or { ok = false, message = 'The complaint could not be submitted. Please try again.' })
end)

RegisterNUICallback('refresh', function(_, cb)
    local data = lib.callback.await('uk_complaints:requestData', false)
    SendNUIMessage({ action = 'data', data = data or {} })
    cb({ ok = true })
end)

RegisterNUICallback('setStatus', function(data, cb)
    local result = lib.callback.await('uk_complaints:setStatus', false, data.id, data.status)
    cb(result or { ok = false, message = 'The status could not be updated.' })
end)

RegisterNUICallback('addNote', function(data, cb)
    local result = lib.callback.await('uk_complaints:addNote', false, data.id, data.note)
    cb(result or { ok = false, message = 'The note could not be added.' })
end)

local function addZone()
    if not Config.Desk.Enabled or zoneAdded then return end

    zoneId = exports.ox_target:addSphereZone({
        coords = Config.Desk.Coords,
        radius = Config.Desk.Distance,
        options = {
            {
                name = 'uk_complaints_public',
                icon = Config.Desk.PublicIcon,
                label = Config.Desk.PublicLabel,
                onSelect = function()
                    openUi('submit')
                end
            },
            {
                name = 'uk_complaints_staff',
                icon = Config.Desk.StaffIcon,
                label = Config.Desk.StaffLabel,
                groups = { [Config.PoliceJobName] = Config.Permissions.ReviewAccess },
                onSelect = function()
                    TriggerServerEvent('uk_complaints:requestAccess')
                end
            }
        }
    })
    zoneAdded = true
end

CreateThread(function()
    while GetResourceState('ox_target') ~= 'started' do
        Wait(500)
    end
    addZone()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    stopTabletAnimation()
    if uiOpen then SetNuiFocus(false, false) end
    if zoneAdded then exports.ox_target:removeZone(zoneId) end
end)
