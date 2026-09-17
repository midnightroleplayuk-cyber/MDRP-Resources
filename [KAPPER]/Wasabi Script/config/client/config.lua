-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

ClientConfig = {}

-- tablet prop while MDT is open
ClientConfig.TabletAnim = {
    dict = 'amb@code_human_in_bus_passenger_idles@female@tablet@idle_a',
    name = 'idle_a',
    prop = 'prop_cs_tablet',
    bone = 28422,
    offset = vec3(-0.05, 0.0, 0.0),
    rotation = vec3(0.0, -90.0, 0.0),
}

-- dispatch HUD / panic keybinds
ClientConfig.DispatchKeybinds = {
    panicButton = {
        enabled = true,
        key = 'F9',
        description = 'Activate Panic Button',
    },
    toggleDispatchHud = {
        enabled = true,
        key = 'F11',
        description = 'Toggle Dispatch HUD',
    },
    toggleDispatchFocus = {
        enabled = true,
        key = 'Z',
        description = 'Toggle Dispatch HUD Focus',
    },
    holdDispatchFocus = {
        enabled = true,
        key = 'G',
        modifierControl = 19, -- INPUT_CHARACTER_WHEEL / LEFT ALT
        keyControl = 47, -- INPUT_DETONATE / G
        requireModifier = true,
        hint = 'Press ALT + G to interact',
    },
}

-- cctv prop streaming
ClientConfig.Cameras = {
    spawnDistance = 40.0,
    checkInterval = 1000,
    repositionGhostAlpha = 90,
    models = {
        { model = 'prop_cctv_cam_01a',     label = 'Standard CCTV Camera',     viewOffset = { x = 0, y = 0, z = -0.1 },  rotationOffset = { x = -10.0, y = 0, z = 180.0 } },
        { model = 'prop_cctv_cam_01b',     label = 'Standard CCTV Camera B',   viewOffset = { x = 0, y = 0, z = -0.1 },  rotationOffset = { x = -10.0, y = 0, z = 180.0 } },
        { model = 'prop_cctv_cam_02a',     label = 'Wall-mounted Camera',      viewOffset = { x = 0, y = 0, z = -0.15 }, rotationOffset = { x = -10.0, y = 0, z = 180.0 } },
        { model = 'prop_cctv_cam_03a',     label = 'Dome Camera',              viewOffset = { x = 0, y = 0, z = -0.2 },  rotationOffset = { x = -15.0, y = 0, z = 180.0 } },
        { model = 'prop_cctv_cam_04a',     label = 'Modern Security Camera',   viewOffset = { x = 0, y = 0, z = -0.1 },  rotationOffset = { x = -10.0, y = 0, z = 180.0 } },
        { model = 'prop_cctv_cam_04b',     label = 'Modern Security Camera B', viewOffset = { x = 0, y = 0, z = -0.1 },  rotationOffset = { x = -10.0, y = 0, z = 180.0 } },
        { model = 'prop_cctv_cam_04c',     label = 'Modern Security Camera C', viewOffset = { x = 0, y = 0, z = -0.1 },  rotationOffset = { x = -10.0, y = 0, z = 180.0 } },
        { model = 'prop_cctv_cam_05a',     label = 'PTZ Camera',               viewOffset = { x = 0, y = 0, z = -0.1 },  rotationOffset = { x = -10.0, y = 0, z = 180.0 } },
        { model = 'prop_cctv_cam_06a',     label = 'Outdoor Camera',           viewOffset = { x = 0, y = 0, z = -0.1 },  rotationOffset = { x = -10.0, y = 0, z = 180.0 } },
        { model = 'prop_cctv_cam_07a',     label = 'High Security Camera',     viewOffset = { x = 0, y = 0, z = -0.1 },  rotationOffset = { x = -10.0, y = 0, z = 180.0 } },
        { model = 'hei_prop_bank_cctv_01', label = 'Bank CCTV Camera',         viewOffset = { x = 0, y = 0, z = -0.15 }, rotationOffset = { x = -10.0, y = 0, z = 180.0 } },
        { model = 'hei_prop_bank_cctv_02', label = 'Bank Dome Camera',         viewOffset = { x = 0, y = 0, z = -0.2 },  rotationOffset = { x = -15.0, y = 0, z = 180.0 } },
    },
}

-- map blips for active calls
ClientConfig.DispatchBlips = {
    enabled = true,
    sprite = 161,
    color = 1,
    scale = 0.9,
    duration = 60000, -- ms after create
}

-- stop bodycam (start is from MDT header Record button)
ClientConfig.BodyCam = {
    stopKeybind = {
        enabled = true,
        description = 'Stop BodyCam Recording',
    },
}
