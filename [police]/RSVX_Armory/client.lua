local uiOpen = false

local function weaponImages()
    local base = GetConvar('inventory:imagepath', 'nui://ox_inventory/web/images')
    local images = {}
    local names = {}
    for _, n in ipairs(lib.callback.await('armory:weaponNames', false) or {}) do names[#names + 1] = n end
    for _, name in ipairs(names) do
        local ok, item = pcall(function() return exports.ox_inventory:Items(name) end)
        local file = ok and type(item) == 'table' and item.client and item.client.image
        if file then
            images[name] = file:find('://', 1, true) and file or ('%s/%s'):format(base, file)
        else
            images[name] = ('%s/%s.png'):format(base, name)
        end
    end
    return images
end

local function openUI(payload)
    if uiOpen then return end
    payload.images = weaponImages()
    uiOpen = true
    SetNuiFocus(true, true)
    payload.action = 'open'
    SendNUIMessage(payload)
end

local function closeUI()
    if not uiOpen then return end
    uiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function openArmory(armory)
    local data = lib.callback.await('armory:getData', false)
    if not data then
        return lib.notify({ type = 'error', description = 'You do not have access to the armory.' })
    end
    openUI({ mode = 'full', department = Config.Department, title = armory.label, command = data.command, can = data.can, data = data })
end

RegisterNetEvent('armory:openLog', function(serial, perms)
    openUI({ mode = 'log', department = Config.Department, title = 'Armory Log', command = perms.command, can = perms.can, lookup = serial })
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and uiOpen then SetNuiFocus(false, false) end
end)

lib.callback.register('armory:askApproval', function(info)
    PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
    local r = lib.alertDialog({
        header = 'Armory approval request',
        content = ('**%s** is requesting:\n\n%s\n\n**Reason:** %s'):format(info.who, info.items, info.reason),
        centered = true,
        cancel = true,
        labels = { confirm = 'Approve', cancel = 'Deny' },
    })
    return r == 'confirm'
end)

RegisterNetEvent('armory:closeApproval', function()
    lib.closeAlertDialog('closed')
end)

local function call(name, ...)
    return lib.callback.await(name, false, ...)
end

local FAILED = { ok = false, msg = 'Request failed.' }

local function withHandover(label, action, cb)
    if not Config.Handover.enabled then return cb(action() or FAILED) end

    SendNUIMessage({ action = 'hide' })
    SetNuiFocus(false, false)
    local completed = lib.progressBar({
        duration = Config.Handover.duration,
        label = label,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { dict = 'mp_common', clip = 'givetake1_a' },
    })
    local res = completed and action() or { ok = false, msg = 'Cancelled.' }
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'show' })
    cb(res or FAILED)
end

RegisterNUICallback('close', function(_, cb)
    closeUI()
    cb({})
end)

RegisterNUICallback('getData', function(_, cb)
    cb(call('armory:getData') or { denied = true })
end)

RegisterNUICallback('checkout', function(d, cb)
    withHandover('Signing out weapon...', function() return call('armory:checkout', d.serial, d.signature, d.reason) end, cb)
end)

RegisterNUICallback('takeAmmo', function(d, cb)
    withHandover('Taking ammo...', function() return call('armory:takeAmmo', d.item) end, cb)
end)

RegisterNUICallback('return', function(d, cb)
    withHandover('Returning weapon...', function() return call('armory:return', d.serial) end, cb)
end)

RegisterNUICallback('reportLost', function(d, cb) cb(call('armory:reportLost', d.serial) or FAILED) end)
RegisterNUICallback('forceReturn', function(d, cb) cb(call('armory:forceReturn', d.serial) or FAILED) end)
RegisterNUICallback('markLost', function(d, cb) cb(call('armory:markLost', d.serial) or FAILED) end)

RegisterNUICallback('getOut', function(_, cb)
    cb({ rows = call('armory:getOut') or {} })
end)

RegisterNUICallback('getHistory', function(d, cb)
    cb(call('armory:getHistory', d.page, d.filters) or { rows = {}, more = false, page = 1 })
end)

RegisterNUICallback('lookup', function(d, cb) cb(call('armory:lookup', d.serial) or { found = false }) end)

RegisterNUICallback('getStock', function(d, cb) cb(call('armory:getStock', d.filter) or {}) end)
RegisterNUICallback('addStock', function(d, cb) cb(call('armory:addStock', d.weapon, d.qty) or FAILED) end)
RegisterNUICallback('setStatus', function(d, cb) cb(call('armory:setStatus', d.serial, d.status) or FAILED) end)

RegisterNUICallback('getRules', function(_, cb) cb(call('armory:getRules') or {}) end)
RegisterNUICallback('setRule', function(d, cb) cb(call('armory:setRule', d.weapon, d.job, d.grade) or FAILED) end)

