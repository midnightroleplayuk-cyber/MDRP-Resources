---------------------------------
-------- Notifications  ---------
---------------------------------

RegisterNetEvent('opm:client:notify', function(title, nType, time)
    sendNotify(title, nType, time)
end)

function sendNotify(title, type, time)
    if not time then time = 5 end
    if type == 'primary' then type = 'inform' end
    if type == 'info' then type = 'inform' end

    local provider = Config.Notify or 'none'
    if provider == 'none' then
        if Config.Framework == 'esx' then
            provider = 'ESX'
        elseif Config.Framework == 'qb' then
            provider = 'QBCORE'
        elseif Config.Framework == 'qbox' then
            provider = 'QBOX'
        end
    end

    if provider == 'ESX' then
        if Framework and Framework.ShowNotification then
            Framework.ShowNotification(title)
        end
    elseif provider == 'QBCORE' then
        local qbType = (type == 'inform') and 'primary' or type
        if Framework and Framework.Functions and Framework.Functions.Notify then
            Framework.Functions.Notify(title, qbType, time * 1000)
        end
    elseif provider == 'QBOX' then
        exports.qbx_core:Notify(title, type, time * 1000, false, 'top-right')
    elseif provider == 'op_hud' then
        local hudType = type == 'inform' and 'info' or type
        TriggerEvent('op-hud:showNotification', hudType, time, title)
    elseif provider == 'okokNotify' then
        local okokType = type == 'inform' and 'info' or type
        exports['okokNotify']:Alert('', title, time, okokType)
    elseif provider == 'vms_notify' then
        exports['vms_notify']:Notification('Notify', title, time, '#5feb34', '')
    elseif provider == 'brutal_notify' then
        local brutalType = type == 'inform' and 'info' or type
        exports['brutal_notify']:SendAlert('Notify', title, time, brutalType, false)
    elseif provider == 'ox_lib' then
        lib.notify({
            description = title,
            duration = time * 1000,
            type = type,
        })
    end
end

function Fr.Notify(message, nType, time)
    sendNotify(message, nType, time)
end