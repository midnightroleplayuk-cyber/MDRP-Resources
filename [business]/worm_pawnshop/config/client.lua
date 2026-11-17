--[[ worm_pawnshop - client settings ]]

return {
    --#region carrying the box ------------------------------------------------------
    carry = {
        prop = 'prop_cs_cardbox_01',
        bone = 60309,
        offset = vec3(0.025, 0.08, 0.255),
        rotation = vec3(-145.0, 290.0, 0.0),
        anim = { dict = 'anim@heists@box_carry@', name = 'idle', flag = 49 },
        -- Played when the box is loaded into the truck; the box attaches this many ms before the animation ends
        -- bone/offset/rotation: where the box sits in the hands during that animation (tune with /pawnprop)
        placeAnim = {
            dict = 'anim@heists@load_box', name = 'load_box_3', attachBeforeEndMs = 750,
            bone = 60309,
            offset = vec3(0.007, 0.005, 0.029),
            rotation = vec3(-86.440, 360.980, -190.680),
        },
        -- Played when the box is picked up at a pickup point; the box attaches attachAfterMs into the animation
        pickupAnim = {
            dict = 'anim@heists@load_box', name = 'load_box_2', flag = 4096, attachAfterMs = 2400,
            bone = 57005,
            offset = vec3(-0.023, 0.298, -0.044),
            rotation = vec3(18.7, -72.2, -55.1),
        },
        loopMs = 500,           -- the animation / prop is checked this often
        -- Controls disabled while carrying (sprint, weapons, cover, phone...); jumping stays allowed
        disabledControls = { 21, 24, 25, 36, 37, 44, 47, 58, 140, 141, 142, 143, 257, 263, 264 },
        blockVehicle = true,    -- no entering vehicles while carrying
    },
    --#endregion

    --#region session / DUI -------------------------------------------------------------
    session = {
        walkToStand = false,    -- true: walk to the calibrated stand point first; false: stay where you are and switch to the camera right away
        camInterp = 350,
        leaveDistance = 2.5,    -- the session ends when this far from where it started
        -- Controls disabled during a session (movement, weapons, phone, pause...)
        blockedControls = {
            1, 2, 3, 4, 5, 6, 12, 13, 14, 15, 16, 17, 22, 23, 24, 25, 30, 31, 32, 33, 34, 35, 36, 37, 44, 45, 47,
            58, 71, 72, 73, 74, 75, 140, 141, 142, 143, 199, 200, 244, 245, 257, 263, 264, 288, 289,
        },
        resendMs = 1000,
        keepScreenMs = 0,       -- how long the browser stays open after leaving (0 = closed right away)
        useAnim = { dict = 'anim@heists@prison_heiststation@cop_reactions', name = 'cop_b_idle', flag = 1 },
        typingAnim = { dict = 'anim@heists@ornate_bank@hack', name = 'hack_loop', flag = 1 },
    },

    dui = {
        liftNear = 0.004,
        liftPerMetre = 0.004,
        liftMax = 0.08,
        idleDestroyMs = 20000,  -- an unused browser is closed after this many ms
    },
    --#endregion

    --#region task list ------------------------------------------------------------------
    -- The delivery's steps in worm_lib's task list (top left), from the box landing in the stash
    -- until the truck drives off. Labels are the task_* locale keys.
    taskList = {
        enabled = true,
        hideAfter = 3000,       -- ms the finished list stays on screen once the truck has left
    },
    --#endregion

    --#region driver reaction ----------------------------------------------------------
    driver = {
        cutAnim = { dict = 'mp_common', name = 'givetake1_a', duration = 1800 },
        goodbyeAnim = { dict = 'gestures@m@standing@casual', name = 'gesture_bye_soft', duration = 1500 },
    },
    --#endregion

    --#region dev mode -------------------------------------------------------------------
    dev = {
        command = 'pawndev',
        modelCommand = 'pawnmodel',
        propCommand = 'pawnprop',   -- /pawnprop [carry|place|pickup]: tune the box offset in the hands, prints config lines when saved
        moveSpeed = 0.10,       -- m/s while a key is held
        rotateSpeed = 20.0,     -- degrees/s
        sizeSpeed = 0.15,       -- ratio/s
        ghostAlpha = 160,
    },
    --#endregion
}
