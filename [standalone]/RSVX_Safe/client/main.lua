local safes, props = {}, {}
local placing = false

local function notify(description, kind)
    lib.notify({ description = description, type = kind or 'inform' })
end

-- Safe props ----------------------------------------------------------------
local function openSafe(id)
    local s = safes[id]
    if not s then return end

    local pin
    if s.hasPin and not s.mine then
        local input = lib.inputDialog('Safe', { { type = 'input', label = 'PIN', password = true, required = true } })
        if not input then return end
        pin = input[1]
    end

    local ok, msg = lib.callback.await('rsvx_safe:open', false, id, pin)
    if not ok then notify(msg or 'Locked.', 'error') end
end

local function setPin(id)
    local input = lib.inputDialog('Safe PIN', {
        { type = 'input', label = 'PIN (4-6 digits)', description = 'Leave blank to remove the PIN', password = true },
    })
    if not input then return end
    local ok, msg = lib.callback.await('rsvx_safe:setpin', false, id, input[1] or '')
    notify(msg, ok and 'success' or 'error')
end

local function pickUp(id)
    local answer = lib.alertDialog({
        header = 'Pick up safe',
        content = 'The safe must be empty. You will get the safe item back.',
        centered = true,
        cancel = true,
    })
    if answer ~= 'confirm' then return end
    local ok, msg = lib.callback.await('rsvx_safe:pickup', false, id)
    notify(msg, ok and 'success' or 'error')
end

local function crackSafe(id)
    local R = Config.Robbery
    local ok, msg = lib.callback.await('rsvx_safe:robstart', false, id)
    if not ok then return notify(msg, 'error') end

    local done = lib.progressCircle({
        duration = R.duration,
        label = 'Cracking safe...',
        position = 'bottom',
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { dict = 'mini@safe_cracking', clip = 'dial_turn_anti_fast_1' },
    })
    -- nil = cancelled, so the server doesn't roll the break chance
    local passed = nil
    if done then passed = lib.skillCheck(R.difficulty, R.keys) end
    ClearPedTasks(cache.ped)

    ok, msg = lib.callback.await('rsvx_safe:robfinish', false, id, passed)
    notify(msg, ok and 'success' or 'error')
end

local function spawnSafe(s)
    if props[s.id] then return end
    lib.requestModel(Config.Model)
    local obj = CreateObjectNoOffset(Config.Model, s.x, s.y, s.z, false, false, false)
    SetEntityHeading(obj, s.h)
    FreezeEntityPosition(obj, true)
    props[s.id] = obj

    local function mine() return safes[s.id] and safes[s.id].mine end
    exports.ox_target:addLocalEntity(obj, {
        { label = 'Open safe', icon = 'fa-solid fa-vault', distance = 2.0, onSelect = function() openSafe(s.id) end },
        { label = 'Set PIN', icon = 'fa-solid fa-key', distance = 2.0, canInteract = mine, onSelect = function() setPin(s.id) end },
        { label = 'Pick up safe', icon = 'fa-solid fa-hand', distance = 2.0, canInteract = mine, onSelect = function() pickUp(s.id) end },
        {
            label = 'Crack safe', icon = 'fa-solid fa-unlock', distance = 2.0, items = Config.Robbery.item,
            canInteract = function() return Config.Robbery.enabled and not mine() end,
            onSelect = function() crackSafe(s.id) end,
        },
    })
end

local function despawnSafe(id)
    local obj = props[id]
    if not obj then return end
    exports.ox_target:removeLocalEntity(obj)
    if DoesEntityExist(obj) then DeleteEntity(obj) end
    props[id] = nil
end

local function track(s)
    if safes[s.id] then return end
    safes[s.id] = s
    s.point = lib.points.new({
        coords = vec3(s.x, s.y, s.z),
        distance = 80.0,
        onEnter = function() spawnSafe(s) end,
        onExit = function() despawnSafe(s.id) end,
    })
end

local function untrack(id)
    local s = safes[id]
    if not s then return end
    s.point:remove()
    despawnSafe(id)
    safes[id] = nil
end

RegisterNetEvent('rsvx_safe:add', track)
RegisterNetEvent('rsvx_safe:remove', untrack)
RegisterNetEvent('rsvx_safe:pin', function(id, hasPin)
    if safes[id] then safes[id].hasPin = hasPin end
end)

CreateThread(function()
    local list
    repeat
        list = lib.callback.await('rsvx_safe:sync', false)
        if not list then Wait(1000) end
    until list
    for _, s in ipairs(list) do track(s) end
end)

