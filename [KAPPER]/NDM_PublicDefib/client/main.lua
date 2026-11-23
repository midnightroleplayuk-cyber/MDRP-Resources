-- NDM_PublicDefib client: targets, props, animations and progress bars only.
-- Every action is checked and decided by the server.

local carrying = nil   -- cabinet id we're carrying from
local padsOn = nil     -- server id of the patient our pads are on
local busy = false
local handProp = nil

local defs = {}        -- [id] = { label, coords, prop, model, placed } from the server
local zones = {}       -- [id] = ox_target zone id
local blips = {}       -- [id] = blip
local cabinetProps = {}-- [id] = entity

local function notify(msg, kind)
    lib.notify({ title = 'Defibrillator', description = msg, type = kind or 'inform' })
end

local function cabinetState(id)
    local s = GlobalState.NDM_PublicDefib
    return s and s.cabinets and s.cabinets[id] or 'ready'
end

local function vec4(t) return vector4(t.x, t.y, t.z, t.w or 0.0) end

---------------------------------------------------------------------------
-- Hand prop
---------------------------------------------------------------------------
local function removeHandProp()
    if handProp and DoesEntityExist(handProp) then DeleteEntity(handProp) end
    handProp = nil
end

local function attachHandProp()
    removeHandProp()
    local p = Config.HandProp
    if not p or not p.model then return end
    lib.requestModel(p.model)
    local c = GetEntityCoords(cache.ped)
    handProp = CreateObject(p.model, c.x, c.y, c.z, true, true, false)
    SetModelAsNoLongerNeeded(p.model)
    AttachEntityToEntity(handProp, cache.ped, GetPedBoneIndex(cache.ped, p.bone), p.offset.x, p.offset.y, p.offset.z,
        p.rotation.x, p.rotation.y, p.rotation.z, true, true, false, true, 1, true)
end

local function refreshTextUI()
    if padsOn then
        lib.showTextUI('Defibrillator: pads on, use the target on the patient')
    elseif carrying then
        lib.showTextUI(('Defibrillator from: %s'):format(defs[carrying] and defs[carrying].label or '?'))
    else
        lib.hideTextUI()
    end
end

RegisterNetEvent('NDM_PublicDefib:client:carry', function(id)
    carrying = id
    if id then attachHandProp() else removeHandProp() padsOn = nil end
    refreshTextUI()
end)

RegisterNetEvent('NDM_PublicDefib:client:session', function(patient)
    padsOn = patient
    if patient then
        removeHandProp()
    elseif carrying then
        attachHandProp()
    end
    refreshTextUI()
end)

---------------------------------------------------------------------------
-- Timed actions
---------------------------------------------------------------------------
local ANIMS = {
    take      = { label = 'Opening the cabinet', dict = 'mini@repair', clip = 'fixing_a_player', flag = 49 },
    ['return'] = { label = 'Putting the defibrillator back', dict = 'mini@repair', clip = 'fixing_a_player', flag = 49 },
    restock   = { label = 'Restocking the cabinet', dict = 'mini@repair', clip = 'fixing_a_player', flag = 49 },
    attach    = { label = 'Attaching the pads', dict = 'amb@medic@standing@tendtodead@idle_a', clip = 'idle_a', flag = 1 },
    analyse   = { label = 'Analysing heart rhythm, don\'t touch the patient', dict = 'amb@medic@standing@kneel@base', clip = 'base', flag = 1 },
    shock     = { label = 'STAND CLEAR, shocking', dict = 'amb@medic@standing@kneel@base', clip = 'base', flag = 1 },
}

local function run(action, arg)
    if busy then return end
    busy = true
    local ok, data = lib.callback.await('NDM_PublicDefib:begin', false, action, arg)
    if not ok then
        busy = false
        return notify(data, 'error')
    end
    local a = ANIMS[action]
    local completed = lib.progressBar({
        duration = data.duration * 1000,
        label = a.label,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { dict = a.dict, clip = a.clip, flag = a.flag },
    })
    if action == 'shock' and completed then
        PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', true)
    end
    local _, msg, kind = lib.callback.await('NDM_PublicDefib:finish', false, data.token, completed)
    busy = false
    if msg then notify(msg, kind) end
end

