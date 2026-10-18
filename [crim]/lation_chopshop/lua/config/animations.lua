return {
    placeStand = {
        label = 'Placing stand..',
        duration = 1200,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
        anim = {
            dict = 'pickup_object',
            clip = 'pickup_low',
            flag = 49,
        },
        prop = {},
    },

    removeWheel = {
        dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
        clip = 'machinic_loop_mechandplayer',
        flag = 1,
    },

    -- Standing, hands at chest height. The wheel clip kneels at hub height,
    -- which reads wrong at a door hinge.
    removeDoor = {
        dict = 'mini@repair',
        clip = 'fixing_a_player',
        flag = 1,
    },

    repairEngine = {
        dict = 'mini@repair',
        clip = 'fixing_a_player',
        flag = 1,
    },

    viewContract = {
        anim = {
            dict = 'amb@world_human_clipboard@male@idle_a',
            clip = 'idle_a',
            flag = 49,
        },
        prop = {
            model = 'p_amb_clipboard_01',
            boneIndex = 42,
            pos = vec3(0.204833984375, 0.06727672368288, 0.099686451256275),
            rot = vec3(-40.54178237915, -119.36616516113, -132.13168334961),
        },
    },
}