local function applyOutfit(ped, outfit)
    if not outfit then return end
    SetPedDefaultComponentVariation(ped)
    for id, c in pairs(outfit.components or {}) do
        SetPedComponentVariation(ped, tonumber(id), c[1], c[2] or 0, 0)
    end
    for id, p in pairs(outfit.props or {}) do
        if p[1] < 0 then ClearPedProp(ped, tonumber(id)) else SetPedPropIndex(ped, tonumber(id), p[1], p[2] or 0, true) end
    end
end

local function readOutfit()
    local ped = cache.ped
    local out = { components = {}, props = {} }
    for id = 0, 11 do
        out.components[tostring(id)] = { GetPedDrawableVariation(ped, id), GetPedTextureVariation(ped, id) }
    end
    for id = 0, 7 do
        local drawable = GetPedPropIndex(ped, id)
        if drawable ~= -1 then out.props[tostring(id)] = { drawable, GetPedPropTextureIndex(ped, id) } end
    end
    return out
end

RegisterCommand('armoryoutfit', function()
    local o = readOutfit()
    local out = { 'outfit = {', '    components = {' }
    for id = 0, 11 do
        local c = o.components[tostring(id)]
        out[#out + 1] = ('        [%d] = { %d, %d },'):format(id, c[1], c[2])
    end
    out[#out + 1] = '    },'
    out[#out + 1] = '    props = {'
    for id = 0, 7 do
        local p = o.props[tostring(id)]
        if p then out[#out + 1] = ('        [%d] = { %d, %d },'):format(id, p[1], p[2]) end
    end
    out[#out + 1] = '    },'
    out[#out + 1] = '},'
    local text = table.concat(out, '\n')
    print(text)
    lib.setClipboard(text)
    lib.notify({ type = 'success', description = 'Outfit copied. Paste it into the armory entry in config.lua.' })
end, false)

local built = {}

local function clearPoints()
    for _, remove in pairs(built) do remove() end
    built = {}
end

local function buildPoint(a)
    local c = a.coords
    local blip, ped, zone, point

    if a.blip then
        blip = AddBlipForCoord(c.x, c.y, c.z)
        SetBlipSprite(blip, 110)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 3)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(a.label)
        EndTextCommandSetBlipName(blip)
    end

    local option = {
        name = 'armory_checkout_' .. a.id,
        icon = 'fa-solid fa-gun',
        label = 'Open Armory',
        groups = (a.jobs and #a.jobs > 0) and a.jobs or Config.PoliceJobs,
        distance = Config.UseDistance,
        onSelect = function() openArmory(a) end,
    }

    if a.mode == 'target' then
        zone = exports.ox_target:addSphereZone({ coords = vec3(c.x, c.y, c.z), radius = a.radius or 1.0, options = { option } })
    else
        point = lib.points.new({
            coords = vec3(c.x, c.y, c.z),
            distance = 60.0,
            onEnter = function()
                local model = joaat(a.model)
                if not IsModelInCdimage(model) then
                    return print(('[armory_checkout] "%s" has an invalid ped model: %s'):format(a.label, tostring(a.model)))
                end
                lib.requestModel(model)
                ped = CreatePed(4, model, c.x, c.y, c.z - 1.0, c.w, false, false)
                applyOutfit(ped, a.outfit)
                SetEntityInvincible(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                SetPedFleeAttributes(ped, 0, false)
                FreezeEntityPosition(ped, true)
                if a.scenario and a.scenario ~= '' then TaskStartScenarioInPlace(ped, a.scenario, 0, true) end
                SetModelAsNoLongerNeeded(model)
                exports.ox_target:addLocalEntity(ped, { option })
            end,
            onExit = function()
                if ped and DoesEntityExist(ped) then
                    exports.ox_target:removeLocalEntity(ped)
                    DeleteEntity(ped)
                end
                ped = nil
            end,
        })
    end

    built[a.id] = function()
        if blip then RemoveBlip(blip) end
        if zone then exports.ox_target:removeZone(zone) end
        if point then
            point:onExit()
            point:remove()
        end
    end
end

local function buildAll(list)
    clearPoints()
    for _, a in ipairs(list or {}) do buildPoint(a) end
end

RegisterNetEvent('armory:sync', buildAll)

CreateThread(function()
    buildAll(lib.callback.await('armory:points', false))
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then clearPoints() end
end)

RegisterNetEvent('armory:openAdmin', function()
    local data = lib.callback.await('armory:adminGet', false)
    if not data then return lib.notify({ type = 'error', description = 'You do not have access.' }) end
    openUI({ mode = 'admin', department = Config.Department, title = 'Armory Setup', command = false, can = {}, admin = data })
end)

local function hideMenu(text)
    SendNUIMessage({ action = 'hide' })
    SetNuiFocus(false, false)
    lib.showTextUI(text)
end

local function showMenu()
    lib.hideTextUI()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'show' })
end

local function capture(kind)
    hideMenu(kind == 'pos'
        and '[E] Use this position and heading (the ped faces the way you face)  \n[Backspace] Cancel'
        or '[E] Capture the outfit you are wearing  \n[Backspace] Cancel')
    local result
    while true do
        Wait(0)
        if IsControlJustPressed(0, 38) then
            if kind == 'pos' then
                local p = GetEntityCoords(cache.ped)
                result = { x = p.x, y = p.y, z = p.z, w = GetEntityHeading(cache.ped) }
            else
                result = readOutfit()
            end
            break
        elseif IsControlJustPressed(0, 194) then
            break
        end
    end
    showMenu()
    return result
end

local function validCoords(c)
    return type(c) == 'table' and tonumber(c.x) and tonumber(c.y) and tonumber(c.z) and c
end

local function preview(d)
    local c = validCoords(d.coords)
    if not c then return { ok = false, msg = 'Set a position first.' } end
    local heading = tonumber(c.w) or 0.0
    local ped
    if d.mode ~= 'target' then
        local model = joaat(tostring(d.model or ''))
        if not IsModelInCdimage(model) then return { ok = false, msg = 'That ped model does not exist.' } end
        lib.requestModel(model)
        ped = CreatePed(4, model, c.x, c.y, c.z - 1.0, heading, false, false)
        SetModelAsNoLongerNeeded(model)
        applyOutfit(ped, d.outfit)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        if d.scenario and d.scenario ~= '' then TaskStartScenarioInPlace(ped, d.scenario, 0, true) end
    end

    local id = tonumber(d.id)
    if id and built[id] then
        built[id]()
        built[id] = nil
    end

    local r = math.min(2.0, math.max(0.5, tonumber(d.radius) or 1.0))
    hideMenu('[E] Back to the menu')
    while true do
        Wait(0)
        if not ped then
            DrawMarker(28, c.x, c.y, c.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, r, r, r, 212, 169, 74, 90, false, false, 2, false, nil, nil, false)
        end
        if IsControlJustPressed(0, 38) then break end
    end
    if ped and DoesEntityExist(ped) then DeleteEntity(ped) end
    buildAll(lib.callback.await('armory:points', false))
    showMenu()
    return { ok = true }
end

local function goTo(c)
    c = validCoords(c)
    if not c then return end
    local h = math.rad(tonumber(c.w) or 0.0)
    local x, y = c.x - math.sin(h) * 1.5, c.y + math.cos(h) * 1.5
    closeUI()
    DoScreenFadeOut(250)
    while not IsScreenFadedOut() do Wait(0) end
    RequestCollisionAtCoord(x, y, c.z)
    SetEntityCoords(cache.ped, x, y, c.z, false, false, false, false)
    SetEntityHeading(cache.ped, ((tonumber(c.w) or 0.0) + 180.0) % 360.0)
    local timeout = GetGameTimer() + 3000
    while not HasCollisionLoadedAroundEntity(cache.ped) and GetGameTimer() < timeout do Wait(0) end
    DoScreenFadeIn(250)
end

RegisterNUICallback('adminPreview', function(d, cb) cb(preview(d)) end)
RegisterNUICallback('adminGoto', function(d, cb)
    cb({ ok = true })
    goTo(d.coords)
end)
RegisterNUICallback('adminGet', function(_, cb) cb(call('armory:adminGet') or {}) end)
RegisterNUICallback('adminSave', function(d, cb) cb(call('armory:adminSave', d) or FAILED) end)
RegisterNUICallback('adminSaveWeapon', function(d, cb)
    local r = call('armory:adminSaveWeapon', d) or FAILED
    r.images = weaponImages()
    cb(r)
end)
RegisterNUICallback('adminDeleteWeapon', function(d, cb)
    local r = call('armory:adminDeleteWeapon', d.name) or FAILED
    r.images = weaponImages()
    cb(r)
end)
RegisterNUICallback('adminSaveAmmo', function(d, cb)
    local r = call('armory:adminSaveAmmo', d) or FAILED
    r.images = weaponImages()
    cb(r)
end)
RegisterNUICallback('adminDeleteAmmo', function(d, cb)
    local r = call('armory:adminDeleteAmmo', d.item) or FAILED
    r.images = weaponImages()
    cb(r)
end)
RegisterNUICallback('adminDelete', function(d, cb) cb(call('armory:adminDelete', d.id) or FAILED) end)
RegisterNUICallback('adminCapture', function(d, cb)
    local r = capture(d.kind == 'pos' and 'pos' or 'outfit')
    cb({ ok = r ~= nil, value = r })
end)
