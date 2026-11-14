local TABLET_MODEL = joaat('prop_cs_tablet')
local open = false
local tablet

local function stopAnim()
    local ped = PlayerPedId()
    StopAnimTask(ped, 'amb@world_human_seat_wall_tablet@female@base', 'base', 1.0)
    if tablet and DoesEntityExist(tablet) then DeleteEntity(tablet) end
    tablet = nil
end

local function startAnim()
    if not Config.UseTabletProp or IsPedInAnyVehicle(PlayerPedId(), false) then return end
    local ped = PlayerPedId()
    lib.requestAnimDict('amb@world_human_seat_wall_tablet@female@base')
    lib.requestModel(TABLET_MODEL)
    tablet = CreateObject(TABLET_MODEL, GetEntityCoords(ped), true, true, false)
    AttachEntityToEntity(tablet, ped, GetPedBoneIndex(ped, 28422), 0.0, -0.03, 0.0, 20.0, -90.0, 0.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(TABLET_MODEL)
    TaskPlayAnim(ped, 'amb@world_human_seat_wall_tablet@female@base', 'base', 3.0, 3.0, -1, 49, 0, false, false, false)
end

local function openMdt()
    if open then return end
    if not lib.callback.await('vinewood-mdt:server:canOpen', false) then
        lib.notify({ title = 'MDT', description = 'You need to be on duty as police to use the MDT.', type = 'error' })
        return
    end
    open = true
    startAnim()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open' })
end

local function closeMdt()
    if not open then return end
    open = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    stopAnim()
end

-- Street name for coords, so properties show a real address.
local function streetAt(c)
    if not c or not c.x then return nil end
    local s1, s2 = GetStreetNameAtCoord(c.x + 0.0, c.y + 0.0, (c.z or 0.0) + 0.0)
    local street = GetStreetNameFromHashKey(s1)
    local cross = s2 ~= 0 and GetStreetNameFromHashKey(s2) or nil
    local zone = GetLabelText(GetNameOfZone(c.x + 0.0, c.y + 0.0, (c.z or 0.0) + 0.0))
    local parts = { street }
    if cross and cross ~= '' then parts[1] = ('%s / %s'):format(street, cross) end
    if zone and zone ~= 'NULL' then parts[#parts + 1] = zone end
    return table.concat(parts, ', ')
end

local function modelLabel(model)
    if model == nil then return 'Unknown' end
    local hash = tonumber(model) or joaat(tostring(model))
    local name = GetDisplayNameFromVehicleModel(hash)
    if not name or name == 'CARNOTFOUND' then return tostring(model) end
    local label = GetLabelText(name)
    local make = GetMakeNameFromVehicleModel and GetMakeNameFromVehicleModel(hash) or nil
    make = make and make ~= '' and GetLabelText(make) or nil
    if label == 'NULL' then label = name end
    if make and make ~= 'NULL' then return ('%s %s'):format(make, label) end
    return label
end

local function enrich(action, res)
    if type(res) ~= 'table' then return res end
    if res.housing then
        for _, h in ipairs(res.housing) do
            if not h.address and h.coords then h.address = streetAt(h.coords) end
        end
    end
    local function vlist(list)
        for _, v in ipairs(list or {}) do v.modelLabel = modelLabel(v.model) end
    end
    if res.vehicles then vlist(res.vehicles) end
    for _, c in ipairs(res.calls or {}) do
        if not c.location and c.coords then c.location = streetAt(c.coords) end
    end
    if res.vehicle then
        local v = res.vehicle
        v.modelLabel = modelLabel(v.model)
        local hash = tonumber(v.model) or joaat(tostring(v.model))
        v.spawn = type(v.model) == 'string' and v.model:lower() or (GetDisplayNameFromVehicleModel(hash) or ''):lower()
        local cls = GetVehicleClassFromName(hash)
        v.class = cls and GetLabelText(('VEH_CLASS_%d'):format(cls)) or nil
        if v.class == 'NULL' then v.class = nil end
    end
    if action == 'searchVehicles' or action == 'flaggedVehicles' then vlist(res.results) end
    if action == 'plateSuggest' then
        for _, v in ipairs(res.results or {}) do
            if v.model and not v.modelLabel then v.modelLabel = modelLabel(v.model) end
        end
    end
    return res
end

-- Vinewood MDT Mobile: the phone app asks the officer's game for the same extras the tablet gets.
lib.callback.register('vinewood-mdt:client:mobileEnrich', function(action, res)
    local ok, out = pcall(enrich, action, res)
    return ok and out or res
end)

lib.callback.register('vinewood-mdt:client:mobileLocation', function()
    local c = GetEntityCoords(PlayerPedId())
    return { location = streetAt({ x = c.x, y = c.y, z = c.z }), coords = { x = c.x, y = c.y, z = c.z } }
end)

RegisterNetEvent('vinewood-mdt:client:mobileWaypoint', function(x, y)
    SetNewWaypoint(x + 0.0, y + 0.0)
    lib.notify({ title = 'MDT', description = 'Waypoint set from your phone.', type = 'success' })
end)

RegisterNetEvent('vinewood-mdt:client:mobileRespond', function(data)
    if GetResourceState('vinewood-dispatch') == 'started' and data and tonumber(data.id) then
        exports['vinewood-dispatch']:Respond(tonumber(data.id), { coords = data.coords, unitSrc = data.unitSrc })
    end
end)

RegisterNUICallback('request', function(body, cb)
    local action, data = body.action, body.data
    local res = lib.callback.await('vinewood-mdt:server:request', false, action, data)
    cb(enrich(action, res) or { error = 'No response from the server.' })
end)

-- Where the officer is standing, for new incidents.
RegisterNUICallback('location', function(_, cb)
    local c = GetEntityCoords(PlayerPedId())
    cb({ location = streetAt({ x = c.x, y = c.y, z = c.z }), coords = { x = c.x, y = c.y, z = c.z } })
end)

-- vinewood-dispatch: attach/detach from the Live calls page. The dispatch handles the
-- waypoint (or follows the requesting unit for backup calls).
RegisterNUICallback('dispatchRespond', function(data, cb)
    if GetResourceState('vinewood-dispatch') == 'started' and data and tonumber(data.id) then
        exports['vinewood-dispatch']:Respond(tonumber(data.id), { coords = data.coords, unitSrc = data.unitSrc })
    end
    cb(true)
end)

-- Refresh the Live calls page whenever vinewood-dispatch changes a call
for _, ev in ipairs({ 'vinewood-dispatch:client:newAlert', 'vinewood-dispatch:client:updateAlert',
    'vinewood-dispatch:client:removeAlert', 'vinewood-dispatch:client:responded' }) do
    RegisterNetEvent(ev, function() SendNUIMessage({ action = 'callsChanged' }) end)
end

RegisterNUICallback('waypoint', function(data, cb)
    if data and data.x and data.y then
        SetNewWaypoint(data.x + 0.0, data.y + 0.0)
        lib.notify({ title = 'MDT', description = 'Waypoint set.', type = 'success' })
    end
    cb(true)
end)

-- Custody photo: point a camera at the detainee's face, screenshot it on this client,
-- then hand the image to the server, which uploads it (the API key never leaves the server).
local photoActive = false
mugshotWaiting = {}
RegisterNetEvent('vinewood-mdt:client:mugshotResult', function(token, result)
    local p = mugshotWaiting[token]
    if not p then return end
    mugshotWaiting[token] = nil
    p:resolve(result or { error = 'No response from the server.' })
end)
RegisterNUICallback('mugshot', function(data, cb)
    if photoActive then return cb({ error = 'Already taking a photo.' }) end
    local start = lib.callback.await('vinewood-mdt:server:request', false, 'mugshotStart', data)
    if not start or start.error then return cb(start or { error = 'No response from the server.' }) end
    if GetResourceState('screenshot-basic') ~= 'started' then return cb({ error = 'screenshot-basic is not running.' }) end

    local player = GetPlayerFromServerId(start.target)
    local ped = player ~= -1 and GetPlayerPed(player) or 0
    if ped == 0 then return cb({ error = 'Cannot see the detainee. Move closer.' }) end

    photoActive = true
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hideForPhoto', hide = true })

    local camCfg = Config.Mugshot.Camera or {}
    local head = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
    local front = GetOffsetFromEntityInWorldCoords(ped, 0.0, camCfg.Distance or 0.75, 0.0)
    local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', front.x, front.y, head.z + (camCfg.HeightOffset or 0.02), 0.0, 0.0, 0.0, camCfg.Fov or 28.0, false, 0)
    PointCamAtCoord(cam, head.x, head.y, head.z)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
    local hud = true
    CreateThread(function() while hud do HideHudAndRadarThisFrame() Wait(0) end end)
    Wait(800)

    local p = promise.new()
    local okShot = pcall(function()
        exports['screenshot-basic']:requestScreenshot({ encoding = Config.Mugshot.Encoding or 'jpg', quality = Config.Mugshot.Quality or 0.9 }, function(img) p:resolve(img) end)
    end)
    if not okShot then p:resolve(nil) end
    SetTimeout(10000, function() p:resolve(nil) end)
    local img = Citizen.Await(p)

    hud = false
    RenderScriptCams(false, false, 0, true, true)
    DestroyCam(cam, false)
    SendNUIMessage({ action = 'hideForPhoto', hide = false })
    SetNuiFocus(true, true)
    photoActive = false

    if not img then return cb({ error = 'The screenshot failed.' }) end
    -- Send the image as a latent event (big payloads time out as normal events), then wait for the reply.
    local token = ('%d%d'):format(GetGameTimer(), math.random(1000, 9999))
    local reply = promise.new()
    mugshotWaiting[token] = reply
    TriggerLatentServerEvent('vinewood-mdt:server:mugshotData', 250000, token, img)
    SetTimeout(60000, function()
        if mugshotWaiting[token] then mugshotWaiting[token] = nil; reply:resolve({ error = 'The upload took too long. Check your connection and try again.' }) end
    end)
    cb(Citizen.Await(reply))
end)

RegisterNetEvent('vinewood-mdt:client:stopSearchNotice', function(rec, force)
    SendNUIMessage({ action = 'stopSearchNotice', rec = rec, force = force })
end)

---------------------------------------------------------------------------
-- Fines: notice on issue, and /fines to see and pay
---------------------------------------------------------------------------
RegisterNetEvent('vinewood-mdt:client:fineNotice', function(fine, force)
    SendNUIMessage({ action = 'fineNotice', fine = fine, force = force, currency = Config.Fines and Config.Fines.Currency or nil })
end)

local function money(n) return ('%s%s'):format(Config.Fines.Currency or '£', math.floor(n or 0)) end

local function openFines()
    local fines = lib.callback.await('vinewood-mdt:server:myFines', false) or {}
    local options = {}
    for _, f in ipairs(fines) do
        local names = {}
        for _, o in ipairs(f.offences or {}) do names[#names + 1] = o.label end
        if f.status == 'court' then
            options[#options + 1] = { title = ('%s - reported for court'):format(f.ref), description = table.concat(names, ', '), icon = 'scale-balanced', disabled = true }
        else
            options[#options + 1] = {
                title = ('%s - %s%s'):format(f.ref, money(f.amount), f.overdue and ' (overdue)' or ''),
                description = ('%s\nPay by %s'):format(table.concat(names, ', '), f.due_text or 'now'),
                icon = 'sterling-sign',
                iconColor = f.overdue and 'red' or nil,
                onSelect = function()
                    local ok = lib.alertDialog({ header = 'Pay fine', content = ('Pay %s for %s from your %s?'):format(money(f.amount), f.ref, Config.Fines.Account or 'bank'), centered = true, cancel = true })
                    if ok ~= 'confirm' then return end
                    local r = lib.callback.await('vinewood-mdt:server:payFine', false, f.id)
                    if r and r.ok then
                        lib.notify({ title = Config.ForceName, description = ('Paid %s. Thank you.'):format(r.amount), type = 'success' })
                    else
                        lib.notify({ title = Config.ForceName, description = r and r.error or 'Payment failed.', type = 'error' })
                    end
                end,
            }
        end
    end
    if #options == 0 then options[1] = { title = 'You have no outstanding fines', disabled = true } end
    lib.registerContext({ id = 'vwmdt_fines', title = 'Fines and penalties', options = options })
    lib.showContext('vwmdt_fines')
end
if Config.Fines and Config.Fines.enabled and Config.Fines.PayCommand then
    RegisterCommand(Config.Fines.PayCommand, openFines, false)
end

---------------------------------------------------------------------------
-- Statements: the witness reads and signs on their own screen
---------------------------------------------------------------------------
local signing = false
RegisterNetEvent('vinewood-mdt:client:signStatement', function(st)
    signing = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'signStatement', statement = st })
end)
RegisterNUICallback('statementSign', function(data, cb)
    TriggerServerEvent('vinewood-mdt:server:statementSign', data.id, data.accept == true)
    signing = false
    if not open then SetNuiFocus(false, false) end
    cb(true)
end)

-- Evidence bag: the server checks access and registers the stash, then we close the MDT and open it.
RegisterNUICallback('openEvidence', function(data, cb)
    local r = lib.callback.await('vinewood-mdt:server:request', false, 'evidenceOpen', data)
    if not r or r.error then return cb(r or { error = 'No response from the server.' }) end
    cb({ ok = true })
    closeMdt()
    Wait(150)
    local o = r.open or { kind = 'ox' }
    if o.kind == 'ox' then
        exports.ox_inventory:openInventory('stash', r.stash)
    elseif o.kind == 'server' then
        TriggerServerEvent('vinewood-mdt:server:openBag', r.stash)          -- qb-inventory 2.x opens it from the server
    else
        -- qs-inventory, ps-inventory, lj-inventory and older qb-inventory
        TriggerServerEvent(o.event, 'stash', r.stash, { maxweight = o.weight, slots = o.slots })
        TriggerEvent(o.current, r.stash)
    end
end)

RegisterNUICallback('close', function(_, cb)
    closeMdt()
    cb(true)
end)

RegisterNetEvent('vinewood-mdt:client:open', openMdt)

-- Open the MDT straight onto a vehicle (used by ANPR).
AddEventHandler('vinewood-mdt:client:openVehicle', function(plate)
    openMdt()
    if open then SendNUIMessage({ action = 'goVehicle', plate = plate }) end
end)

RegisterNetEvent('vinewood-mdt:client:bailNotice', function(bail, force)
    SendNUIMessage({ action = 'bailNotice', bail = bail, force = force })
end)

if Config.Command then
    RegisterCommand(Config.Command, openMdt, false)
    if Config.Keybind then
        RegisterKeyMapping(Config.Command, 'Open police MDT', 'keyboard', Config.Keybind)
    end
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and open then
        SetNuiFocus(false, false)
        stopAnim()
    end
end)
