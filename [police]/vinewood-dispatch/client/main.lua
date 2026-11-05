Dispatch = {}

local Active = {}        -- id -> { alert, blips, expires }
local lastAlertId = nil
local muted = GetResourceKvpInt('vinewood_dispatch_muted') == 1
local historyOpen = false
local attachedIds = {}     -- id -> true while this player is attached
local routedAlertId = nil  -- alert whose requesting unit we're routed to
local pendingRoutes = {}   -- id -> { coords, unitSrc } waiting for the server to confirm

---------------------------------------------------------------------
-- Sending
---------------------------------------------------------------------

---@param data table
---  preset?: string, title?: string, description?: string, code?: string,
---  priority?: 1|2|3, services?: string[], coords?: vector3,
---  vehicle?: boolean|number (entity), weapon?: boolean, blip?: table
function Dispatch.SendAlert(data)
    data = data or {}
    local preset = data.preset and Config.Alerts[data.preset]
    if data.preset and not preset then
        lib.print.warn(('Unknown dispatch preset "%s"'):format(data.preset))
        return false
    end
    preset = preset or {}

    local ped = PlayerPedId()
    local coords = data.coords and vec3(data.coords.x, data.coords.y, data.coords.z) or GetEntityCoords(ped)

    local vehicle, heading
    local wantVehicle = data.vehicle
    if wantVehicle == nil then wantVehicle = preset.vehicle end
    if wantVehicle then
        local entity = type(wantVehicle) == 'number' and wantVehicle or GetVehiclePedIsIn(ped, true)
        vehicle = Utils.GetVehicleInfo(entity)
        if vehicle and GetEntitySpeed(entity) > 2.0 then
            heading = Utils.Compass(GetEntityHeading(entity))
        end
    end

    local weapon
    local wantWeapon = data.weapon
    if wantWeapon == nil then wantWeapon = preset.weapon end
    if wantWeapon == true then
        weapon = Utils.GetWeaponType(ped)
    elseif type(wantWeapon) == 'string' then
        weapon = wantWeapon
    end

    TriggerServerEvent('vinewood-dispatch:server:clientAlert', {
        preset = data.preset,
        code = data.code,
        title = data.title,
        description = data.description,
        priority = data.priority,
        services = data.services,
        blip = data.blip,
        coords = coords,
        location = Utils.GetLocationInfo(coords),
        vehicle = vehicle,
        heading = heading,
        weapon = weapon,
    })
    return true
end

function Dispatch.SendPreset(name, overrides)
    local data = overrides or {}
    data.preset = name
    return Dispatch.SendAlert(data)
end

---------------------------------------------------------------------
-- Blips
---------------------------------------------------------------------

local function setBlipName(blip, text)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandSetBlipName(blip)
end

