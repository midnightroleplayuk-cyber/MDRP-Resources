local usingPC = false
local dict = "mp_fbi_heist"
local anim = "loop"

function canSeizeLab() -- return true/false to enable Seize Button in lab laptop
    return exports['av_laptop']:hasJob(Config.PoliceJobs)
end

RegisterNetEvent('av_drugs:labPC', function(data)
    if usingPC then return end
    local identifier = data and data['identifier'] or false
    if not identifier then
        print("^3[WARNING]^7 av_drugs:labPC received null instead of identifier")
        print("^3[WARNING]^7 av_drugs:labPC received null instead of identifier")
        print("^3[WARNING]^7 av_drugs:labPC received null instead of identifier")
        return
    end
    if data and data['hasKeys'] then
        usingPC = true
        lib.requestAnimDict(dict)
        TaskPlayAnim(cache.ped, dict, anim, 5.0, 5.0, -1, 1, 0, false, false, false)
        SetNuiFocus(true,true)
        SendNUIMessage({
            message = "loadLab",
            state = identifier
        })
    else
        TriggerEvent('av_laptop:notification',Lang['app_title'], Lang['no_access'], 'error')
    end
end)

RegisterNUICallback('close', function(data,cb)
    if usingPC then
        usingPC = false
        dbug("close")
        SendNUIMessage({
            message = "close",
            state = false
        })
        SetNuiFocus(false, false)
        ClearPedTasks(cache.ped)
        RemoveAnimSet(dict)
        inputClosed()
    end
    cb('ok')
end)