-- Client side of Axis Link: heal, revive and announcements.

local function fullHeal()
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
end

RegisterNetEvent('axislink:client:heal', function()
    fullHeal()
end)

RegisterNetEvent('axislink:client:revive', function()
    local ped = PlayerPedId()
    if IsEntityDead(ped) or IsPedFatallyInjured(ped) then
        local c = GetEntityCoords(ped)
        NetworkResurrectLocalPlayer(c.x, c.y, c.z, GetEntityHeading(ped), true, false)
        ClearPedTasksImmediately(PlayerPedId())
    end
    fullHeal()
end)

RegisterNetEvent('axislink:client:announce', function(message)
    if GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:notify({ title = 'Announcement', description = message, type = 'inform', duration = 12000 })
    end
    TriggerEvent('chat:addMessage', { color = { 255, 80, 80 }, multiline = true, args = { 'ANNOUNCEMENT', message } })
end)

RegisterNetEvent('axislink:client:dm', function(message)
    if GetResourceState('ox_lib') == 'started' then
        exports.ox_lib:notify({ title = 'Message from staff', description = message, type = 'inform', duration = 15000 })
    end
    TriggerEvent('chat:addMessage', { color = { 80, 160, 255 }, multiline = true, args = { 'STAFF MESSAGE', message } })
end)
