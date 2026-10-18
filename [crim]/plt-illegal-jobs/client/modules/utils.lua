
local Nui = require 'client.modules.nui'
local UiConfig = require 'client.modules.ui'

local Utils = {}

Utils._stepBlip = nil

---@param title string
---@param type 'inform'|'error'|'success'|'warning'
---@param duration number
---@param description string
function Utils.notify(title, type, duration, description)
    local ui = Config.UI or {}
    Nui.notify(title, type, duration or (ui.Notify and ui.Notify.DefaultDuration) or 4000, description)
end

function Utils.showTextUI(text, options)
    options = options or {}
    -- After job stop, leftover Wait(0) loops often call show again and stick the prompt.
    if not options.force and not client.currentJob then
        return
    end
    Utils._textUiSeq = (Utils._textUiSeq or 0) + 1
    Utils._textUiVisible = true
    Nui.showTextUI(text, options)
end

function Utils.hideTextUI()
    Utils._textUiSeq = (Utils._textUiSeq or 0) + 1
    local seq = Utils._textUiSeq
    Utils._textUiVisible = false
    Nui.hideTextUI()
    -- Re-hide on following frames to beat racey prompt loops that show once more after cleanup
    CreateThread(function()
        Wait(0)
        if Utils._textUiSeq == seq then Nui.hideTextUI() end
        Wait(100)
        if Utils._textUiSeq == seq then Nui.hideTextUI() end
        Wait(250)
        if Utils._textUiSeq == seq then Nui.hideTextUI() end
    end)
end

---Hard clear used on job stop / abort (ignores in-flight show races).
function Utils.forceHideTextUI()
    Utils._textUiSeq = (Utils._textUiSeq or 0) + 1
    local seq = Utils._textUiSeq
    Utils._textUiVisible = false
    Nui.hideTextUI()
    CreateThread(function()
        for _, delay in ipairs({ 0, 50, 150, 400 }) do
            if delay > 0 then Wait(delay) end
            if Utils._textUiSeq ~= seq then return end
            if not client.currentJob then
                Nui.hideTextUI()
            end
        end
    end)
end

function Utils.toggleHud(state)
    if Editable and Editable.toggleHud then
        local ok, err = pcall(Editable.toggleHud, state)
        if not ok then
            lib.print.error(('[editable] toggleHud failed: %s'):format(err))
        end
    end
end

function Utils.triggerPoliceAlert(key, message, coords)
    if Editable and Editable.policeAlert then
        local ok, err = pcall(Editable.policeAlert, key, message, coords)
        if not ok then
            lib.print.error(('[editable] policeAlert failed: %s'):format(err))
        end
    end
end

---@param plate string
---@param entity number
function Utils.giveVehicleKey(plate, entity)
    if Editable and Editable.giveVehicleKey then
        local ok, err = pcall(Editable.giveVehicleKey, plate, entity)
        if not ok then
            lib.print.error(('[editable] giveVehicleKey failed: %s'):format(err))
        end
        return
    end
    -- Fallback if editable file missing
    if shared.framework ~= 'esx' then
        TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
    end
end

function Utils.removeVehicleKey(plate, entity)
    if Editable and Editable.removeVehicleKey then
        local ok, err = pcall(Editable.removeVehicleKey, plate, entity)
        if not ok then
            lib.print.error(('[editable] removeVehicleKey failed: %s'):format(err))
        end
    end
end

function Utils.setFuel(entity, level)
    if not level then level = 100.0 end
    if shared.isResourceStart('LegacyFuel') then
        exports['LegacyFuel']:SetFuel(entity, level)
    elseif shared.isResourceStart('x-fuel') then
        exports['x-fuel']:SetFuel(entity, level)
    elseif shared.isResourceStart('ps-fuel') then
        exports['ps-fuel']:SetFuel(entity, level)
    elseif shared.isResourceStart('ox_fuel') then
        Entity(entity).state.fuel = level
    else
        SetVehicleFuelLevel(entity, level)
        if DecorExistOn(entity, '_FUEL_LEVEL') then
            DecorSetFloat(entity, '_FUEL_LEVEL', level)
        end
    end
end

