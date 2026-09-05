function scriptCheck(data)
    for k, v in pairs(data) do
        if GetResourceState(k):find('started') ~= nil then
            return v
        end
    end
    return false
end

-- ------------------------------------------------------------------------------
-- OP Clothing - Main Configuration
-- Shops: /clothingadmin | Templates: ShopTemplates.lua | Categories / Pricing / Tattoos: own files
-- ------------------------------------------------------------------------------

Config = {}

-- ------------------------------------------------------------------------------
-- Locale & Debug
-- ------------------------------------------------------------------------------
Config.Locale = 'en' -- en, pl, cs, de, el, lt, sk (locales/*.json)
Config.Debug  = false

-- ------------------------------------------------------------------------------
-- Framework
-- ------------------------------------------------------------------------------
Config.Framework = 'qbox' -- 'auto' | 'esx' | 'qb' | 'qbox'

-- ------------------------------------------------------------------------------
-- Admin permissions
-- ------------------------------------------------------------------------------
Config.Permissions = {
    AcePermission = 'op_clothing.admin',
    AllowedGroups = { 'admin', 'superadmin', 'god' },
}

-- ------------------------------------------------------------------------------
-- Legacy compatibility (illenium / skinchanger / qb-clothing / rcore)
-- ------------------------------------------------------------------------------
Config.Compat = {
    Enabled           = true,
    SkinchangerEvents = true,
    IlleniumExports   = true,
    LegacyProvides    = true,   -- disable original clothing resources in server.cfg
    QbClothingEvents  = true,
    RcoreEvents       = true,
    NormalizeOnLoad   = false,  -- convert legacy DB skins on load
    -- true = another resource applies skin on spawn (e.g. multichar); shops still save normally
    ExternalAppearanceManager = false,
}

-- ------------------------------------------------------------------------------
-- Job lockers
-- Locations: /clothingadmin -> Lockers
-- ------------------------------------------------------------------------------
Config.JobLockers = {
    Enabled             = true,
    AllowPrivateOutfits = true,  -- show personal outfits in locker
    DefaultManageGrade  = 3,     -- min grade to edit locker outfits
    BlipPresets = {
        { label = 'Midnight Police',   sprite = 60,  color = 29 },
        { label = 'MHS',      sprite = 61,  color = 1 },
        { label = 'Mechanic', sprite = 446, color = 5 },
    },
}

-- ------------------------------------------------------------------------------
-- Database
-- ------------------------------------------------------------------------------
Config.Database = {
    OutfitsTable              = 'op_clothing_outfits',
    CustomPedPermissionsTable = 'ped_permissions',
    JobOutfitsTable           = 'op_clothing_job_outfits',
    ESX = {
        Table      = 'users',
        IdColumn   = 'identifier',
        SkinColumn = 'skin',
    },
    QB = {
        Table        = 'playerskins',
        IdColumn     = 'citizenid',
        SkinColumn   = 'skin',
        ModelColumn  = 'model',
        ActiveColumn = 'active',
    },
}

-- ------------------------------------------------------------------------------
-- Notifications
-- ------------------------------------------------------------------------------
local notifyScripts = {
    ['op-hud']        = 'op_hud',
    ['okokNotify']    = 'okokNotify',
    ['vms_notify']    = 'vms_notify',
    ['ox_lib']        = 'ox_lib',
    ['brutal_notify'] = 'brutal_notify',
}

Config.Notify = {
    Provider = scriptCheck(notifyScripts) or 'ox_lib',
    Duration = 5, -- seconds
}

-- ------------------------------------------------------------------------------
-- Target / Interaction
-- ------------------------------------------------------------------------------
local targets = {
    ['ox_target'] = 'ox-target',
    ['qb-target'] = 'qb-target',
}

Config.Target = {
    AccessMethod      = scriptCheck(targets) or 'auto', -- 'auto' | 'ox-target' | 'qb-target' | 'none'
    InteractionRadius = 2.0,   -- default open radius
    ZoneHeight        = 3.5,   -- ox_target box height
    OptionDistance    = 3.0,   -- max target distance
    DrawSprite        = false, -- ox_target zone sprite
    DrawMarker        = true,  -- 3D ground marker (false = hide, [E] still works in marker mode)
    -- Optional: small point zone instead of fitting-room sized target
    PointTarget       = false,
    PointRadius       = 0.55,
    -- Optional: seconds after click before NUI opens (0 = instant)
    OpenDelay         = 0,
    Marker = {
        type  = 27,
        color = { r = 120, g = 90, b = 255, a = 120 },
        scale = vec3(1.4, 1.4, 0.5),
        z     = -0.95, -- height offset of the ring
    },
}

-- ------------------------------------------------------------------------------
-- Preview (camera / ped while menu is open)
-- ------------------------------------------------------------------------------
Config.Preview = {
    RotateSpeed         = 1.0,
    AllowRotate         = true,
    FreezePlayer        = true,
    DisableInVehicle    = true,
    DefaultViewDistance = 1.2,  -- metres from ped
    ZoomMin             = 0.35,
    ZoomMax             = 5.5,
    ZoomStep            = 0.1,
    PanStep             = 0.006, -- right-click vertical pan
    PanLimits = {
        full   = { min = -1.50, max = 0.35 },
        upper  = { min = -0.80, max = 0.25 },
        lower  = { min = -1.10, max = 0.20 },
        head   = { min = -0.55, max = 0.12 },
        feet   = { min = -0.55, max = 0.45 },
        tattoo = {
            full   = { min = -1.05, max = 0.95 },
            upper  = { min = -0.75, max = 0.70 },
            lower  = { min = -0.90, max = 0.60 },
            head   = { min = -0.40, max = 0.45 },
            feet   = { min = -0.65, max = 0.75 },
        },
    },
    ScreenOffsetFactor = 1.0,
    DefaultCenterX     = 0.65,
}

-- ------------------------------------------------------------------------------
-- Skin preview
-- Underwear outfit while editing tattoos / creator / surgeon (preview only)
-- ------------------------------------------------------------------------------
Config.SkinPreview = {
    Enabled    = true,
    Modes      = { tattoo = true, character = true, surgeon = true },
    ClearProps = true,
    male = {
        [1]  = 0,   -- mask
        [3]  = 15,  -- arms
        [4]  = 21,  -- legs
        [5]  = 0,   -- bag
        [6]  = 34,  -- shoes
        [7]  = 0,   -- accessory
        [8]  = 15,  -- undershirt
        [9]  = 0,   -- armor
        [10] = 0,   -- decals
        [11] = 15,  -- top
    },
    female = {
        [1]  = 0,
        [3]  = 15,
        [4]  = 15,
        [5]  = 0,
        [6]  = 35,
        [7]  = 0,
        [8]  = 14,
        [9]  = 0,
        [10] = 0,
        [11] = 15,
    },
}

-- ------------------------------------------------------------------------------
-- Thumbnails
-- ------------------------------------------------------------------------------
Config.Thumbnails = {
    Enabled = true,
    -- 'thumbnails' = image grid | 'slider' = no images
    UiMode = 'thumbnails',

    StoreResource = 'op-clothing',
    StorePath     = 'thumbnails',

    BaseUrl      = 'https://data.otherplanet.dev/clothing/%s.png', -- CDN default
    LocalBaseUrl = 'nui://op-clothing/thumbnails/%s.png',          -- local captures

    Cdn = {
        Enabled     = true,
        BaseUrl     = 'https://data.otherplanet.dev/clothing/',
        HashMapUrl  = 'https://data.otherplanet.dev/clothing/hashmap.json',
        ColorsUrl   = 'https://data.otherplanet.dev/clothing/colors.json',
        SyncOnStart = true,
    },
    SkipCdnCapture        = true,  -- skip items already on CDN during batch
    AutoHashMapAfterBatch = true,  -- build hash map after /op_clothing_thumbs

    OutputMaxSize  = 256, -- max PNG edge (px)
    PngCompression = 9,   -- zlib level 0-9

    -- Capture backend: start ONE of these before op-clothing
    -- 'screencapture' (Node 22) | 'screenshot-basic'
    Screenshot = {
        Backend    = 'screencapture',
        Resource   = nil, -- nil = same as Backend
        MaxWidth   = 640,
        MaxHeight  = 640,
    },

    Stage = {
        coords   = vec4(-1400.0, -3000.0, 650.0, 180.0),
        rotation = vec3(0.0, 0.0, 180.0),
    },
    BackdropSize = 32.0,

    CameraDefault = { fov = 42.0, distance = 1.40, zPos = 0.40 },
    HairColor     = 8, -- default hair colour for hair thumbnails

    ColorBuckets = {
        { id = 'black',  r = 26,  g = 26,  b = 26  },
        { id = 'white',  r = 245, g = 245, b = 245 },
        { id = 'gray',   r = 138, g = 138, b = 138 },
        { id = 'brown',  r = 92,  g = 64,  b = 51  },
        { id = 'beige',  r = 201, g = 184, b = 150 },
        { id = 'red',    r = 198, g = 40,  b = 40  },
        { id = 'blue',   r = 21,  g = 101, b = 192 },
        { id = 'green',  r = 46,  g = 125, b = 50  },
        { id = 'yellow', r = 249, g = 168, b = 37  },
        { id = 'purple', r = 123, g = 31,  b = 162 },
    },

    CameraSlots = {
        ['component:1']  = { fov = 28.0, distance = 1.05, zPos = 0.68 },
        ['component:2']  = { fov = 30.0, distance = 1.05, zPos = 0.66 },
        ['component:3']  = { fov = 40.0, distance = 1.30, zPos = 0.10 },
        ['component:4']  = { fov = 42.0, distance = 1.40, zPos = -0.45 },
        ['component:5']  = { fov = 45.0, distance = 1.50, zPos = 0.30, headingOffset = 180.0 },
        ['component:6']  = { fov = 34.0, distance = 1.00, zPos = -0.80 },
        ['component:7']  = { fov = 38.0, distance = 1.20, zPos = 0.58 },
        ['component:8']  = { fov = 40.0, distance = 1.30, zPos = 0.30 },
        ['component:9']  = { fov = 42.0, distance = 1.30, zPos = 0.30 },
        ['component:10'] = { fov = 42.0, distance = 1.30, zPos = 0.30 },
        ['component:11'] = { fov = 45.0, distance = 1.45, zPos = 0.30 },
        ['prop:0']       = { fov = 26.0, distance = 1.05, zPos = 0.78 },
        ['prop:1']       = { fov = 22.0, distance = 0.70, zPos = 0.74 },
        ['prop:2']       = { fov = 22.0, distance = 0.70, zPos = 0.74 },
        ['prop:6']       = { fov = 24.0, distance = 0.50, bone = 57005, headingOffset = -90.0 },
        ['prop:7']       = { fov = 24.0, distance = 0.50, bone = 18905 },
    },

    KeyHard           = 64,  -- chroma-key hard threshold
    KeySoft           = 36,  -- chroma-key soft threshold
    Background        = { r = 0, g = 255, b = 0 },
    CaptureDelay      = 150,  -- ms after item load
    ScreenshotDelay   = 750,  -- ms before capture
    UploadCooldown     = 200,  -- ms between shots
    CaptureTimeout    = 20000, -- ms before skipping a hung shot
    LoadTimeout       = 12000, -- ms wait for drawable stream
    CaptureRetries    = 2,
    Command           = 'op_clothing_thumbs',
}

-- ------------------------------------------------------------------------------
-- Character Creator
-- ------------------------------------------------------------------------------
Config.CharacterCreator = {
    DefaultModel     = 'mp_m_freemode_01',
    AllowModelChange = true,
    AllowCancel      = true,
    IncludeClothing  = true,
    IncludeTattoos   = true,
    Command          = 'charmenu', -- admin only; nil = disabled
    ResetOnOpen      = false,  -- wipe to default when OpenCharacterCreator has no opts.reset (first creation / multichar)
    CharmenuKeepAppearance = true, -- /charmenu keeps the player's current look instead of wiping to default
    -- Max mother/father / skin parent index (slider 0..ParentMax). Vanilla freemode = 45.
    -- Raise for custom face packs
    ParentMax        = 45,
}

-- ------------------------------------------------------------------------------
-- Clothing Admin
-- ------------------------------------------------------------------------------
Config.ClothingAdmin = {
    Command = 'clothingadmin',
}

-- ------------------------------------------------------------------------------
-- Reload Skin
-- ------------------------------------------------------------------------------
Config.ReloadSkin = {
    Enabled = true,
    Command = 'reloadskin',
}

-- ------------------------------------------------------------------------------
-- Surgeon — also placeable as a shop type (template: surgeon) via /clothingadmin
-- ------------------------------------------------------------------------------
Config.Surgeon = {
    Enabled = true,
    Command = 'surgeon', -- /surgeon [serverId] — admin shortcut, free session
}

-- ------------------------------------------------------------------------------
-- Shop restrictions
-- ------------------------------------------------------------------------------
Config.RestrictionsEnabled = false -- enforce shop job/gang restrictions

-- ------------------------------------------------------------------------------
-- Shop Admin
-- ------------------------------------------------------------------------------
Config.ShopAdmin = {
    BlipPresets = {
        { label = 'Clothing (Binco)',   sprite = 73,  color = 47 },
        { label = 'Clothing (Premium)', sprite = 73,  color = 4  },
        { label = 'Mask Shop',          sprite = 362, color = 0  },
        { label = 'Barber',             sprite = 71,  color = 25 },
        { label = 'Tattoo',             sprite = 75,  color = 1  },
        { label = 'Plastic Surgery',    sprite = 153, color = 4  },
    },
}