---------------------------------------------------------------------------
-- Cabinets (built from the server's list, rebuilt when admins add / remove one)
---------------------------------------------------------------------------
-- Where the cabinet model goes. Placed cabinets store it exactly. Config cabinets compute it from
-- coords (where you stand facing the wall): on the wall in front, turned round to face you.
local function propPlacement(def)
    if def.prop then return vector3(def.prop.x, def.prop.y, def.prop.z), def.prop.w end
    local c, o = def.coords, Config.CabinetPropOffset
    local r = math.rad(c.w)
    return vector3(c.x - math.sin(r) * o.forward, c.y + math.cos(r) * o.forward, c.z + o.up), (c.w + 180.0) % 360.0
end

local function removeCabinet(id)
    if zones[id] then exports.ox_target:removeZone(zones[id]) zones[id] = nil end
    if blips[id] then RemoveBlip(blips[id]) blips[id] = nil end
    if cabinetProps[id] then DeleteEntity(cabinetProps[id]) cabinetProps[id] = nil end
end

local function addCabinet(id, def)
    local c = def.coords
    if Config.Blip then
        local blip = AddBlipForCoord(c.x, c.y, c.z)
        SetBlipSprite(blip, Config.Blip.sprite)
        SetBlipColour(blip, Config.Blip.colour)
        SetBlipScale(blip, Config.Blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Config.Blip.label)
        EndTextCommandSetBlipName(blip)
        blips[id] = blip
    end

    zones[id] = exports.ox_target:addSphereZone({
        coords = vector3(c.x, c.y, c.z),
        radius = 0.8,
        debug = Config.Debug,
        options = {
            {
                name = 'NDM_PublicDefib_take',
                icon = 'fa-solid fa-heart-pulse',
                label = 'Take defibrillator',
                distance = Config.TakeDistance,
                canInteract = function() return not carrying and cabinetState(id) == 'ready' end,
                onSelect = function() run('take', id) end,
            },
            {
                name = 'NDM_PublicDefib_status',
                icon = 'fa-solid fa-circle-info',
                label = 'Defibrillator cabinet',
                distance = Config.TakeDistance,
                canInteract = function() return not carrying and cabinetState(id) ~= 'ready' end,
                onSelect = function()
                    notify(cabinetState(id) == 'out' and 'The defibrillator is in use. Call 111 for an ambulance'
                        or 'Empty: waiting to be restocked by the medical service', 'error')
                end,
            },
            {
                name = 'NDM_PublicDefib_return',
                icon = 'fa-solid fa-box-archive',
                label = 'Return defibrillator',
                distance = Config.TakeDistance,
                canInteract = function() return carrying == id and not padsOn end,
                onSelect = function() run('return', id) end,
            },
            {
                name = 'NDM_PublicDefib_restock',
                icon = 'fa-solid fa-box-open',
                label = 'Restock defibrillator',
                groups = Config.Restock.Jobs,
                distance = Config.TakeDistance,
                canInteract = function() return cabinetState(id) == 'restock' end,
                onSelect = function() run('restock', id) end,
            },
        },
    })
end

local function rebuild(list)
    for id in pairs(defs) do removeCabinet(id) end
    defs = {}
    for id, d in pairs(list or {}) do
        defs[id] = { label = d.label, coords = vec4(d.coords), prop = d.prop and vec4(d.prop) or nil,
            model = d.model, placed = d.placed }
        addCabinet(id, defs[id])
    end
    refreshTextUI()
end

AddStateBagChangeHandler('NDM_PublicDefib_defs', 'global', function(_, _, value)
    rebuild(value)
end)

CreateThread(function()
    while not GlobalState.NDM_PublicDefib_defs do Wait(500) end
    rebuild(GlobalState.NDM_PublicDefib_defs)
end)

-- cabinet models, spawned when close
CreateThread(function()
    while true do
        local pc = GetEntityCoords(cache.ped)
        for id, def in pairs(defs) do
            local model = def.model or Config.CabinetProp
            if type(model) == 'string' then model = joaat(model) end
            if model then
                local pos, heading = propPlacement(def)
                local near = #(pc - pos) < 80.0
                if near and not cabinetProps[id] and IsModelInCdimage(model) then
                    lib.requestModel(model)
                    local obj = CreateObject(model, pos.x, pos.y, pos.z, false, false, false)
                    SetModelAsNoLongerNeeded(model)
                    SetEntityCoordsNoOffset(obj, pos.x, pos.y, pos.z, false, false, false)
                    SetEntityHeading(obj, heading)
                    FreezeEntityPosition(obj, true)
                    cabinetProps[id] = obj
                elseif not near and cabinetProps[id] then
                    DeleteEntity(cabinetProps[id])
                    cabinetProps[id] = nil
                end
            end
        end
        Wait(2000)
    end
end)

---------------------------------------------------------------------------
-- Using it on a patient
---------------------------------------------------------------------------
local function isPadsPatient(entity)
    return padsOn and not busy and GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) == padsOn
