PinkFrogConfig = {
    useFastHotkeys  = true,          -- default: true
    allIconsWhite   = true,          -- default: false  |  true = forces all SVG icons to white
    sharpBorders    = false,         -- default: false  |  true = removes border-radius from all components
    dialogOverlay   = false,          -- semi-transparent overlay behind dialogs

    -- Radial menu shape — 'circle' | 'flat' | 'hexagon'
    --   circle   donut sectors, the original wheel
    --   flat     rounded rectangular tiles laid out in a ring
    --   hexagon  hexagonal tiles in the same ring
    -- Colors always come from mainAccent / secondaryColor below, whatever the shape.
    radialStyle     = 'circle',

    -- Shape options shown in the /uiSettings select — edit labels freely
    radialStyleOptions = {
        { value = 'circle',  label = 'Circle' },
        { value = 'flat',    label = 'Flat' },
        { value = 'hexagon', label = 'Hexagon' },
    },

    -- Accent color — drives every highlighted element (buttons, icons, hotkeys, glow)
    mainAccent     = '#e3b536',

    -- Base color of card / panel backgrounds — every other surface shade is derived from it by the UI
    secondaryColor = '#111217',

    -- Notification sound (notification-1 … notification-10)
    notifSound        = 'notification-10',
    notifSoundVolume  = 10,           -- 0–100

    -- Sound options shown in the /uiSettings select — edit labels freely
    notifSoundOptions = {
        { value = 'notification-1',  label = 'Sound 1' },
        { value = 'notification-2',  label = 'Sound 2' },
        { value = 'notification-3',  label = 'Sound 3' },
        { value = 'notification-4',  label = 'Sound 4' },
        { value = 'notification-5',  label = 'Sound 5' },
        { value = 'notification-6',  label = 'Sound 6' },
        { value = 'notification-7',  label = 'Sound 7' },
        { value = 'notification-8',  label = 'Sound 8' },
        { value = 'notification-9',  label = 'Sound 9' },
        { value = 'notification-10', label = 'Sound 10' },
    },

    -- Skill check UI labels
    labelSkillCheckTitle   = 'Skill Check',
    labelSkillCheckSurvive = 'SURVIVE',

    -- Shown at the bottom of every panel (context menu, list menu, ...) as a
    -- quiet shining line. Put your server name here; empty string hides it.
    serverName = 'Your Server Name',

    uiSettingsCommand = 'uiSettings',  -- command name to open the settings menu

    -- ─────────────────────────────────────────────────────────────────────────
    -- Admin preset — paste the output of "Export Settings" here.
    -- New players (or after Reset) will start with these values instead of the
    -- raw defaults above.  Leave as nil to use the raw defaults.
    -- ─────────────────────────────────────────────────────────────────────────
    defaultSettings = nil,
    

    -- /uiSettings locales
    Locales = {
        menuTitle    = 'UI Settings',
        forYou       = 'Change Settings For You',
        forYouDesc   = 'Saved locally on your machine',
        export       = 'Export Settings',
        exportDesc   = 'Copy current settings to clipboard',
        dialogTitle  = 'UI Settings',

        -- Notification sound preview (shown when changing the notification sound)
        notifTitle   = 'Notification Preview',
        notifDesc    = 'This is how your notifications will look',

        -- Default notification titles per type (used when no title is passed)
        notifTitleInfo    = 'Info',
        notifTitleSuccess = 'Success',
        notifTitleWarning = 'Warning',
        notifTitleError   = 'Error',

        lblFastHotkeys     = 'Fast Hotkeys',
        lblAllIconsWhite   = 'All Icons White',
        lblSharpBorders    = 'Sharp Borders',
        lblDialogOverlay   = 'Dialog Overlay',
        lblRadialStyle     = 'Radial Menu Style',
        lblNotifSound      = 'Notification Sound',
        lblNotifVolume     = 'Notification Volume',
        lblMainAccent      = 'Main Accent Color',
        lblSecondaryColor  = 'Secondary Color',

        reset      = 'Reset to Defaults',
        resetDesc  = 'Clear your personal settings',
    },
}
