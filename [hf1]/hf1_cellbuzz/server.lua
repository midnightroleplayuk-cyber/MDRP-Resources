local state = {}

local function isPolice(source)
    local player = exports.qbx_core:GetPlayer(source)
    return player and player.PlayerData and player.PlayerData.job and player.PlayerData.job.name == Config.PoliceJob and player.PlayerData.job.onduty == true
end

local function near(source, coords, maxDistance)
    local ped = GetPlayerPed(source)
    return ped ~= 0 and #(GetEntityCoords(ped) - coords) <= maxDistance
end

local function notify(source, message, kind)
    TriggerClientEvent('ox_lib:notify', source, { title = 'Cell Buzzer', description = message, type = kind or 'inform' })
end

for stationId, station in pairs(Config.Stations) do
    state[stationId] = {}
    for i = 1, #station.buzzers do
        state[stationId][i] = { enabled = true, pending = false, nextPress = 0 }
    end
end

local function broadcastState(stationId)
    TriggerClientEvent('hf1_cellbuzz:client:state', -1, stationId, state[stationId])
end

lib.callback.register('hf1_cellbuzz:server:getState', function(source, stationId)
    if not Config.Stations[stationId] then return nil end
    return state[stationId]
end)

lib.callback.register('hf1_cellbuzz:server:getControl', function(source, stationId)
    local station = Config.Stations[stationId]
    if not station or not isPolice(source) or not near(source, station.control, Config.ControlServerDistance) then return nil end
    return state[stationId]
end)

RegisterNetEvent('hf1_cellbuzz:server:press', function(stationId, index)
    local source = source
    local station = Config.Stations[stationId]
    if not station or type(index) ~= 'number' or index % 1 ~= 0 then return end
    local buzzer = station.buzzers[index]
    local entry = state[stationId] and state[stationId][index]
    if not buzzer or not entry or not near(source, buzzer.coords, Config.BuzzerServerDistance) then return end

    if not entry.enabled then
        notify(source, 'Buzzer has been disabled.', 'error')
        return
    end
    local now = os.time()
    if entry.nextPress > now then
        notify(source, ('You must wait %d seconds before you can ring buzzer again.'):format(entry.nextPress - now), 'error')
        return
    end

    entry.nextPress = now + Config.CooldownSeconds
    entry.pending = true
    notify(source, 'Buzzer Pressed - An officer will be with you shortly.', 'success')
    broadcastState(stationId)

    for _, id in ipairs(GetPlayers()) do
        local officer = tonumber(id)
        if isPolice(officer) then
            TriggerClientEvent('hf1_cellbuzz:client:policeAlert', officer, stationId, buzzer.name)
        end
    end
end)

RegisterNetEvent('hf1_cellbuzz:server:control', function(stationId, index, action)
    local source = source
    local station = Config.Stations[stationId]
    if not station or not isPolice(source) or not near(source, station.control, Config.ControlServerDistance) then return end
    if type(index) ~= 'number' or index % 1 ~= 0 then return end
    local entry = state[stationId] and state[stationId][index]
    if not entry then return end
    if action == 'toggle' then
        entry.enabled = not entry.enabled
        if not entry.enabled then entry.pending = false end
    elseif action == 'clear' then
        entry.pending = false
    else
        return
    end
    broadcastState(stationId)
    notify(source, ('%s: %s'):format(station.buzzers[index].name, action == 'clear' and 'request cleared' or (entry.enabled and 'enabled' or 'disabled')), 'success')
end)