end

exports.ox_target:addGlobalPlayer({
    {
        name = 'NDM_PublicDefib_attach',
        icon = 'fa-solid fa-heart-pulse',
        label = 'Attach defibrillator pads',
        distance = Config.Use.Distance,
        canInteract = function() return carrying and not padsOn and not busy end,
        onSelect = function(data)
            run('attach', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
        end,
    },
    {
        name = 'NDM_PublicDefib_analyse',
        icon = 'fa-solid fa-wave-square',
        label = 'Defibrillator: analyse',
        distance = Config.Use.Distance,
        canInteract = isPadsPatient,
        onSelect = function() run('analyse', padsOn) end,
    },
    {
        name = 'NDM_PublicDefib_shock',
        icon = 'fa-solid fa-bolt',
        label = 'Defibrillator: deliver shock',
        distance = Config.Use.Distance,
        canInteract = isPadsPatient,
        onSelect = function() run('shock', padsOn) end,
    },
    {
        name = 'NDM_PublicDefib_remove',
        icon = 'fa-solid fa-xmark',
        label = 'Remove defibrillator pads',
        distance = Config.Use.Distance,
        canInteract = isPadsPatient,
        onSelect = function() TriggerServerEvent('NDM_PublicDefib:server:removePads') end,
    },
})

---------------------------------------------------------------------------
-- Admin: raycast placement (/defibplace)
---------------------------------------------------------------------------
local placing = false
local CABINET_HALF_HEIGHT = 0.305 -- model is ~61 cm tall, origin at the bottom of the back panel

local function camRay(maxDist)
    local rot = GetGameplayCamRot(2)
    local from = GetGameplayCamCoord()
    local rx, rz = math.rad(rot.x), math.rad(rot.z)
    local dir = vector3(-math.sin(rz) * math.abs(math.cos(rx)), math.cos(rz) * math.abs(math.cos(rx)), math.sin(rx))
    local to = from + dir * maxDist
    -- 1 = map, 16 = objects
    local handle = StartExpensiveSynchronousShapeTestLosProbe(from.x, from.y, from.z, to.x, to.y, to.z, 17, cache.ped, 4)
    local _, hit, coords, normal = GetShapeTestResult(handle)
    return hit == true or hit == 1, coords, normal
end

local function placeTool()
    if placing then return end
    if not lib.callback.await('NDM_PublicDefib:isAdmin', false) then
        return notify(('No permission (needs the %s ace)'):format(Config.AdminAce), 'error')
    end
    local model = Config.CabinetProp
    if type(model) == 'string' then model = joaat(model) end
    if not model or not IsModelInCdimage(model) then
        return notify('Cabinet model not found. Is the prop resource running?', 'error')
    end

    placing = true
    lib.requestModel(model)
    local pc = GetEntityCoords(cache.ped)
    local ghost = CreateObject(model, pc.x, pc.y, pc.z, false, false, false)
    SetModelAsNoLongerNeeded(model)
    SetEntityCollision(ghost, false, false)
    SetEntityAlpha(ghost, 190, false)
    FreezeEntityPosition(ghost, true)

    lib.showTextUI('[E] Place  \n[Arrow Up/Down] Height  \n[Backspace] Cancel', { position = 'left-center' })

    local height = 0.0
    local result = nil
    while placing do
        DisableControlAction(0, 24, true)  -- attack
        DisableControlAction(0, 25, true)  -- aim
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 141, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 172, true) -- arrow up
        DisableControlAction(0, 173, true) -- arrow down

        local hit, coords, normal = camRay(8.0)
        local onWall = hit and math.abs(normal.z) < 0.35

        if onWall then
            local heading = GetHeadingFromVector_2d(normal.x, normal.y)
            local origin = vector3(coords.x, coords.y, coords.z - CABINET_HALF_HEIGHT + height)
            SetEntityVisible(ghost, true, false)
            SetEntityCoordsNoOffset(ghost, origin.x, origin.y, origin.z, false, false, false)
            SetEntityHeading(ghost, heading)

            if IsDisabledControlJustPressed(0, 172) then height = height + 0.05 end
            if IsDisabledControlJustPressed(0, 173) then height = height - 0.05 end

            if IsControlJustPressed(0, 38) then -- E
                local front = vector3(coords.x, coords.y, origin.z + CABINET_HALF_HEIGHT) + vector3(normal.x, normal.y, 0.0) * 0.25
                result = {
                    prop = { x = origin.x, y = origin.y, z = origin.z, w = heading },
                    coords = { x = front.x, y = front.y, z = front.z, w = heading },
                }
                placing = false
            end
        else
            SetEntityVisible(ghost, false, false)
        end

        if IsControlJustPressed(0, 177) then placing = false end -- backspace
        Wait(0)
    end

    DeleteEntity(ghost)
    lib.hideTextUI()
    refreshTextUI()
    if not result then return notify('Placement cancelled', 'inform') end

    local input = lib.inputDialog('Name this defibrillator cabinet', {
        { type = 'input', label = 'Name', placeholder = 'e.g. Legion Square - north', required = true, max = 48 },
    })
    if not input or not input[1] or input[1] == '' then return notify('Placement cancelled', 'inform') end
    result.label = input[1]
    local ok, msg = lib.callback.await('NDM_PublicDefib:place', false, result)
    notify(msg, ok and 'success' or 'error')
