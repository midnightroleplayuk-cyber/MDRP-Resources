RegisterNetEvent('admin-pedchange:notify', function(message, kind)
    if lib and lib.notify then
        lib.notify({
            title = 'Ped Change',
            description = message,
            type = kind or 'inform'
        })
    else
        print(('[Ped Change] %s'):format(message))
    end
end)
