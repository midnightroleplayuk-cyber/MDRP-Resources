-- NDM_PublicDefib client: targets, props, animations and progress bars only.
-- Every action is checked and decided by the server.

local carrying = nil   -- cabinet id we're carrying from
local padsOn = nil     -- server id of the patient our pads are on
local busy = false
local handProp = nil
local cabinetProps = {}

local function notify(msg, kind)
    lib.notify({ title = 'Defibrillator', description = msg, type = kind or 'inform' })
end

local function cabinetState(id)
    local s = GlobalState.NDM_PublicDefib
    return s and s.cabinets and s.cabinets[id] or 'ready', s and s.unlocked
end

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
        lib.showTextUI(('Defibrillator from: %s'):format(Config.Cabinets[carrying].label))
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
-- Cabinets
---------------------------------------------------------------------------
CreateThread(function()
    local restockGroups = Config.Restock.Jobs
    for id, cab in ipairs(Config.Cabinets) do
        local c = cab.coords
        if Config.Blip then
            local blip = AddBlipForCoord(c.x, c.y, c.z)
            SetBlipSprite(blip, Config.Blip.sprite)
            SetBlipColour(blip, Config.Blip.colour)
            SetBlipScale(blip, Config.Blip.scale)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(Config.Blip.label)
            EndTextCommandSetBlipName(blip)
        end

        exports.ox_target:addSphereZone({
            coords = vector3(c.x, c.y, c.z),
            radius = 0.8,
            debug = Config.Debug,
            options = {
                {
                    name = 'NDM_PublicDefib_take_' .. id,
                    icon = 'fa-solid fa-heart-pulse',
                    label = 'Take defibrillator',
                    distance = Config.TakeDistance,
                    canInteract = function() return not carrying and cabinetState(id) == 'ready' end,
                    onSelect = function() run('take', id) end,
                },
                {
                    name = 'NDM_PublicDefib_status_' .. id,
                    icon = 'fa-solid fa-circle-info',
                    label = 'Defibrillator cabinet',
                    distance = Config.TakeDistance,
                    canInteract = function() return not carrying and cabinetState(id) ~= 'ready' end,
                    onSelect = function()
                        local state = cabinetState(id)
                        notify(state == 'out' and 'The defibrillator is in use. Call 111 for an ambulance'
                            or 'Empty: waiting to be restocked by the medical service', 'error')
                    end,
                },
                {
                    name = 'NDM_PublicDefib_return_' .. id,
                    icon = 'fa-solid fa-box-archive',
                    label = 'Return defibrillator',
                    distance = Config.TakeDistance,
                    canInteract = function() return carrying == id and not padsOn end,
                    onSelect = function() run('return', id) end,
                },
                {
                    name = 'NDM_PublicDefib_restock_' .. id,
                    icon = 'fa-solid fa-box-open',
                    label = 'Restock defibrillator',
                    groups = restockGroups,
                    distance = Config.TakeDistance,
                    canInteract = function() return cabinetState(id) == 'restock' end,
                    onSelect = function() run('restock', id) end,
                },
            },
        })
    end
end)

-- optional cabinet props, spawned when close
CreateThread(function()
    while true do
        local pc = GetEntityCoords(cache.ped)
        for id, cab in ipairs(Config.Cabinets) do
            local model = cab.prop or Config.CabinetProp
            if model then
                local c = cab.coords
                local near = #(pc - vector3(c.x, c.y, c.z)) < 80.0
                if near and not cabinetProps[id] then
                    lib.requestModel(model)
                    local obj = CreateObject(model, c.x, c.y, c.z, false, false, false)
                    SetModelAsNoLongerNeeded(model)
                    SetEntityHeading(obj, c.w)
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
        canInteract = function(entity)
            return padsOn and not busy and GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) == padsOn
        end,
        onSelect = function() run('analyse', padsOn) end,
    },
    {
        name = 'NDM_PublicDefib_shock',
        icon = 'fa-solid fa-bolt',
        label = 'Defibrillator: deliver shock',
        distance = Config.Use.Distance,
        canInteract = function(entity)
            return padsOn and not busy and GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) == padsOn
        end,
        onSelect = function() run('shock', padsOn) end,
    },
    {
        name = 'NDM_PublicDefib_remove',
        icon = 'fa-solid fa-xmark',
        label = 'Remove defibrillator pads',
        distance = Config.Use.Distance,
        canInteract = function(entity)
            return padsOn and not busy and GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)) == padsOn
        end,
        onSelect = function() TriggerServerEvent('NDM_PublicDefib:server:removePads') end,
    },
})

---------------------------------------------------------------------------
-- Admin helper
---------------------------------------------------------------------------
RegisterCommand('defibpos', function()
    if not lib.callback.await('NDM_PublicDefib:isAdmin', false) then return end
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
    removeHandProp()
    for _, obj in pairs(cabinetProps) do DeleteEntity(obj) end
    lib.hideTextUI()
end)
