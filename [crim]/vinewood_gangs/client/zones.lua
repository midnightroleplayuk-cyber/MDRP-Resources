local currentZone
local cfg = Config.Territory.enterNotice
local lastNotice = {} -- lastNotice[zone] = GetGameTimer() it was last announced

local function shouldTell()
    if not cfg.enabled then return false end
    return cfg.showTo == 'everyone' or GetPlayerGang() ~= nil
end

---Tells the player which area they've walked into and who runs it.
local function announce(zone, previous)
    if not shouldTell() then return end
    local now = GetGameTimer()

    if not zone then
        if cfg.onLeave and previous then
            lib.notify({ description = locale('zone_left'), type = 'inform', icon = 'map-location-dot' })
        end
        return
    end
    if lastNotice[zone] and now - lastNotice[zone] < cfg.cooldown * 1000 then return end
    lastNotice[zone] = now

    local state = ZoneOwnerInfo(zone)
    local label = Zones.Label(zone)
    local gang = GetPlayerGang()
    local message, kind
    if not state or not state.owner then
        message, kind = locale('zone_enter_unclaimed'), 'inform'
    elseif gang and state.owner == gang.id then
        message, kind = locale('zone_enter_ours'), 'success'
    else
        message, kind = locale('zone_enter_theirs', state.label or '?'), 'warning'
    end
    lib.notify({ title = label, description = message, type = kind, icon = 'map-location-dot', iconColor = state and state.colour or nil })
end

CreateThread(function()
    Wait(5000) -- don't announce the area you spawn in before the gang data has arrived
    currentZone = Zones.FromCoords(GetEntityCoords(cache.ped))
    while true do
        local zone = Zones.FromCoords(GetEntityCoords(cache.ped))
        if zone ~= currentZone then
            local previous = currentZone
            currentZone = zone
            local state = ZoneOwnerInfo(zone)
            TriggerEvent('vinewood_gangs:client:zoneChanged', zone, state)
            announce(zone, previous)
        end
        Wait(1000)
    end
end)

AddStateBagChangeHandler('vg_zones', 'global', function(_, _, value)
    if currentZone and value and value[currentZone] then
        TriggerEvent('vinewood_gangs:client:zoneChanged', currentZone, value[currentZone])
    end
end)

exports('GetCurrentZone', function() return currentZone end)
