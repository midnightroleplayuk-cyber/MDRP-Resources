local DC = Config.Dispatcher
if not DC or not DC.enabled then return end

State.dispatcher = false

local consoleOpen = false
local consoleAlerts = {}  -- id -> raw alert
local lastUnits = {}

local vehicleLabels = {
    foot = 'On foot', automobile = 'Car', bike = 'Bike', heli = 'Helicopter',
    boat = 'Boat', plane = 'Plane', submarine = 'Sub', trailer = 'Vehicle', train = 'Train',
}

local function unitsForNui(units)
    local me = PlayerPedId()
    local here = GetEntityCoords(me)
    local out = {}
    for i, u in ipairs(units or {}) do
        local svc = Config.Services[u.s]
        local loc = Utils.GetLocationInfo(vec3(u.x, u.y, u.z))
        out[i] = {
            src = u.src,
            service = u.s,
            serviceLabel = svc and svc.label or u.s,
            colour = svc and svc.colour or '#888',
            label = u.n,
            name = u.name,
            callsign = u.callsign,
            vehicle = vehicleLabels[u.v] or 'Vehicle',
            lights = u.l,
            panic = u.p,
            calls = u.calls or {},
            radio = u.radio,
            location = loc.street and (loc.zone and ('%s, %s'):format(loc.street, loc.zone) or loc.street) or loc.zone,
            distance = Utils.FormatDistance(#(here - vec3(u.x, u.y, u.z))),
            coords = { x = u.x, y = u.y },
        }
    end
    return out
end

local function push(action, payload)
    if not consoleOpen then return end
    payload = payload or {}
    payload.action = action
    SendNUIMessage(payload)
end

---------------------------------------------------------------------
-- Opening, closing, login
---------------------------------------------------------------------

local function openConsole()
    if not State.dispatcher then return end
    local state = lib.callback.await('vinewood-dispatch:server:console', false, 'state')
    if not state or not state.ok then
        lib.notify({ type = 'error', description = state and state.err or 'Dispatch console unavailable.' })
        return
    end
    consoleAlerts = {}
    local alerts = {}
    for i, a in ipairs(state.alerts) do
        consoleAlerts[a.id] = a
        alerts[i] = Dispatch.ToNui(a)
    end
    lastUnits = state.units or {}
    consoleOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'consoleOpen',
        alerts = alerts,
        units = unitsForNui(lastUnits),
        services = state.services,
        author = state.author,
        outcomes = state.outcomes,
        radio = state.radio,
        call = state.call,
        map = state.map,
        distanceUnit = Config.Units,
        priorities = (function()
            local list = {}
            for p, info in pairs(Config.Priorities) do list[#list + 1] = { value = p, label = info.label } end
            table.sort(list, function(a, b) return a.value < b.value end)
            return list
        end)(),
    })
end

local function closeConsole()
    if not consoleOpen then return end
    consoleOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'consoleClose' })
end

local function toggleDispatcher()
    if State.dispatcher then
        if consoleOpen then closeConsole() else openConsole() end
        return
    end
    local result = lib.callback.await('vinewood-dispatch:server:dispatcherLogin', false)
    if not result or not result.ok then
        lib.notify({ type = 'error', title = 'Dispatch', description = result and result.err or 'Login failed.' })
        return
    end
    State.dispatcher = true
    openConsole()
end

RegisterCommand(DC.command, toggleDispatcher, false)
if DC.key and DC.key ~= '' then
    RegisterKeyMapping(DC.command, 'Dispatch: open dispatcher console', 'keyboard', DC.key)
end
TriggerEvent('chat:addSuggestion', '/' .. DC.command, 'Log in to the dispatch console, or reopen it')

-- F9 (the log key) opens the console for dispatchers
Dispatch.OpenConsole = function()
    if not State.dispatcher then return end
    if consoleOpen then closeConsole() else openConsole() end
end

RegisterNetEvent('vinewood-dispatch:client:dispatcherState', function(loggedIn)
    State.dispatcher = loggedIn == true
    SendNUIMessage({ action = 'dispatcherState', on = State.dispatcher })
    if not State.dispatcher then
        closeConsole()
        LiveUnits.Clear()
    end
end)

exports('IsDispatcher', function() return State.dispatcher end)
exports('OpenConsole', toggleDispatcher)

---------------------------------------------------------------------
-- Live data while the console is open
---------------------------------------------------------------------

RegisterNetEvent('vinewood-dispatch:client:newAlert', function(alert)
    if not State.dispatcher or type(alert) ~= 'table' then return end
    alert.age = 0
    consoleAlerts[alert.id] = alert
    push('consoleAlert', { alert = Dispatch.ToNui(alert), isNew = true })
end)

RegisterNetEvent('vinewood-dispatch:client:updateAlert', function(id, changes)
    local alert = State.dispatcher and consoleAlerts[id]
    if not alert then return end
    for k, v in pairs(changes) do
        if k ~= 'newNote' then alert[k] = v end
    end
    push('consoleAlert', { alert = Dispatch.ToNui(alert) })
end)

