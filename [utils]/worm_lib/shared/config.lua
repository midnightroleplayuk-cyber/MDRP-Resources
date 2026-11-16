Config = {
    nuiGateNotifyMessage = 'Bu işlem için gerekli kütüphane doğrulanamadı.',
    nuiGateUseStatebag = false,
    nuiGateStateKey = 'worm_lib_nui',

    -- Print extra info to the console (alerts when no dispatch system is running, etc.).
    debug = false,

    -- Compare the running version with the latest release on start and print a line when a newer one is out
    -- (one GitHub request per start)
    versionCheck = true,

    -- Notifications: 'auto' (ox if ox_lib is available) | 'ox' | 'framework'
    notify = 'auto',

    -- Progress bar: 'bar' | 'circle' (ox_lib) | 'qb' (QBCore.Functions.Progressbar)
    progress = 'bar',

    -- Dispatch: 'auto' | 'ps-dispatch' | 'cd_dispatch' | 'qs-dispatch' | 'rcore_dispatch'
    --           | 'linden_outlawalert' | 'core_dispatch' | 'origen_police' | 'codem-dispatch'
    --           | 'tk_dispatch' | 'emergencydispatch' | 'lb-tablet' | 'redutzu-mdt' | 'piotreq_gpt'
    --           | 'kartik-mdt' | 'custom' | 'none'
    -- Scripts may also send alerts from the server (exports.worm_lib:dispatch(0, data)): lb-tablet, redutzu-mdt,
    -- piotreq_gpt and kartik-mdt take them directly, the others are relayed through one online player of the alerted jobs.
    dispatch = 'auto',
    -- Called when dispatch = 'custom' (client). data fields: see the header of modules/dispatch/client.lua.
    dispatchCustom = nil,
    -- Called when dispatch = 'custom' for an alert sent by the server (data.coords and data.street are set).
    dispatchCustomServer = nil,

    inventory = {
        -- 'auto' | 'ox' | 'qb' | 'qs' | 'codem' | 'tgiann'
        system = 'auto',
        -- Item image path overrides (%s = item image / name).
        imagePath = {
            -- ox = 'nui://ox_inventory/web/images/%s.png',
            -- qb = 'nui://qb-inventory/html/images/%s',
        },
    },
}

-- Task list (exports.worm_lib:showTaskList): top left of the screen.
Config.taskList = {
    -- Key that folds / unfolds the task rows under the title. Players can change it in
    -- Settings > Key Bindings; the badge under the list shows whichever key is bound. false: no key.
    keybind = {
        name = 'worm_tasklist',
        defaultKey = 'M',
        -- description = 'Task list', -- nil: locale 'toggle_task_list'
    },
}

-- Interaction ("aim at the indicator + press the key" system).
-- Completely separate from targeting (target / ox_target); works with its own exports:
-- exports.worm_lib:addInteractionBoxZone(...), addInteractionGlobalVehicle(...) etc. (see README.md)
Config.interaction = {
    enabled = true,

    -- Interaction key. Players can change it in Settings > Key Bindings,
    -- the UI shows whichever key is currently bound.
    keybind = {
        name = 'worm_interact',
        defaultKey = 'E',
        description = 'Interact',
    },

    -- Distance used when an option has no distance.
    defaultDistance = 7.0,

    -- How close the screen center dot must get to an indicator for it to count as "focused".
    -- Fraction of the screen height (0.08 = ~86px at 1080p).
    focusRadius = 0.08,

    -- Maximum number of indicators shown at once (the closest ones).
    maxIndicators = 8,

    -- Nearby entity/zone scan interval (ms). Lowering it calls canInteract more often.
    scanInterval = 200,

    -- Scan interval (ms) when nothing is nearby. Determines idle CPU usage.
    idleScanInterval = 500,

    -- Line of sight check for entities (nothing behind walls is shown).
    losCheck = true,

    -- Hide the options of the vehicle you are sitting in.
    ignoreCurrentVehicle = true,

    -- Hide during a progress bar (lib.progressBar).
    hideOnProgress = true,

    -- Default vehicle options (doors, hood, trunk open/close).
    defaults = true,

    -- Reach of the default vehicle options (metres). Large vehicles (box trucks like the Mule) get more,
    -- since their doors sit high and behind the bumper.
    vehicleDistance = 2.0,
    largeVehicleDistance = 2.65,
    -- A vehicle is large when its model is at least this tall or long (metres). Mule: 3.75 tall, 7.58 long.
    largeVehicleSize = { height = 3.0, length = 6.5 },

    -- qbx "personal menu" (clothing, citizen, vehicle, job/gang menus, getting into trunks).
    -- When enabled the ox_lib radial menu is disabled and the menu shows on every focused point.
    -- Menu contents: shared/interaction_menu.lua
    qbxMenu = false,

    -- Adds bones/offsets to options other resources registered through the interaction exports.
    -- Match: resource (+ optional kind: 'ped'|'vehicle'|'object'|'player'|'model'|'entity'|'localEntity'|'global', name, label)
    -- Applied fields: bones, boneFallback, bonesOptional, offset, absoluteOffset, distance
    optionOverrides = {
        -- Example: show a script's trunk option on the same indicator (plate) as the default trunk open/close.
        -- The position must match TRUNK_BONE / TRUNK_OFFSET in modules/interaction/defaults.lua.
        -- { resource = 'some-script', kind = 'vehicle', name = 'trunk', bones = 'platelight', offset = vec3(0.5, 0, 0.5) },
    },

    -- Show the screen center dot only while an interaction is nearby.
    centerDot = true,

    -- UI
    ui = {
        showIcons = false,    -- show the options' `icon` (FontAwesome) field
        accent = '#ffffff',   -- accent color (focused ring, key box)
        scale = 1.0,          -- overall UI scale (1080p based, scaled to the resolution automatically)
    },

    -- Texts
    locale = {
        goBack = 'Back',
    },
}

-- Job outfits (exports.worm_lib:applyOutfit / restoreOutfit). The ped's own components are always snapshotted and
-- put back exactly; the appearance resource is only asked to reload the rest of the skin (overlays, tattoos).
Config.outfit = {
    -- 'auto' (the first one running) | 'illenium-appearance' | 'fivem-appearance' | 'qb-clothing' | 'esx_skin' | 'none'
    system = 'auto',
}
