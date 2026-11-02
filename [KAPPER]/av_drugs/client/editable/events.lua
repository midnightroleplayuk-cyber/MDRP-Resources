--- Events triggered from target.lua
RegisterNetEvent('av_drugs:destroyTable', function(data)
    if LocalPlayer.state.busy then return end
    dbug('av_drugs:destroyTable', data['identifier'], data['owner'])
--    print(json.encode(data))
    if data and data['identifier'] then
        LocalPlayer.state.busy = true
        FreezeEntityPosition(cache.ped,true)
        TaskStartScenarioInPlace(cache.ped, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
        local res = progressBar(false, false, Config.RemovingTime)
        FreezeEntityPosition(cache.ped,false)
        ClearPedTasks(cache.ped)
        lib.timer(500, function()
            LocalPlayer.state.busy = false
        end, true)
        if not res then return end
        TriggerServerEvent('av_drugs:destroyTable', data['identifier'], data['owner'])
    end
end)

RegisterNetEvent('av_drugs:removeTable', function(data)
    if LocalPlayer.state.busy then return end
    dbug('av_drugs:removeTable', data['identifier'], data['owner'])
    if data and data['identifier'] then
        LocalPlayer.state.busy = true
        FreezeEntityPosition(cache.ped,true)
        TaskStartScenarioInPlace(cache.ped, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
        local res = progressBar(false, false, Config.RemovingTime)
        FreezeEntityPosition(cache.ped,false)
        ClearPedTasks(cache.ped)
        lib.timer(500, function()
            LocalPlayer.state.busy = false
        end, true)
        if not res then return end
        TriggerServerEvent('av_drugs:removeTable', data['identifier'], data['itemName'], data['owner'])
    end
end)