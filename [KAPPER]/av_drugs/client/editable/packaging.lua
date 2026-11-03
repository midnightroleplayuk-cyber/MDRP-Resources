RegisterNetEvent('av_drugs:packaging', function(name,metadata,time)
    if LocalPlayer.state.busy then return end
    LocalPlayer.state.busy = true
    local inVehicle = GetVehiclePedIsIn(cache.ped,false) ~= 0
    if not inVehicle then
        FreezeEntityPosition(cache.ped,true)
        TaskStartScenarioInPlace(cache.ped, "PROP_HUMAN_PARKING_METER", 0, true)
    end
    local res = progressBar(false, false, time or 15000) -- start animation
    if not inVehicle then
        FreezeEntityPosition(cache.ped,false)
        ClearPedTasks(cache.ped)
    end
    lib.timer(500, function()
        LocalPlayer.state.busy = false
    end, true)
    if not res then return end
    TriggerServerEvent('av_drugs:processBatch',name,metadata)
end)