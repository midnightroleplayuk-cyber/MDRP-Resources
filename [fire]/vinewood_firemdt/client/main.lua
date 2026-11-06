local isOpen = false
local configSent = false
local hydrantBlips = {}

local function streetAt(x, y, z)
    local s1, s2 = GetStreetNameAtCoord(x, y, z)
    local a, b = GetStreetNameFromHashKey(s1), s2 ~= 0 and GetStreetNameFromHashKey(s2) or nil
    local zone = GetLabelText(GetNameOfZone(x, y, z))
    local str = a
    if b and b ~= '' then str = str .. ' / ' .. b end
    if zone and zone ~= 'NULL' then str = str .. ', ' .. zone end
    return str
end

local function inAppliance()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 then return false end
    if Config.AllowEmergencyClass and GetVehicleClass(veh) == 18 then return true end
    local model = GetEntityModel(veh)
    for _, m in ipairs(Config.ApplianceModels) do
        if joaat(m) == model then return true end
    end
    return false
end

local function sharedConfig()
    return {
        branding = Config.Branding, statuses = Config.Statuses, incidentTypes = Config.IncidentTypes,
        priorities = Config.Priorities, assistance = Config.AssistanceMessages, hoseLength = Config.HoseLength,
        mapMin = Config.MapMinRange, mapMax = Config.MapMaxRange, hydrantTypes = Config.HydrantTypes,
        hydrantStatuses = Config.HydrantStatuses, riskLevels = Config.RiskLevels, hazmat = Hazmat,
        hydrantRadius = Config.HydrantSearchRadius, tone = Config.MobiliseTone, volume = Config.MobiliseVolume,
        stopCloses = Config.StopMessageClosesIncident, mapImage = Config.MapImage,
    }
end

local function close()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

local function open()
    if isOpen then return end
    if Config.RequireVehicle and not inAppliance() then
        return Config.Notify('The MDT is mounted in the appliance.', 'error')
    end
    local data = lib.callback.await('vfmdt:open', false)
    if not data or data.error then
        return Config.Notify(data and data.error or 'MDT unavailable', 'error')
    end
    if not configSent then
        SendNUIMessage({ action = 'config', data = sharedConfig() })
        configSent = true
    end
    data.serverId = GetPlayerServerId(PlayerId())
    isOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open', data = data })

    CreateThread(function()
        while isOpen do
            local c = GetEntityCoords(PlayerPedId())
            SendNUIMessage({ action = 'me', data = { x = c.x, y = c.y, z = c.z, heading = GetEntityHeading(PlayerPedId()) } })
            Wait(250)
        end
    end)
end

RegisterCommand(Config.Command, function()
    if isOpen then close() else open() end
end, false)
RegisterKeyMapping(Config.Command, 'Open the Fire MDT', 'keyboard', Config.Keybind)

-- ─────────────────────────────────────────────────────────────
-- Server → NUI
-- ─────────────────────────────────────────────────────────────
RegisterNetEvent('vfmdt:client:sync', function(kind, payload)
    if not configSent then
        SendNUIMessage({ action = 'config', data = sharedConfig() })
        configSent = true
    end
    SendNUIMessage({ action = 'sync', kind = kind, data = payload })
    if kind == 'priority' then
        Config.Notify(('PRIORITY: %s has pressed status 0'):format(payload.callsign), 'error')
        PlaySoundFrontend(-1, 'TIMER_STOP', 'HUD_MINI_GAME_SOUNDSET', true)
    elseif kind == 'message' and not isOpen then
        Config.Notify(('%s: %s'):format(payload.from, payload.text), 'inform')
    end
end)

RegisterNetEvent('vfmdt:client:mobilise', function(inc)
    if not configSent then
        SendNUIMessage({ action = 'config', data = sharedConfig() })
        configSent = true
    end
    SendNUIMessage({ action = 'mobilise', data = inc })
    if not isOpen then
        Config.Notify(('MOBILISE: %s - %s. Open the MDT to acknowledge.'):format(inc.type, inc.location), 'warning')
    end
end)

-- ─────────────────────────────────────────────────────────────
-- NUI → client / server
-- ─────────────────────────────────────────────────────────────
RegisterNUICallback('close', function(_, cb) close(); cb(true) end)

-- Generic proxy to whitelisted server callbacks
RegisterNUICallback('server', function(d, cb)
    if type(d.name) ~= 'string' or not d.name:find('^vfmdt:') then return cb({ false }) end
    local res = table.pack(lib.callback.await(d.name, false, table.unpack(d.args or {})))
    cb({ res[1], res[2] })
end)

