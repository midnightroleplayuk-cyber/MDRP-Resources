local default = {
    value = "burger",
    label = "Burger",
    progressLabel = "Eating",
    time = 5000,
    canWalk = true,
    canDrive = true,
    jobs = false,
    type = { "food", "fryer" },
    anim = {
        dict = "mp_player_inteat@burger",
        clip = "mp_player_int_eat_burger"
    },
    prop = {
        model = "prop_cs_burger_01",
        bone = 18905,
        pos = { x = 0.13, y = 0.05, z = 0.02 },
        rot = { x = -50.0, y = 16.0, z = 60.0 }
    }
}

function doAnimation(value)
    dbug('doAnimation(value)', value)
    local animData = animList and animList[value] or nil
    if not animData then
        dbug("Using default animation")
        animData = default
    end
    local props = formatPropsToFloat(animData['prop'])
    local result = exports['av_laptop']:progressBar({
        duration = animData['time'] or 5000,
        label = animData['progressLabel'] or "Consuming",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = not animData['canWalk'],
            car = not animData['canDrive'],
        },
        anim = animData['anim'] or default['anim'],
        prop = props
    })
    return result
end

local busy = false
RegisterNUICallback('testAnim', function(data,cb)
    CreateThread(function()
        if busy then return end
        busy = true
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = "opacity",
            data = 0.0
        })
        local props = formatPropsToFloat(data['prop'])
        exports['av_laptop']:progressBar({
            duration = data['time'] or 5000,
            label = data['progressLabel'] or data['label'] or "Consuming",
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = not data['canWalk'],
                car = not data['canDrive'],
            },
            anim = data['anim'] or default['anim'],
            prop = props
        })
        lib.timer(1000, function()
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "opacity",
                data = 1.0
            })
            busy = false
        end,true)
    end)
    cb("ok")
end)