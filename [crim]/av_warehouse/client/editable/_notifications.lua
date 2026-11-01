RegisterNetEvent('av_warehouse:notification', function(title,msg,type)
    lib.notify({
        title = title or 'Warehouse',
        description = msg or "",
        type = type
    })
end)