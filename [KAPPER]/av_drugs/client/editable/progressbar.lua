function progressBar(dict, anim, duration, prop, flag, blendIn, blendOut, disableWalk)
    local completed = false
    local data = {
        duration = duration or 10000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = disableWalk and not disableWalk or false,
            car = true,
        },
        anim = {
            dict = dict or false,
            clip = anim or false,
            flag = flag or 1,
            blendIn = blendIn or 3.0,
            blendOut = blendOut or 1.0,
        },
        prop = prop or nil,
    }
    if Config.ProgressType == "progressBar" then
        completed = exports['av_laptop']:progressBar(data)
    else
        completed = exports['av_laptop']:progressCircle(data)
    end
    if exports['av_laptop']:isDead() then
        return false
    end
    return completed
end