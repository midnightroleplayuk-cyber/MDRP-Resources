-- The officer's radial menu (ox_lib). Everything here also exists as a target option or command:
-- the radial acts on the closest person or vehicle, and the server checks it as usual.
local Cfg = Config.Radial
if not Cfg or not Cfg.Enabled or not lib then return end
local L = VPO.L
-- 'own' = our radial (L by default, rebindable), 'ox' = ox_lib's radial (Z)
local STYLE = (Cfg.Style == 'ox' and lib.registerRadial) and 'ox' or 'own'

-- Every menu is defined once here; both styles use the same menus and actions.
local menus = {}
local function reg(def)
    menus[def.id] = def.items
    if STYLE == 'ox' then lib.registerRadial(def) end
end

local function duty() return LocalPlayer.state[VPO.StateDefs.duty.bag] end

local function closestPlayer()
    local pid = lib.getClosestPlayer(GetEntityCoords(PlayerPedId()), Cfg.CloseDistance, false)
    if not pid then VPO.ClientNotify(L('radial_nobody'), 'error') return nil end
    return GetPlayerServerId(pid)
end

local function closestVehicle()
    local ped = PlayerPedId()
    local veh = lib.getClosestVehicle(GetEntityCoords(ped), Cfg.CloseDistance + 2.0, false)
    if not veh or veh == 0 or veh == GetVehiclePedIsIn(ped, false) then VPO.ClientNotify(L('radial_no_vehicle'), 'error') return nil end
    return veh
end

local function onPerson(fn) return function() local sid = closestPlayer(); if sid then fn(sid) end end end
local function cmd(name) return function() if name then ExecuteCommand(name) end end end
local function send(action, data) VPO.RestraintSend(action, data) end

local function backup(urgent)
    return function()
        CreateThread(function()
            local res = VPO.UI.Request('call:backupHere', { urgent = urgent, location = VPO.Location() })
            VPO.ClientNotify(res.error or res.message, res.error and 'error' or (urgent and 'error' or 'success'))
        end)
    end
end

---------------------------------------------------------------------------
-- Menus
---------------------------------------------------------------------------
local function statusMenu()
    local items = {}
    for _, s in ipairs(Config.Duty.Statuses) do
        items[#items + 1] = { label = s.label, icon = s.tone == 'ok' and 'circle-check' or (s.tone == 'busy' and 'circle-exclamation' or 'mug-hot'),
            onSelect = function()
                CreateThread(function()
                    local res = VPO.UI.Request('duty:setStatus', { status = s.id })
                    if res.error then VPO.ClientNotify(res.error, 'error') end
                end)
            end }
    end
    reg({ id = 'vpo_status', items = items })
end

reg({ id = 'vpo_restrain', items = {
    { label = 'Cuff (rear)', icon = 'handcuffs', onSelect = onPerson(function(sid) send('restraint:cuff', { target = sid, mode = 'rear' }) end) },
    { label = 'Cuff (front)', icon = 'handcuffs', onSelect = onPerson(function(sid) send('restraint:cuff', { target = sid, mode = 'front' }) end) },
    { label = 'Remove cuffs', icon = 'unlock', onSelect = onPerson(function(sid) send('restraint:uncuff', { target = sid }) end) },
    { label = 'Double-lock', icon = 'lock', onSelect = onPerson(function(sid) send('restraint:doubleLock', { target = sid }) end) },
    { label = 'Escort / let go', icon = 'person-walking-arrow-right', onSelect = function()
        if VPO.IsEscorting() then return send('restraint:release') end
        local sid = closestPlayer(); if sid then send('restraint:escort', { target = sid }) end
    end },
    { label = 'Put in vehicle', icon = 'car-side', onSelect = function()
        local veh = closestVehicle(); if veh then send('restraint:seat', { net = VehToNet(veh) }) end
    end },
    { label = 'Take out of vehicle', icon = 'door-open', onSelect = function()
        local veh = closestVehicle(); if veh then send('restraint:unseat', { net = VehToNet(veh) }) end
    end },
} })

