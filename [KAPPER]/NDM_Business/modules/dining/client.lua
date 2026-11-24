local SIT_DICT = 'timetable@ron@ig_5_p3'
local SIT_CLIP = 'ig_5_p3_base'
local BLOCKED_WHILE_SEATED = { 21, 22, 23, 24, 25, 30, 31, 32, 33, 34, 35, 44, 140, 141, 142, 257, 263 }

local seatedPoint = nil
local returnCoords = nil
local sitting = false

local function playSitAnim()
    TaskPlayAnim(cache.ped, SIT_DICT, SIT_CLIP, 8.0, -8.0, -1, 1, 0.0, false, false, false)
end

local function leaveSeat(notifyServer)
    if not seatedPoint then return end
    local coords = returnCoords
    seatedPoint, returnCoords = nil, nil

    lib.hideTextUI()
    FreezeEntityPosition(cache.ped, false)
    if not IsEntityDead(cache.ped) then
        ClearPedTasks(cache.ped)
        if coords then SetEntityCoordsNoOffset(cache.ped, coords.x, coords.y, coords.z, false, false, false) end
    end
    RemoveAnimDict(SIT_DICT)
    if notifyServer then pcall(lib.callback.await, 'ndm_business:dining:stand', false) end
end

function NDM.Sit(pointId)
    if seatedPoint or sitting or cache.vehicle then return end
    sitting = true

    CreateThread(function()
        local ok, seat = pcall(lib.callback.await, 'ndm_business:dining:sit', false, { point = pointId })
        if not ok or not seat or not seat.ok then
            sitting = false
            lib.notify({ type = 'error', description = seat and seat.error or 'The server did not respond.' })
            return
        end

        if not pcall(lib.requestAnimDict, SIT_DICT) then
            sitting = false
            pcall(lib.callback.await, 'ndm_business:dining:stand', false)
            lib.notify({ type = 'error', description = 'Could not sit down.' })
            return
        end

        returnCoords = GetEntityCoords(cache.ped)
        seatedPoint = pointId
        sitting = false
        SetEntityCoordsNoOffset(cache.ped, seat.x, seat.y, seat.z, false, false, false)
        SetEntityHeading(cache.ped, seat.heading)
        FreezeEntityPosition(cache.ped, true)
        playSitAnim()
        lib.showTextUI('[E] Stand up')

        local nextPoseCheck = 0
        while seatedPoint == pointId do
            Wait(0)
            for _, control in ipairs(BLOCKED_WHILE_SEATED) do
                DisableControlAction(0, control, true)
            end
            if IsControlJustPressed(0, 38) or IsEntityDead(cache.ped) then
                leaveSeat(true)
                break
            end
            -- Leave eating and drinking animations alone so they can finish.
            if GetGameTimer() >= nextPoseCheck then
                nextPoseCheck = GetGameTimer() + 1000
                if not lib.progressActive() and not IsEntityPlayingAnim(cache.ped, SIT_DICT, SIT_CLIP, 3) then
                    playSitAnim()
                end
            end
        end
    end)
end

function NDM.OpenMenuBoard(pointId)
    CreateThread(function()
        local ok, menu = pcall(lib.callback.await, 'ndm_business:dining:menu', false, { point = pointId })
        if not ok or not menu or not menu.ok then
            lib.notify({ type = 'error', description = menu and menu.error or 'The server did not respond.' })
            return
        end
        if #menu.items == 0 then
            lib.notify({ type = 'inform', description = 'Nothing is on the menu yet.' })
            return
        end

        local options = {}
        for _, item in ipairs(menu.items) do
            options[#options + 1] = {
                title = item.label,
                description = item.available and ('$%d'):format(item.price) or ('$%d · Sold out'):format(item.price),
                icon = 'fa-solid fa-utensils',
                readOnly = true,
            }
        end
        lib.registerContext({ id = 'ndm_business_menu_board', title = ('%s menu'):format(menu.venue), options = options })
        lib.showContext('ndm_business_menu_board')
    end)
end

RegisterNetEvent('ndm_business:points:removed', function(id)
    if seatedPoint == id then
        CreateThread(function() leaveSeat(true) end)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    leaveSeat(false)
end)
