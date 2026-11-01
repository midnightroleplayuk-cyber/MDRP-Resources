function progressBar()
    return lib.progressCircle({
        duration = math.random(3000,4000),
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true
        },
    })
end