local function createBlips(alert)
    local b = alert.blip or {}
    local c = alert.blipCoords or alert.coords
    local blips = {}

    if b.radius and b.radius > 0 then
        local radius = AddBlipForRadius(c.x, c.y, c.z, b.radius + 0.0)
        SetBlipColour(radius, b.colour or 1)
        SetBlipAlpha(radius, 90)
        SetBlipHighDetail(radius, true)
        blips[#blips + 1] = radius
    end

    local icon = AddBlipForCoord(c.x, c.y, c.z)
    SetBlipSprite(icon, b.sprite or 161)
    SetBlipColour(icon, b.colour or 1)
    SetBlipScale(icon, (b.scale or 1.0) + 0.0)
    SetBlipAsShortRange(icon, false)
    SetBlipHighDetail(icon, true)
    if b.flash then SetBlipFlashes(icon, true) end
    setBlipName(icon, ('Dispatch: %s'):format(alert.title))
    blips[#blips + 1] = icon

    return blips
end

local function removeAlert(id)
    local entry = Active[id]
    if not entry then return end
    for _, blip in ipairs(entry.blips) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
    end
    Active[id] = nil
end

CreateThread(function()
    while true do
        local now = GetGameTimer()
        for id, entry in pairs(Active) do
            if now >= entry.expires then removeAlert(id) end
        end
        Wait(1000)
    end
end)

---------------------------------------------------------------------
-- NUI formatting
---------------------------------------------------------------------

local function isAttached(alert)
    local me = GetPlayerServerId(PlayerId())
    for _, r in ipairs(alert.responders or {}) do
        if r.src == me then return true end
    end
    return false
end

-- Real times for calls and updates, worked out here from how long ago they happened and the
-- game's cloud clock (UTC). The server's clock and time zone never come into it.
local function stampTimes(alert)
    local now = GetCloudTimeAsInt()
    if not alert.at then alert.at = now - (alert.age or 0) end
    for _, n in ipairs(alert.notes or {}) do
        if not n.at then n.at = now - (n.age or 0) end
    end
end

local function toNui(alert)
    stampTimes(alert)
    local services = {}
    for _, key in ipairs(alert.services) do
        local svc = Config.Services[key]
        services[#services + 1] = { key = key, label = svc.label, colour = svc.colour }
    end

    local responders, attachedUnits = {}, {}
    for _, r in ipairs(alert.responders or {}) do
        responders[#responders + 1] = r.callsign or r.name
        attachedUnits[#attachedUnits + 1] = { src = r.src, label = r.callsign or r.name, service = r.service }
    end

    local c = alert.blipCoords or alert.coords
    local dist = #(GetEntityCoords(PlayerPedId()) - vec3(c.x, c.y, c.z))
    local priority = Config.Priorities[alert.priority] or Config.Priorities[2]

    return {
        id = alert.id,
        code = alert.code,
        title = alert.title,
        description = alert.description,
        priority = alert.priority,
        grade = priority.label,
        services = services,
        location = alert.location,
        vehicle = alert.vehicle,
        heading = alert.heading,
        weapon = alert.weapon,
        caller = alert.caller,
        distance = Utils.FormatDistance(dist),
        responders = responders,
        attached = isAttached(alert),
        age = alert.age or 0,
        coords = { x = c.x, y = c.y },
        attachedUnits = attachedUnits,
        outcome = alert.outcome,
        unit = alert.unit,
        unitSrc = alert.unitSrc,
        notes = alert.notes or {},
        at = alert.at,
    }
end

CreateThread(function()
    Wait(1000)
    SendNUIMessage({
        action = 'config',
        config = {
            position = Config.UI.position,
            duration = Config.UI.duration,
            max = Config.UI.maxOnScreen,
            respondKey = Config.Keys.respond,
            dismissKey = Config.Keys.dismiss,
            sticky = Config.UI.stickyPriorities or {},
            showMissed = Config.UI.showMissed ~= false,
            historyKey = Config.Keys.history,
            muted = muted,
        },
    })
end)

---------------------------------------------------------------------
-- Receiving
---------------------------------------------------------------------

RegisterNetEvent('vinewood-dispatch:client:newAlert', function(alert)
    if type(alert) ~= 'table' then return end

    if alert.location and alert.location.pending then
        alert.location = Utils.GetLocationInfo(alert.coords)
        TriggerServerEvent('vinewood-dispatch:server:locationResolved', alert.id, alert.location)
    end

    removeAlert(alert.id)
    Active[alert.id] = {
        alert = alert,
        blips = createBlips(alert),
        expires = GetGameTimer() + Config.BlipDuration * 1000,
    }
    lastAlertId = alert.id

    if muted then return end

    local sound = (Config.Priorities[alert.priority] or {}).sound
    if sound then PlaySoundFrontend(-1, sound.name, sound.set, true) end

    SendNUIMessage({ action = 'newAlert', alert = toNui(alert) })
end)

RegisterNetEvent('vinewood-dispatch:client:updateAlert', function(id, changes)
    local newNote = changes.newNote
    changes.newNote = nil

    if changes.responders then
        local attached = isAttached({ responders = changes.responders })
        if not attached and routedAlertId == id then
            LiveUnits.ClearRoute()
            routedAlertId = nil
        end
        attachedIds[id] = attached or nil
    end

    local entry = Active[id]
    if entry then
        for k, v in pairs(changes) do entry.alert[k] = v end
        -- call moved by control: move its blips
        if changes.coords then
            for _, blip in ipairs(entry.blips) do
                if DoesBlipExist(blip) then RemoveBlip(blip) end
            end
            entry.blips = createBlips(entry.alert)
        end
        SendNUIMessage({ action = 'updateAlert', alert = toNui(entry.alert) })
    elseif historyOpen then
        local patch = { action = 'patchLog', id = id, notes = changes.notes }
        if changes.responders then
            local names = {}
            for _, r in ipairs(changes.responders) do names[#names + 1] = r.callsign or r.name end
            patch.responders = names
            patch.attached = attachedIds[id] == true
        end
        SendNUIMessage(patch)
    end

    if newNote and Config.CallUpdates.notifyAttached and attachedIds[id]
        and newNote.src ~= GetPlayerServerId(PlayerId()) then
        lib.notify({
            type = 'inform',
            title = ('#%d %s'):format(id, entry and entry.alert.title or 'Call update'),
            description = ('%s: %s'):format(newNote.author, newNote.text),
            duration = 7000,
        })
    end
end)

RegisterNetEvent('vinewood-dispatch:client:removeAlert', function(id)
    removeAlert(id)
    SendNUIMessage({ action = 'removeAlert', id = id })
end)

lib.callback.register('vinewood-dispatch:client:locate', function(coords)
    return Utils.GetLocationInfo(coords)
end)

Dispatch.ToNui = function(alert) return toNui(alert) end

-- Control moved a call this unit is attached to
RegisterNetEvent('vinewood-dispatch:client:relocated', function(id, coords, title, where, by)
    if routedAlertId ~= id and coords then SetNewWaypoint(coords.x + 0.0, coords.y + 0.0) end
    PlaySoundFrontend(-1, 'Event_Message_Purple', 'GTAO_FM_Events_Soundset', true)
    lib.notify({
        type = 'inform',
        title = ('Call #%d moved'):format(id),
        description = ('%s has moved %s to %s. Waypoint updated.'):format(by or 'Control', title or 'the call', where or 'a new location'),
        duration = 8000,
    })
end)

-- Control assigned this unit to a call
RegisterNetEvent('vinewood-dispatch:client:assigned', function(id, coords, unitSrc, title, by)
    attachedIds[id] = true
    if Config.Backup.trackUnit and unitSrc and LiveUnits.RouteTo(unitSrc) then
        routedAlertId = id
    elseif coords then
        SetNewWaypoint(coords.x + 0.0, coords.y + 0.0)
    end
    PlaySoundFrontend(-1, 'Event_Message_Purple', 'GTAO_FM_Events_Soundset', true)
    lib.notify({
        type = 'inform',
        title = ('Assigned to call #%d'):format(id),
        description = ('%s has assigned you to %s. Waypoint set.'):format(by or 'Control', title or 'a call'),
        duration = 8000,
    })
end)

---------------------------------------------------------------------
-- Responding
---------------------------------------------------------------------

---@param fallback? { coords?: table, unitSrc?: number } used for log entries whose blip has expired
local function respond(id, fallback)
    if not State.IsEmergency() then return end
    id = id or lastAlertId
    if not id then
        lib.notify({ type = 'error', description = 'No recent alert to respond to.' })
        return
    end

    local entry = Active[id]
    local alert = entry and entry.alert
    pendingRoutes[id] = {
        unitSrc = alert and alert.unitSrc or (fallback and tonumber(fallback.unitSrc)),
        coords = alert and (alert.blipCoords or alert.coords) or (fallback and fallback.coords),
    }
    TriggerServerEvent('vinewood-dispatch:server:respond', id)
end

-- The server decides attach or detach; route once it confirms
RegisterNetEvent('vinewood-dispatch:client:responded', function(id, attached, message)
    local route = pendingRoutes[id]
    pendingRoutes[id] = nil
    attachedIds[id] = attached or nil

    if not attached then
        if routedAlertId == id then
            LiveUnits.ClearRoute()
            routedAlertId = nil
        end
        lib.notify({ type = 'inform', description = message or ('Detached from call #%d.'):format(id) })
        return
    end

    if route then
        if Config.Backup.trackUnit and route.unitSrc and LiveUnits.RouteTo(route.unitSrc) then
            routedAlertId = id
        elseif route.coords then
            SetNewWaypoint(route.coords.x + 0.0, route.coords.y + 0.0)
        end
    end
    lib.notify({ type = 'success', description = ('Attached to call #%d.'):format(id) })
end)

local function openHistory()
    -- logged-in dispatchers get the console instead of the log
    if State.dispatcher and Dispatch.OpenConsole then return Dispatch.OpenConsole() end
    if not State.IsEmergency() or historyOpen then return end
    local list = lib.callback.await('vinewood-dispatch:server:getHistory', false) or {}
    local formatted = {}
    for i, alert in ipairs(list) do
        attachedIds[alert.id] = isAttached(alert) or nil
        formatted[i] = toNui(alert)
    end
    local cs = Config.Callsigns.enabled and lib.callback.await('vinewood-dispatch:server:getCallsign', false) or nil
    historyOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openHistory', alerts = formatted, muted = muted,
        callsign = cs and (cs.callsign or '') or nil,
    })
end

RegisterCommand('dispatchrespond', function() respond() end, false)
RegisterKeyMapping('dispatchrespond', 'Dispatch: respond to latest alert', 'keyboard', Config.Keys.respond)

RegisterCommand('dispatchdismiss', function()
    SendNUIMessage({ action = 'dismissNewest' })
end, false)
RegisterKeyMapping('dispatchdismiss', 'Dispatch: clear newest alert from screen', 'keyboard', Config.Keys.dismiss)

RegisterCommand('dispatch', openHistory, false)
RegisterKeyMapping('dispatch', 'Dispatch: open log', 'keyboard', Config.Keys.history)

RegisterCommand('panic', function()
    if not State.IsEmergency() then return end
    Dispatch.SendPreset('panic_' .. State.service)
    LiveUnits.FlagPanic()
    lib.notify({ type = 'error', title = 'Panic button', description = 'Panic alert sent.' })
end, false)
RegisterKeyMapping('panic', 'Dispatch: panic button', 'keyboard', Config.Keys.panic)

---------------------------------------------------------------------
-- Callsigns
---------------------------------------------------------------------

local function callsignDialog()
    local info = lib.callback.await('vinewood-dispatch:server:getCallsign', false)
    if not info or not info.allowed then
        lib.notify({ type = 'error', title = 'Callsign', description = 'Only emergency services can set a callsign.' })
        return
    end
    local input = lib.inputDialog('Callsign', {
        {
            type = 'input',
            label = 'Your callsign',
            description = 'Letters, numbers and dashes, e.g. 1A-12. Leave empty to clear it.',
            default = info.callsign or '',
            max = info.maxLength,
        },
    })
    if not input then return end
    TriggerServerEvent('vinewood-dispatch:server:setCallsign', input[1] or '')
end

if Config.Callsigns.enabled then
    RegisterCommand(Config.Callsigns.command, function(_, args)
        local value = table.concat(args, ' ')
        if value == '' then return callsignDialog() end
        if value:lower() == 'clear' then value = '' end
        TriggerServerEvent('vinewood-dispatch:server:setCallsign', value)
    end, false)
end

exports('OpenCallsignDialog', callsignDialog)

---------------------------------------------------------------------
-- Backup requests
---------------------------------------------------------------------

function Dispatch.RequestBackup(kind)
    if not Config.Backup.enabled or not State.IsEmergency() then return false end
    kind = kind or 'routine'
    local backup = Config.Backup.types[kind]
    if not backup then
        lib.notify({ type = 'error', description = ('Usage: /%s [routine|urgent|firearms]'):format(Config.Backup.command) })
        return false
    end

    local preset = Config.Alerts[backup.preset]
    local allowed = false
    for _, s in ipairs(preset.requireService or {}) do
        if s == State.service then allowed = true break end
    end
    if not allowed then
        lib.notify({ type = 'error', description = ('%s is not available to your service.'):format(backup.label) })
        return false
    end

    Dispatch.SendPreset(backup.preset)
    lib.notify({ type = 'success', title = 'Backup', description = ('%s: sent.'):format(backup.label) })
    return true
end

if Config.Backup.enabled then
    RegisterCommand(Config.Backup.command, function(_, args)
        Dispatch.RequestBackup(args[1] and args[1]:lower() or 'routine')
    end, false)

    for kind, backup in pairs(Config.Backup.types) do
        local cmd = ('backup_%s'):format(kind)
        RegisterCommand(cmd, function() Dispatch.RequestBackup(kind) end, false)
        RegisterKeyMapping(cmd, ('Dispatch: %s'):format(backup.label:lower()), 'keyboard', backup.key or '')
    end
end

---------------------------------------------------------------------
-- Call updates
---------------------------------------------------------------------

function Dispatch.AddNote(id, text)
    if not Config.CallUpdates.enabled or not State.IsEmergency() then return false end
    if type(text) ~= 'string' or text == '' then return false end
    TriggerServerEvent('vinewood-dispatch:server:addNote', tonumber(id), text)
    return true
end

if Config.CallUpdates.enabled then
    for _, command in ipairs(Config.CallUpdates.commands) do
        RegisterCommand(command, function(_, args)
            if not State.IsEmergency() then return end
            local id = tonumber(args[1])
            if id then table.remove(args, 1) end
            local text = table.concat(args, ' ')
            if text == '' then
                lib.notify({ type = 'error', description = ('Usage: /%s [call number] your update'):format(command) })
                return
            end
            Dispatch.AddNote(id, text)
        end, false)
    end
end

---------------------------------------------------------------------
-- NUI callbacks
---------------------------------------------------------------------

RegisterNUICallback('close', function(_, cb)
    historyOpen = false
    SetNuiFocus(false, false)
    cb(1)
end)

RegisterNUICallback('respond', function(data, cb)
    respond(tonumber(data.id), { coords = data.coords, unitSrc = tonumber(data.unitSrc) })
    cb(1)
end)

RegisterNUICallback('addNote', function(data, cb)
    Dispatch.AddNote(tonumber(data.id), tostring(data.text or ''))
    cb(1)
end)

RegisterNUICallback('waypoint', function(data, cb)
    local entry = Active[tonumber(data.id)]
    local c = entry and (entry.alert.blipCoords or entry.alert.coords) or data.coords
    if c then
        SetNewWaypoint(c.x + 0.0, c.y + 0.0)
        lib.notify({ type = 'inform', description = 'Waypoint set.' })
    end
    cb(1)
end)

RegisterNUICallback('editCallsign', function(_, cb)
    historyOpen = false
    SetNuiFocus(false, false)
    cb(1)
    SetTimeout(150, callsignDialog)
end)

RegisterNUICallback('mute', function(data, cb)
    muted = data.muted == true
    SetResourceKvpInt('vinewood_dispatch_muted', muted and 1 or 0)
    cb(1)
end)

---------------------------------------------------------------------
-- Player calls: /999 police, /111 ambulance, /101 fire (Config.Calls.commands)
---------------------------------------------------------------------

local lastCall = 0

local function canCall()
    if not Config.Calls.enabled then return false end
    if GetGameTimer() - lastCall < Config.Calls.cooldown * 1000 then
        lib.notify({ type = 'error', description = 'Please wait before calling again.' })
        return false
    end
    local item = Config.Calls.requireItem
    if item and GetResourceState('ox_inventory') == 'started' then
        if (exports.ox_inventory:Search('count', item) or 0) < 1 then
            lib.notify({ type = 'error', description = 'You need a phone to make a call.' })
            return false
        end
    end
    return true
end

for _, call in ipairs(Config.Calls.commands or {}) do
    RegisterCommand(call.command, function(_, args)
        if not canCall() then return end
        local message = table.concat(args, ' ')
        if message == '' then
            lib.notify({ type = 'error', title = call.command,
                description = ('Usage: /%s what is happening'):format(call.command) })
            return
        end
        lastCall = GetGameTimer()
        Dispatch.SendAlert({ preset = call.preset, description = message })
        lib.notify({ type = 'success', title = call.command, description = call.sent })
    end, false)
    TriggerEvent('chat:addSuggestion', '/' .. call.command, ('Call the %s'):format(call.label:lower()),
        { { name = 'message', help = 'What is happening' } })
end

---------------------------------------------------------------------
-- Exports
---------------------------------------------------------------------

exports('SendAlert', Dispatch.SendAlert)
exports('SendPreset', Dispatch.SendPreset)
exports('GetLocationInfo', function(coords) return Utils.GetLocationInfo(coords or GetEntityCoords(PlayerPedId())) end)
exports('GetVehicleInfo', Utils.GetVehicleInfo)
exports('GetService', function() return State.service end)
exports('IsOnDuty', function() return State.IsEmergency() end)
-- Attach/detach as a unit (used by MDTs). fallback: { coords = {x,y}, unitSrc }
exports('Respond', function(id, fallback) respond(tonumber(id), fallback) end)
exports('RequestBackup', Dispatch.RequestBackup)
exports('AddNote', Dispatch.AddNote)
exports('SetMuted', function(state)
    muted = state == true
    SetResourceKvpInt('vinewood_dispatch_muted', muted and 1 or 0)
end)

-- One export per preset, e.g. exports['vinewood-dispatch']:StoreRobbery()
for name in pairs(Config.Alerts) do
    exports(Utils.PascalCase(name), function(overrides)
        return Dispatch.SendPreset(name, overrides)
    end)
end

-- Event alternative for scripts that prefer events: TriggerEvent('vinewood-dispatch:client:sendAlert', data)
AddEventHandler('vinewood-dispatch:client:sendAlert', function(data)
    Dispatch.SendAlert(data)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for id in pairs(Active) do removeAlert(id) end
    if historyOpen then SetNuiFocus(false, false) end
end)
