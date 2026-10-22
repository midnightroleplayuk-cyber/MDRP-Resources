local activeAlarms = {}

local function notify(description, kind)
    lib.notify({ title = 'Police Station Alarm', description = description, type = kind or 'inform', icon = 'triangle-exclamation' })
end

RegisterNetEvent('hf1_stationalarm:client:state', function(stationId, enabled)
    activeAlarms[stationId] = enabled
    local station = Config.Stations[stationId]
    if not station then return end
    SendNUIMessage({ action = enabled and 'play' or 'stop', id = stationId,
        file = Config.SoundFile, origin = { x = station.soundOrigin.x, y = station.soundOrigin.y, z = station.soundOrigin.z },
        volume = Config.SoundVolume, distance = Config.SoundDistance })
    if enabled then
        notify('Emergency Alarm has been pressed.', 'error')
    else
        notify('Emergency Alarm has been reset.', 'success')
    end
end)

CreateThread(function()
    for stationId, station in pairs(Config.Stations) do
        for index, coords in ipairs(station.alarmPoints) do
            exports.ox_target:addSphereZone({
                coords = coords.xyz, radius = 0.55, debug = false,
                options = {{ name = ('hf1_alarm_%s_%s'):format(stationId, index), icon = 'fa-solid fa-triangle-exclamation',
                    label = 'Emergency Alarm', groups = { police = 0 }, distance = Config.InteractDistance,
                    canInteract = function() return Config.InFront(coords, GetEntityCoords(PlayerPedId())) end,
                    onSelect = function() TriggerServerEvent('hf1_stationalarm:server:set', stationId, true) end }}
            })
        end
        for index, coords in ipairs(station.resetPoints) do
            exports.ox_target:addSphereZone({
                coords = coords.xyz, radius = 0.55, debug = false,
                options = {{ name = ('hf1_reset_%s_%s'):format(stationId, index), icon = 'fa-solid fa-rotate-left',
                    label = 'Reset Alarm', groups = { police = 0 }, distance = Config.InteractDistance,
                    canInteract = function() return Config.InFront(coords, GetEntityCoords(PlayerPedId())) end,
                    onSelect = function() TriggerServerEvent('hf1_stationalarm:server:set', stationId, false) end }}
            })
        end
    end
    local state = lib.callback.await('hf1_stationalarm:server:getStates', false)
    if state then
        for stationId, enabled in pairs(state) do
            if enabled and Config.Stations[stationId] then
                activeAlarms[stationId] = true
                local station = Config.Stations[stationId]
                SendNUIMessage({ action = 'play', id = stationId, file = Config.SoundFile,
                    origin = { x = station.soundOrigin.x, y = station.soundOrigin.y, z = station.soundOrigin.z },
                    volume = Config.SoundVolume, distance = Config.SoundDistance })
            end
        end
    end
end)

CreateThread(function()
    while true do
        local coords = GetEntityCoords(PlayerPedId())
        SendNUIMessage({ action = 'position', x = coords.x, y = coords.y, z = coords.z })
        Wait(250)
    end
end)
