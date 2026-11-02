onlineCops = 0

RegisterNetEvent('av_drugs:setCopsCount', function(count)
    onlineCops = count or 0
    refreshCops()
end)