-- Progressbar, used for painting and vin scratching, feel free to replace it with your own implementation
function progressBar(dict, anim, duration, label, flag)
    dbug("progressBar() called with dict:", dict, "anim:", anim, "duration:", duration, "label:", label, "flag:", flag)
     if not dict or not anim or not duration then
         warn("progressBar() missing parameters")
         return false
     end
    local completed = false
    local data = {
        label = label or "Progress",
        duration = duration,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
        },
        anim = {
            dict = dict,
            clip = anim,
            flag = flag or 1,
        },
    }
    completed = exports['av_laptop']:progressBar(data)
    if exports['av_laptop']:isDead() then
        dbug("Player is dead, returning false")
        return false
    end
    return completed
end