RegisterNetEvent('vinewood-dispatch:client:removeAlert', function(id)
    if not State.dispatcher then return end
    consoleAlerts[id] = nil
    push('consoleRemove', { id = id })
end)

-- Individual call progress (vinewood_radio)
local CallEnd = {
    no_answer = 'No answer', rejected = 'Call rejected', unavailable = 'Unit unavailable', ended = 'Call ended',
}
RegisterNetEvent('vinewood-dispatch:client:controlCall', function(info)
    if not State.dispatcher then return end
    if consoleOpen then
        push('consoleCall', { call = info })
    elseif info.state == 'active' then
        lib.notify({ type = 'success', title = 'Dispatch', description = ('Connected to %s. Just talk.'):format(info.label) })
    elseif info.state == 'ended' then
        lib.notify({ type = 'inform', title = 'Dispatch', description = ('%s: %s'):format(info.label, CallEnd[info.reason] or 'Call ended') })
    end
end)

RegisterCommand('dispatchhangup', function()
    if not State.dispatcher then return end
    lib.callback.await('vinewood-dispatch:server:console', false, 'radioHangup')
end, false)
RegisterKeyMapping('dispatchhangup', 'Dispatch: hang up control call', 'keyboard', '')

RegisterNetEvent('vinewood-dispatch:client:consoleUnits', function(units)
    if not State.dispatcher then return end
    lastUnits = units
    push('consoleUnits', { units = unitsForNui(units) })
end)

---------------------------------------------------------------------
-- NUI callbacks
---------------------------------------------------------------------

local function waypointCoords()
    local blip = GetFirstBlipInfoId(8)
    if not DoesBlipExist(blip) then return nil end
    local c = GetBlipInfoIdCoord(blip)
    local found, z = GetGroundZFor_3dCoord(c.x, c.y, 1000.0, false)
    return vec3(c.x, c.y, found and z or c.z)
end

RegisterNUICallback('consoleAction', function(data, cb)
    local action, payload = data.action, data.data or {}

    if action == 'create' or action == 'relocate' then
        local coords
        if payload.where == 'map' or action == 'relocate' then
            local c = payload.coords
            if type(c) ~= 'table' or not tonumber(c.x) then return cb({ ok = false, err = 'Pick a location on the map first.' }) end
            local found, z = GetGroundZFor_3dCoord(c.x + 0.0, c.y + 0.0, 1000.0, false)
            coords = vec3(c.x + 0.0, c.y + 0.0, found and z or (tonumber(c.z) or 30.0))
        elseif payload.where == 'self' then
            coords = GetEntityCoords(PlayerPedId())
        else
            coords = waypointCoords()
            if not coords then return cb({ ok = false, err = 'Set a waypoint on the map first, or choose "My position".' }) end
        end
        payload.coords = { x = coords.x, y = coords.y, z = coords.z }
        payload.location = Utils.GetLocationInfo(coords)
    end

    local result = lib.callback.await('vinewood-dispatch:server:console', false, action, payload)
    cb(result or { ok = false, err = 'No response from the server.' })
end)

-- Street name for a spot picked on the console map
RegisterNUICallback('consoleResolve', function(data, cb)
    if not data or not tonumber(data.x) then return cb({}) end
    local info = Utils.GetLocationInfo(vec3(data.x + 0.0, data.y + 0.0, 30.0))
    cb({ street = info.street, cross = info.cross, zone = info.zone })
end)

RegisterNUICallback('consoleWaypoint', function(data, cb)
    if data and tonumber(data.x) then
        SetNewWaypoint(data.x + 0.0, data.y + 0.0)
    end
    cb(1)
end)

RegisterNUICallback('consoleClose', function(_, cb)
    consoleOpen = false
    SetNuiFocus(false, false)
    cb(1)
end)

RegisterNUICallback('consoleLogout', function(_, cb)
    consoleOpen = false
    SetNuiFocus(false, false)
    lib.callback.await('vinewood-dispatch:server:dispatcherLogout', false)
    State.dispatcher = false
    SendNUIMessage({ action = 'dispatcherState', on = false })
    LiveUnits.Clear()
    cb(1)
end)

---------------------------------------------------------------------
-- Control room desks (ox_target)
---------------------------------------------------------------------

CreateThread(function()
    if #(DC.locations or {}) == 0 or GetResourceState('ox_target') ~= 'started' then return end
    for i, desk in ipairs(DC.locations) do
        exports.ox_target:addSphereZone({
            name = ('vinewood_dispatch_desk_%d'):format(i),
            coords = desk.coords,
            radius = desk.radius or 1.5,
            options = {
                {
                    name = 'vinewood_dispatch_console',
                    icon = 'fa-solid fa-headset',
                    label = desk.label and ('Dispatch console (%s)'):format(desk.label) or 'Dispatch console',
                    onSelect = toggleDispatcher,
                },
            },
        })
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and consoleOpen then SetNuiFocus(false, false) end
end)