-- Placement -----------------------------------------------------------------
local function aimPoint()
    local cam = GetGameplayCamCoord()
    local rot = GetGameplayCamRot(2)
    local rx, rz = math.rad(rot.x), math.rad(rot.z)
    local cx = math.abs(math.cos(rx))
    local dest = cam + vec3(-math.sin(rz) * cx, math.cos(rz) * cx, math.sin(rx)) * 10.0
    local ray = StartExpensiveSynchronousShapeTestLosProbe(cam.x, cam.y, cam.z, dest.x, dest.y, dest.z, 1, cache.ped, 4)
    local _, hit, endCoords = GetShapeTestResult(ray)
    return hit == 1, endCoords
end

local function startPlacing()
    if placing then return end
    if IsPedInAnyVehicle(cache.ped, false) or IsEntityDead(cache.ped) then
        return notify('You cannot place a safe right now.', 'error')
    end
    placing = true

    lib.requestModel(Config.Model)
    local obj = CreateObject(Config.Model, GetEntityCoords(cache.ped), false, false, false)
    SetEntityCollision(obj, false, false)
    FreezeEntityPosition(obj, true)

    local heading = GetEntityHeading(cache.ped)
    local coords, shown
    local result

    local function hint(text)
        if text ~= shown then
            shown = text
            lib.showTextUI(text)
        end
    end

    while placing do
        local hit, point = aimPoint()
        local valid = false
        if hit then
            SetEntityCoordsNoOffset(obj, point.x, point.y, point.z, false, false, false)
            SetEntityHeading(obj, heading)
            PlaceObjectOnGroundProperly(obj)
            coords = GetEntityCoords(obj)
            valid = #(coords - GetEntityCoords(cache.ped)) <= Config.PlaceDistance
        end
        SetEntityAlpha(obj, valid and 190 or 80, false)

        hint(valid and '[E] Place  |  [←/→] Rotate  |  [Backspace] Cancel'
            or 'Too far or no surface  |  [Backspace] Cancel')

        DisableControlAction(0, 24, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 141, true)
        DisableControlAction(0, 142, true)

        if IsControlPressed(0, 174) then heading = (heading + 2.0) % 360.0 end
        if IsControlPressed(0, 175) then heading = (heading - 2.0) % 360.0 end

        if IsControlJustPressed(0, 38) and valid then
            result = true
            placing = false
        elseif IsControlJustPressed(0, 177) or IsEntityDead(cache.ped) then
            placing = false
        end
        Wait(0)
    end

    lib.hideTextUI()
    DeleteEntity(obj)

    if result then
        local ok, msg = lib.callback.await('rsvx_safe:place', false, coords, heading)
        notify(msg, ok and 'success' or 'error')
    end
end

-- ox_inventory item `client.event`
RegisterNetEvent('rsvx_safe:use', startPlacing)

-- Shop ----------------------------------------------------------------------
local shopPed

lib.points.new({
    coords = Config.Shop.coords.xyz,
    distance = 60.0,
    onEnter = function()
        local sh = Config.Shop
        lib.requestModel(sh.model)
        shopPed = CreatePed(0, sh.model, sh.coords.x, sh.coords.y, sh.coords.z - 1.0, sh.coords.w, false, false)
        SetEntityInvincible(shopPed, true)
        SetBlockingOfNonTemporaryEvents(shopPed, true)
        FreezeEntityPosition(shopPed, true)
        exports.ox_target:addLocalEntity(shopPed, {
            {
                label = ('Buy a safe ($%s)'):format(Config.Price),
                icon = 'fa-solid fa-vault',
                distance = 2.5,
                onSelect = function()
                    local ok, msg = lib.callback.await('rsvx_safe:buy', false)
                    notify(msg, ok and 'success' or 'error')
                end,
            },
        })
    end,
    onExit = function()
        if shopPed then
            exports.ox_target:removeLocalEntity(shopPed)
            if DoesEntityExist(shopPed) then DeleteEntity(shopPed) end
            shopPed = nil
        end
    end,
})

CreateThread(function()
    if not Config.Shop.showBlip then return end
    local b = Config.Shop.blip
    local blip = AddBlipForCoord(Config.Shop.coords.x, Config.Shop.coords.y, Config.Shop.coords.z)
    SetBlipSprite(blip, b.sprite)
    SetBlipColour(blip, b.colour)
    SetBlipScale(blip, b.scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.Shop.label)
    EndTextCommandSetBlipName(blip)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= cache.resource then return end
    for id in pairs(props) do despawnSafe(id) end
    if shopPed and DoesEntityExist(shopPed) then DeleteEntity(shopPed) end
end)