---@param model string|number
---@param coords vector3
---@param rotation vector3|number
---@param freeze boolean
---@param isNetwork boolean
---@param doorFlag boolean
---@return integer
function Utils.createObject(model, coords, rotation, freeze, isNetwork, doorFlag)
    if freeze == nil then freeze = true end
    if isNetwork == nil then isNetwork = false end
    if doorFlag == nil then doorFlag = false end
    local hash = type(model) == 'string' and joaat(model) or model
    lib.requestModel(hash)
    local cx = (coords.x or coords[1] or 0.0) + 0.0
    local cy = (coords.y or coords[2] or 0.0) + 0.0
    local cz = (coords.z or coords[3] or 0.0) + 0.0
    local object = CreateObject(hash, cx, cy, cz, isNetwork == true, isNetwork == true, doorFlag == true)
    local timeout = GetGameTimer() + 3000
    while not DoesEntityExist(object) and GetGameTimer() < timeout do Wait(0) end
    if DoesEntityExist(object) then
        SetEntityCoords(object, cx, cy, cz, false, false, false, true)
        if rotation then
            if type(rotation) == 'number' then
                rotation = vector3(0.0, 0.0, rotation + 0.0)
            end
            local rx = (rotation.x or rotation[1] or 0.0) + 0.0
            local ry = (rotation.y or rotation[2] or 0.0) + 0.0
            local rz = (rotation.z or rotation[3] or 0.0) + 0.0
            SetEntityRotation(object, rx, ry, rz, 2, false)
        end
        FreezeEntityPosition(object, freeze == true)
    end
    SetModelAsNoLongerNeeded(hash)
    return object
end

function Utils.getGroundZ(coords)
    -- Use configured Z as-is — GetGroundZFor_3dCoord often returns under-map values.
    local x, y, z = table.unpack(coords)
    return z, true
end

---@param target number|vector3
---@param options table
---@param route boolean
---@param longRange boolean
function Utils.addBlip(target, options, route, longRange)
    local blip = type(target) == 'number' and
        AddBlipForEntity(target) or
        AddBlipForCoord(vector3(target))
    SetBlipDisplay(blip, 4)
    SetBlipSprite(blip, options.sprite or 469)
    SetBlipColour(blip, options.color or 0)
    SetBlipScale(blip, options.scale or 0.85)
    SetBlipAsShortRange(blip, not longRange)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(options.text or 'Undefined')
    EndTextCommandSetBlipName(blip)
    if route then
        local coords = type(target) == 'number' and GetEntityCoords(target) or vector3(target)
        SetNewWaypoint(coords.x, coords.y)
    end
    return blip
end

---Remove shared step blip and clear GPS waypoint (SetNewWaypoint leaves route on map).
function Utils.clearStepWaypoint()
    if Utils._stepBlip then
        if DoesBlipExist(Utils._stepBlip) then
            RemoveBlip(Utils._stepBlip)
        end
        Utils._stepBlip = nil
    end
    SetWaypointOff()
    if DeleteWaypoint then DeleteWaypoint() end
end

---Call once per step start — always points the player at their next objective.
---@param coords vector3|vector4
---@param blipOptions table
function Utils.setStepWaypoint(coords, blipOptions)
    Utils.clearStepWaypoint()
    Utils._stepBlip = Utils.addBlip(coords, blipOptions or {}, true, true)
    return Utils._stepBlip
end

---For multi-stop steps — route to closest unfinished point.
---@param points table[] list of { coords = vector3|vector4 } or vector3/vector4
---@param isFinished fun(p:any):boolean|nil
function Utils.setNearestWaypoint(points, isFinished)
    local playerCoords = GetEntityCoords(cache.ped)
    local nearest, nearestDist = nil, math.huge
    for _, p in pairs(points or {}) do
        if not isFinished or not isFinished(p) then
            local c = p.coords or p
            if c then
                c = vector3(c.x, c.y, c.z)
                local d = #(playerCoords - c)
                if d < nearestDist then
                    nearest, nearestDist = p, d
                end
            end
        end
    end
    if nearest then
        local c = nearest.coords or nearest
        SetNewWaypoint(c.x, c.y)
    end
    return nearest
end

function Utils.drawText3D(coords, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 70, 134, 123, 75)
    ClearDrawOrigin()
end

function Utils.progressBar(data)
    data = UiConfig.applyProgressBar(data)
    return Nui.progressBar(data)
end

---@param jobName string
---@param action string
---@param data table|nil
---@return boolean
function Utils.progressJobBar(jobName, action, data)
    return UiConfig.progressJobBar(jobName, action, data)
end

function Utils.skillCheck(difficulty, inputs)
    return Nui.skillCheck(difficulty, inputs)
end

function Utils.playMinigame(game, opts)
    local resolvedGame, merged = UiConfig.applyMinigame(game, opts)
    return Nui.playMinigame(resolvedGame, merged)
end