reg({ id = 'vpo_arrest', items = {
    { label = 'Search', icon = 'magnifying-glass', onSelect = onPerson(function(sid)
        local st = Player(sid).state
        local consent = not st[VPO.StateDefs.cuffed.bag] and not st[VPO.StateDefs.custody.bag]
        VPO.UI.OpenTask('search', 'search:open', sid, consent and L('search_asking') or nil)
    end) },
    { label = 'Arrest', icon = 'gavel', onSelect = onPerson(function(sid) VPO.UI.OpenTask('arrest', 'arrest:prepare', sid) end) },
    { label = 'Release from arrest', icon = 'person-walking', onSelect = onPerson(function(sid) VPO.UI.OpenTask('release', 'arrest:releasePrepare', sid) end) },
    { label = 'Stop and search record', icon = 'file-pen', onSelect = function()
        local pid = lib.getClosestPlayer(GetEntityCoords(PlayerPedId()), 6.0, false)
        VPO.UI.OpenTask('stopsearch', 'stopsearch:prepare', pid and GetPlayerServerId(pid) or nil)
    end },
} })

reg({ id = 'vpo_roads', items = {
    { label = 'Stop vehicle in front', icon = 'car-on', onSelect = cmd(Config.Roads.StopCommand) },
    { label = 'Roadside checks', icon = 'clipboard-check', onSelect = function()
        local veh = closestVehicle(); if veh then VPO.OpenRoadside(veh) end
    end },
    { label = 'Stinger', icon = 'road-spikes', onSelect = cmd(Config.Stinger.Command) },
} })

reg({ id = 'vpo_scene', items = {
    { label = 'Scene kit', icon = 'road-barrier', onSelect = cmd(Config.Scene.Command) },
    { label = 'Evidence markers', icon = 'location-pin', onSelect = function() CreateThread(VPO.PlaceMarkers) end },
    { label = 'Put up tape', icon = 'tape', onSelect = function() VPO.PutUpTape() end },
    { label = 'Take down tape', icon = 'scissors', onSelect = function()
        CreateThread(function()
            local id = VPO.NearestTape()
            if not id then return VPO.ClientNotify(L('tape_none_near'), 'error') end
            local res = lib.callback.await('vinewood_police:cb:scene:tapeRemove', false, { id = id })
            VPO.ClientNotify((type(res) == 'table' and res.error) or L('tape_down'), (type(res) == 'table' and res.error) and 'error' or 'success')
        end)
    end },
    { label = 'Major incident', icon = 'triangle-exclamation', onSelect = cmd(Config.Incidents.Command) },
} })

reg({ id = 'vpo_calls', items = {
    { label = 'Calls', icon = 'tower-broadcast', onSelect = cmd(Config.Callouts.Command) },
    { label = 'Request backup', icon = 'people-group', onSelect = backup(false) },
    { label = 'Urgent assistance', icon = 'bell', onSelect = backup(true) },
} })

reg({ id = 'vpo_station', items = {
    { label = 'Evidence', icon = 'box-archive', onSelect = cmd(Config.Evidence.Command) },
    { label = 'CID cases', icon = 'folder-open', onSelect = cmd(Config.CID.Command) },
    { label = 'Use of force forms', icon = 'file-signature', onSelect = function() VPO.UI.Open('forms') end },
    { label = 'Notebook', icon = 'book', onSelect = function() VPO.UI.Open('notebook') end },
    { label = 'Management', icon = 'users-gear', onSelect = cmd(Config.Management.Command) },
} })