RegisterNUICallback('setRoute', function(d, cb)
    SetNewWaypoint(d.x + 0.0, d.y + 0.0)
    Config.Notify('Route set on GPS.', 'success')
    cb(true)
end)

RegisterNUICallback('myPosition', function(_, cb)
    local c = GetEntityCoords(PlayerPedId())
    cb({ x = c.x, y = c.y, z = c.z, street = streetAt(c.x, c.y, c.z) })
end)

RegisterNUICallback('waypointPosition', function(_, cb)
    local blip = GetFirstBlipInfoId(8)
    if not DoesBlipExist(blip) then return cb({ error = 'No waypoint set on the map' }) end
    local c = GetBlipInfoIdCoord(blip)
    local z = c.z
    for h = 1000.0, 0.0, -50.0 do
        local found, gz = GetGroundZFor_3dCoord(c.x, c.y, h, false)
        if found then z = gz break end
    end
    cb({ x = c.x, y = c.y, z = z, street = streetAt(c.x, c.y, z) })
end)

RegisterNUICallback('calibrated', function(d, cb)
    local line = ('minX = %.1f, maxX = %.1f, minY = %.1f, maxY = %.1f'):format(d.minX, d.maxX, d.minY, d.maxY)
    print('^3[vinewood_firemdt]^7 Map calibration - paste into Config.MapImage:\n    ' .. line)
    Config.Notify('Calibration printed to F8 console.', 'success')
    cb(true)
end)

RegisterNUICallback('streetAt', function(d, cb) cb(streetAt(d.x + 0.0, d.y + 0.0, (d.z or 0) + 0.0)) end)

RegisterNUICallback('scanVehicle', function(_, cb)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local target
    local vehicle = lib.getClosestVehicle(GetEntityCoords(ped), 10.0, false)
    -- prefer a vehicle that isn't our own appliance
    if vehicle and vehicle ~= veh then target = vehicle elseif veh == 0 then target = vehicle end
    if not target or target == 0 then return cb({ error = 'No vehicle within 10 metres' }) end
    local model = GetEntityModel(target)
    local name = GetDisplayNameFromVehicleModel(model):lower()
    local class = GetVehicleClass(target)
    local make = GetMakeNameFromVehicleModel and GetLabelText(GetMakeNameFromVehicleModel(model)) or ''
    if make == 'NULL' then make = '' end
    cb({
        model = name, label = GetLabelText(GetDisplayNameFromVehicleModel(model)), make = make, class = class,
        plate = GetVehicleNumberPlateText(target), sheet = RescueData[name], classInfo = RescueClassDefaults[class],
        engineHealth = math.floor(GetVehicleEngineHealth(target)), onFire = IsEntityOnFire(target),
        occupants = GetVehicleNumberOfPassengers(target) + (IsVehicleSeatFree(target, -1) and 0 or 1),
    })
end)

RegisterNUICallback('scanHydrants', function(_, cb)
    local me = GetEntityCoords(PlayerPedId())
    local hashes = {}
    for _, m in ipairs(Config.WorldHydrantProps) do hashes[joaat(m)] = m end
    local found = {}
    for _, obj in ipairs(GetGamePool('CObject')) do
        local m = GetEntityModel(obj)
        if hashes[m] then
            local c = GetEntityCoords(obj)
            local dist = #(c - me)
            if dist < 80.0 then
                found[#found + 1] = { x = c.x, y = c.y, z = c.z, model = hashes[m], dist = math.floor(dist), street = streetAt(c.x, c.y, c.z) }
            end
        end
    end
    table.sort(found, function(a, b) return a.dist < b.dist end)
    cb(found)
end)

RegisterNUICallback('hydrantBlips', function(d, cb)
    for _, b in ipairs(hydrantBlips) do RemoveBlip(b) end
    hydrantBlips = {}
    for _, h in ipairs(d.list or {}) do
        local b = AddBlipForCoord(h.x + 0.0, h.y + 0.0, (h.z or 0) + 0.0)
        SetBlipSprite(b, 1)
        SetBlipScale(b, 0.6)
        SetBlipColour(b, h.status == 'Serviceable' and 3 or 1)
        SetBlipAsShortRange(b, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Hydrant ' .. (h.code or ''))
        EndTextCommandSetBlipName(b)
        hydrantBlips[#hydrantBlips + 1] = b
    end
    cb(#hydrantBlips)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if isOpen then SetNuiFocus(false, false) end
    for _, b in ipairs(hydrantBlips) do RemoveBlip(b) end
end)