---@param jobName string
---@param action string
---@param optsOverride table|nil
---@return boolean
function Utils.playJobMinigame(jobName, action, optsOverride)
    return UiConfig.playJobMinigame(jobName, action, optsOverride)
end

function Utils.playMinigameChain(games, opts)
    opts = opts or {}
    local ui = Config.UI or {}
    local mg = ui.Minigame or {}
    if opts.delay == nil then opts.delay = mg.ChainDelay or 250 end
    if opts.stopOnFail == nil then opts.stopOnFail = mg.ChainStopOnFail ~= false end
    if opts.difficulty == nil then opts.difficulty = mg.DefaultDifficulty or 2 end
    return Nui.playMinigameChain(games, opts)
end

function Utils.inputDialog(heading, fields)
    return Nui.inputDialog(heading, fields)
end

function Utils.alertDialog(opts)
    return Nui.alertDialog(opts)
end

---@param opts table
---@return string|nil
function Utils.npcDialogue(opts)
    return Nui.npcDialogue(opts)
end

--- Make an NPC walk/wander away naturally, then clean up when far (no pop-despawn).
---@param ped number
---@param opts { speed?: number, distance?: number, timeoutMs?: number, flee?: boolean }|nil
function Utils.dismissPedWalkAway(ped, opts)
    if not ped or ped == 0 or not DoesEntityExist(ped) then return end
    opts = opts or {}

    local blip = GetBlipFromEntity(ped)
    if blip and blip ~= 0 then RemoveBlip(blip) end

    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    SetBlockingOfNonTemporaryEvents(ped, false)
    SetPedKeepTask(ped, true)
    ClearPedTasksImmediately(ped)

    local pedCoords = GetEntityCoords(ped)
    local from = GetEntityCoords(cache.ped)
    local dx = pedCoords.x - from.x
    local dy = pedCoords.y - from.y
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 0.15 then
        local rad = math.rad(GetEntityHeading(ped))
        dx, dy = -math.sin(rad), math.cos(rad)
        len = 1.0
    end
    local walkDist = opts.distance or (38.0 + math.random() * 22.0)
    local dest = vector3(
        pedCoords.x + (dx / len) * walkDist,
        pedCoords.y + (dy / len) * walkDist,
        pedCoords.z
    )

    local speed = opts.speed or (opts.flee and 2.0 or 1.15)
    if opts.flee then
        TaskSmartFleePed(ped, cache.ped, walkDist + 40.0, -1, false, false)
    else
        TaskGoStraightToCoord(ped, dest.x, dest.y, dest.z, speed, 20000, 0.0, 0.2)
    end

    CreateThread(function()
        local timeout = GetGameTimer() + (opts.timeoutMs or 22000)
        local start = pedCoords
        while DoesEntityExist(ped) and GetGameTimer() < timeout do
            local pos = GetEntityCoords(ped)
            local awayFromPlayer = #(pos - GetEntityCoords(cache.ped))
            local awayFromStart = #(pos - start)
            if awayFromPlayer >= 32.0 or awayFromStart >= (walkDist * 0.75) then
                break
            end
            -- Keep them moving if the go-to finished early
            if not opts.flee and IsPedStopped(ped) and awayFromStart < 8.0 then
                TaskWanderStandard(ped, 10.0, 10)
            end
            Wait(400)
        end
        if DoesEntityExist(ped) then
            SetEntityAsNoLongerNeeded(ped)
            -- Soft fade: hide then delete so it doesn't pop
            local alpha = 255
            while alpha > 0 and DoesEntityExist(ped) do
                alpha = math.max(0, alpha - 35)
                SetEntityAlpha(ped, alpha, false)
                Wait(40)
            end
            if DoesEntityExist(ped) then
                DeleteEntity(ped)
            end
        end
    end)
end

function Utils.revivePlayerWithAmbulanceScript()
    local ped = cache.ped
    local pos = GetEntityCoords(ped, true)
    local heading = GetEntityHeading(ped)

    NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, heading, true, false)
    SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z, false, false, false)
    SetEntityHeading(ped, heading)
    SetPlayerInvincible(PlayerId(), false)
    SetEntityInvincible(ped, false)
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    ClearPedTasksImmediately(ped)
    SetEntityHealth(ped, math.max(GetEntityMaxHealth(ped), 200))
    SetPedArmour(ped, 0)

    -- Optional framework hooks (safe no-ops if missing)
    TriggerEvent('hospital:client:Revive')
    TriggerEvent('esx_ambulancejob:revive')
    pcall(function()
        if GetResourceState('qbx_medical') == 'started' then
            exports.qbx_medical:Revive()
        end
    end)
end

return Utils