end

RegisterCommand('defibplace', placeTool, false)

---------------------------------------------------------------------------
-- Admin: list / teleport / reset / remove (/defibcabinets)
---------------------------------------------------------------------------
local STATE_LABEL = { ready = 'Ready', out = 'In use', restock = 'Needs restocking' }

local function cabinetMenu()
    local list = lib.callback.await('NDM_PublicDefib:list', false)
    if not list then return end
    local options = {}
    for _, c in ipairs(list) do
        options[#options + 1] = {
            title = c.label,
            description = ('%s · %s'):format(STATE_LABEL[c.state] or c.state, c.placed and 'placed in game' or 'config.lua'),
            icon = 'fa-solid fa-heart-pulse',
            onSelect = function()
                local sub = {
                    {
                        title = 'Teleport here',
                        icon = 'fa-solid fa-location-arrow',
                        onSelect = function()
                            SetEntityCoords(cache.ped, c.coords.x, c.coords.y, c.coords.z, false, false, false, false)
                        end,
                    },
                    {
                        title = 'Reset (ready, defib returned)',
                        icon = 'fa-solid fa-rotate',
                        onSelect = function()
                            local ok, msg = lib.callback.await('NDM_PublicDefib:admin', false, 'reset', c.id)
                            notify(msg, ok and 'success' or 'error')
                        end,
                    },
                }
                if c.placed then
                    sub[#sub + 1] = {
                        title = 'Remove cabinet',
                        icon = 'fa-solid fa-trash',
                        iconColor = '#e03131',
                        onSelect = function()
                            local confirm = lib.alertDialog({
                                header = 'Remove cabinet',
                                content = ('Remove "%s" for good?'):format(c.label),
                                centered = true,
                                cancel = true,
                            })
                            if confirm ~= 'confirm' then return end
                            local ok, msg = lib.callback.await('NDM_PublicDefib:admin', false, 'remove', c.id)
                            notify(msg, ok and 'success' or 'error')
                        end,
                    }
                end
                lib.registerContext({ id = 'NDM_PublicDefib_cabinet', title = c.label, menu = 'NDM_PublicDefib_cabinets', options = sub })
                lib.showContext('NDM_PublicDefib_cabinet')
            end,
        }
    end
    if #options == 0 then options[1] = { title = 'No cabinets yet. Use /defibplace', readOnly = true } end
    lib.registerContext({ id = 'NDM_PublicDefib_cabinets', title = 'Defibrillator cabinets', options = options })
    lib.showContext('NDM_PublicDefib_cabinets')
end

RegisterCommand('defibcabinets', function()
    if not lib.callback.await('NDM_PublicDefib:isAdmin', false) then
        return notify(('No permission (needs the %s ace)'):format(Config.AdminAce), 'error')
    end
    cabinetMenu()
end, false)

-- copy your position for a config.lua cabinet (stand facing the wall)
RegisterCommand('defibpos', function()
    if not lib.callback.await('NDM_PublicDefib:isAdmin', false) then
        return notify(('No permission (needs the %s ace)'):format(Config.AdminAce), 'error')
    end
    local c, h = GetEntityCoords(cache.ped), GetEntityHeading(cache.ped)
    local line = ('vector4(%.2f, %.2f, %.2f, %.1f)'):format(c.x, c.y, c.z, h)
    lib.setClipboard(line)
    notify('Copied ' .. line, 'success')
end, false)

---------------------------------------------------------------------------
-- Start / stop
---------------------------------------------------------------------------
CreateThread(function()
    Wait(2000)
    TriggerServerEvent('NDM_PublicDefib:server:requestState')
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    placing = false
    removeHandProp()
    for id in pairs(defs) do removeCabinet(id) end
    lib.hideTextUI()
end)