--- The top level, rebuilt when duty changes (the dog only shows for the Dog section).
local function mainMenu(d)
    local items = {
        { label = 'Police hub', icon = 'id-badge', onSelect = function() VPO.UI.Open('duty') end },
        { label = 'Status', icon = 'signal', menu = 'vpo_status' },
        { label = 'Restrain', icon = 'handcuffs', menu = 'vpo_restrain' },
        { label = 'Search & arrest', icon = 'gavel', menu = 'vpo_arrest' },
        { label = 'Roads', icon = 'car', menu = 'vpo_roads' },
        { label = 'Scene', icon = 'road-barrier', menu = 'vpo_scene' },
        { label = 'Calls & backup', icon = 'tower-broadcast', menu = 'vpo_calls' },
        { label = 'Station', icon = 'building-shield', menu = 'vpo_station' },
    }
    if d and VPO.Util.Contains(Config.Dogs.Units, d.unit) then
        reg({ id = 'vpo_dog', items = {
            { label = 'Deploy / recall', icon = 'dog', onSelect = cmd(Config.Dogs.Command) },
            { label = 'Lead on / off', icon = 'link', onSelect = function() VPO.DogLead() end },
            { label = 'Heel', icon = 'person-walking', onSelect = function() VPO.DogHeel() end },
            { label = 'Send to a spot', icon = 'location-crosshairs', onSelect = function() CreateThread(VPO.DogSendAim) end },
        } })
        items[#items + 1] = { label = 'Dog', icon = 'dog', menu = 'vpo_dog' }
    end
    reg({ id = 'vpo_police_menu', items = items })
end

local shown, lastUnit = false, nil

local function add(d)
    statusMenu()
    mainMenu(d)
    if STYLE == 'ox' then lib.addRadialItem({ id = 'vpo_police', label = 'Police', icon = 'shield-halved', menu = 'vpo_police_menu' }) end
    shown, lastUnit = true, d.unit
end

local function refresh()
    local d = duty()
    if d then
        add(d)
    elseif shown then
        -- Duty can read as "off" for a moment during a relog or a state restore. Only take the
        -- Police section away if you're still off duty a few seconds later.
        SetTimeout(3000, function()
            if not duty() and shown then
                if STYLE == 'ox' then lib.removeRadialItem('vpo_police') end
                shown = false
            end
        end)
    end
end

AddEventHandler('vinewood_police:client:dutyChanged', function() SetTimeout(0, refresh) end)
CreateThread(function() Wait(2000); refresh() end)

-- Self-repair: anything that clears the radial (ox_lib restarting, another script clearing all radial
-- items, a missed duty update) is put right within a few seconds. Re-adding an item with the same id
-- just replaces it, so this is harmless.
CreateThread(function()
    while true do
        Wait(5000)
        local d = duty()
        if d then add(d) elseif shown then refresh() end
    end
end)

AddEventHandler('onClientResourceStart', function(res)
    if res == 'ox_lib' then SetTimeout(1500, function() shown = false; refresh() end) end
end)

-- Last resort for players: /policeradial rebuilds it straight away
RegisterCommand('policeradial', function()
    shown = false
    refresh()
    VPO.ClientNotify(duty() and L('radial_rebuilt') or L('perm_off_duty'), duty() and 'success' or 'error')
end, false)

-- No radial menu while handcuffed
if Cfg.DisableWhenCuffed then
    CreateThread(function()
        local disabled = false
        while true do
            Wait(500)
            local cuffed = VPO.IsCuffed and VPO.IsCuffed() or false
            if cuffed ~= disabled then
                disabled = cuffed
                if STYLE == 'ox' then lib.disableRadial(cuffed) end
                -- Coming out of cuffs: make sure the Police section is back too
                if not cuffed then shown = false; refresh() end
            end
        end
    end)
end

AddEventHandler('onResourceStop', function(res)
    if res ~= VPO.Resource then return end
    if shown and STYLE == 'ox' then lib.removeRadialItem('vpo_police') end
    if Cfg.DisableWhenCuffed and STYLE == 'ox' then lib.disableRadial(false) end
end)

---------------------------------------------------------------------------
-- Our own radial (Style = 'own'): L by default, rebindable in GTA settings, drawn by the NUI.
---------------------------------------------------------------------------
if STYLE == 'own' then
    local actions, open = {}, false

    -- Turn the menus into a tree the NUI can draw; actions stay here, looked up by id
    local function build(menuId, path, depth)
        local out = {}
        for i, it in ipairs(menus[menuId] or {}) do
            local id = path .. '.' .. i
            local node = { id = id, label = it.label, icon = it.icon }
            if it.menu and depth < 4 then node.items = build(it.menu, id, depth + 1)
            else actions[id] = it.onSelect end
            out[#out + 1] = node
        end
        return out
    end

    local function close()
        if not open then return end
        open = false
        SendNUIMessage({ type = 'radialClose' })
        if not VPO.UI.open then SetNuiFocus(false, false) end
    end

    local function openRadial()
        if open then return close() end
        local d = duty()
        if not d or VPO.UI.open or IsPauseMenuActive() then return end
        if Cfg.DisableWhenCuffed and VPO.IsCuffed and VPO.IsCuffed() then return end
        statusMenu(); mainMenu(d)
        actions = {}
        local items = build('vpo_police_menu', 'r', 1)
        open = true
        SetNuiFocus(true, true)
        SetCursorLocation(0.5, 0.5)
        SendNUIMessage({ type = 'radial', title = 'Police', items = items })
    end

    RegisterCommand('vpo_radial', openRadial, false)
    RegisterKeyMapping('vpo_radial', 'Police: radial menu', 'keyboard', Cfg.Key or 'L')

    RegisterNUICallback('radialSelect', function(body, cb)
        cb({})
        local fn = actions[type(body) == 'table' and body.id or '']
        close()
        if fn then CreateThread(fn) end
    end)
    RegisterNUICallback('radialClose', function(_, cb) cb({}); close() end)

    AddEventHandler('vinewood_police:client:dutyChanged', function(on) if not on then close() end end)
end
