RegisterNetEvent('op-multicharacter:sendNotify')
AddEventHandler('op-multicharacter:sendNotify', function(title, type, time)
    sendNotify(title, type, time)
end)

function sendNotify(title, type, time)
    if Config.Notify == "ESX" then
        Framework.ShowNotification(title, type, time)
    elseif Config.Notify == "QBCORE" or Config.Notify == "QBOX" then
        Framework.Functions.Notify(title, type, time * 1000)
    elseif Config.Notify == "op_hud" then
        TriggerEvent('op-hud:showNotification', type, time, title) 
    elseif Config.Notify == "okokNotify" then
        exports['okokNotify']:Alert("", title, time, type)
    elseif Config.Notify == "vms_notify" then
        exports["vms_notify"]:Notification("Notify", title, time, "#5feb34", "")
    elseif Config.Notify == "brutal_notify" then
        exports['brutal_notify']:SendAlert('Notify', title, time, type, false)
    elseif Config.Notify == "ox_lib" then
        if type == "info" then type = "inform" end
        local data = {
            description = title,
            duration = time * 1000,
            type = type
        }
        lib.notify(data)
    elseif Config.Notify == "QBOX" then
        type = type == "info" and "inform" or type
        exports.qbx_core:Notify(title, type, time * 1000, false, "top-right")
    end
end