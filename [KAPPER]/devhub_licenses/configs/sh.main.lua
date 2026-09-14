if not Config then Config = {} end

Config.Debug = false -- Enable debug prints
Config.Dev = false -- Enable dev features like the terminal demo target, /testscreenshot command, these features are not meant for production use and may cause issues if enabled on a live server,

-- Internal self-test. When true, registers the /licenses_test command (in-game, admins only)
Config.InternalTest = false

-- When true (default), the resource creates its database tables automatically on first
Config.AutoInstallSql = true

-- When true (default), any export that fails also shows the affected player a Core.Notify
Config.NotifyOnExportFailure = true

-- License statuses: active, expired, revoked, lost, suspended
Config.RetakeableLicenseStatus = { -- List of license statuses that allow retaking the license
    ["expired"] = true,
    ["revoked" ] = true,
    ["lost"] = true,
}

-- License pickup locations (City Hall clerks).
-- Add as many entries as you like — each spawns its own ped, optional blip and target.
Config.LicensePickUp = {
    {
        coords = vec4(-545.2302, -203.6606, 38.2152, 208.0829),
        model = "a_m_y_business_03",
        -- licenses = { "driver_license", "id_card" }, -- optional whitelist; omit for all granted licenses
        enabled = true,
        blip = {
            sprite = 408, -- License/ID card icon
            color = 2, -- Green
            scale = 0.8,
            label = "License Pickup",
        },
    },
    -- Example second location (edit the coords/model and uncomment to enable):
    -- {
    --     coords = vec4(-1310.0, -390.0, 36.7, 75.0),
    --     model = "a_m_y_business_03",
    --     licenses = { "driver_license" }, -- this clerk only issues the driver license
    --     blip = {
    --         enabled = true,
    --         sprite = 408,
    --         color = 2,
    --         scale = 0.8,
    --         label = "License Pickup",
    --     },
    -- },
}

-- When enabled, licenses that have an exam configured are earned by passing a test at the License Pickup clerk
Config.LicenseExams = { enabled = true }

-- Self-service lost report
-- When enabled, the "I lost my license" option at the License Pickup clerk lets players mark their OWN active licenses as lost 
Config.SelfReportLostLicense = { enabled = true }

-- License Display Position Editor
Config.LicensePositionEditor = true -- Enable/disable the license position editor feature, When enabled, adds a 3rd option to open the position editor for the current license

Config.LicenseShowDistance = 10.0 -- Maximum distance to show license to nearby players

Config.LicenseShowCooldown = 5 -- Cooldown in seconds between showing licenses to prevent spam (0 to disable)

Config.UsePhysicalLicenses = false -- Use license as physical item (requires item metadata support in devhub_lib) setting this to true will disable virtual licenses (/licenses /favorites commands)
-- Used items are configured in license creator UI general settings

Config.MaxFavoriteLicenses = 5 -- Maximum number of favorite licenses a player can have (maximum 5)

-- Usage Configuration
-- Can be triggered via: chat command, usable item, or client event
-- Set any option to false to disable that trigger method
Config.Usage = {
    favorites = { -- Open favorite licenses hand
        command = "favorites",              -- Chat command name (false to disable)
        item    = "devhub_favlicenses",     -- Usable item name (false to disable)
        event   = "devhub_licenses:client:openFavorites", -- Event name (false to disable)
        keybind = false,                    -- Key to bind (e.g. "F6", "G", "COMMA") or false to disable. Uses RegisterKeyMapping - players can rebind in FiveM Settings > Key Bindings
    },
    licenses = { -- Open license holder / card holder
        command = "licenses",               -- Chat command name (false to disable)
        item    = "devhub_licenseholder",   -- Usable item name (false to disable)
        event   = "devhub_licenses:client:openLicenses",  -- Event name (false to disable)
        keybind = false,                    -- Key to bind (e.g. "F7", "H", "PERIOD") or false to disable. Uses RegisterKeyMapping - players can rebind in FiveM Settings > Key Bindings
    },
    licenseMdt = { -- Show license mdt
        command = "licenseMdt",                -- Chat command name (false to disable)
        item    = "devhub_licensesmdt",     -- Usable item name (false to disable)
        event   = "devhub_licenses:client:openMainMenu",   -- Event name (false to disable)
        keybind = false,                    -- Key to bind (e.g. "F8", "J", "SLASH") or false to disable. Uses RegisterKeyMapping - players can rebind in FiveM Settings > Key Bindings
    },
}

Config.PlayerTarget = { -- Target option on players to view their licenses
    enabled = true,                                             -- Enable/disable the player target
    icon = "fas fa-id-card",                                    -- Target icon
    label = "Check Licenses",                                   -- Target label text
    allowTakeLicense = true,                                    -- Allow players to steal/take licenses from other players card holders
    animation = {                                               -- Animation played when checking a player's licenses (mechanic search)
        dict = "mini@repair",                                   -- Animation dictionary
        anim = "fixing_a_ped",                                  -- Animation name
        blendIn = 8.0,                                          -- Blend in speed
        blendOut = 8.0,                                         -- Blend out speed
        duration = -1,                                          -- Duration (-1 = loop until stopped)
        flag = 1,                                               -- Animation flag (1 = loop)
    },
}

-- Issue-only menu
-- A separate, restricted menu that lets configured jobs ISSUE (or grant) a limited set of licenses 
--   exports['devhub_licenses']:openIssueMenu(targetServerId)   -- client export
--   TriggerEvent('devhub_licenses:client:openIssueMenu', targetServerId)
Config.IssueMenu = {
    enabled = true,

    allowGrant = true, -- "Grant"  -> permission only; the player then collects it at the City Hall pickup NPC
    allowIssue = true, -- "Issue"  -> grants AND creates the finished license

    jobs = {
        ["police"]   = { minGrade = 0 },
        ["mechanic"] = { minGrade = 2, templates = { "mechanic_license" } },
    },

    requireProximity = true,
    proximityDistance = 5.0,

    target = {
        enabled = true,
        icon = "fas fa-id-card",
        label = "Issue License", -- falls back to _T("issue_license_target") when nil
        distance = 2.5,
    },
}

Config.SuspensionCheckIntervalHours = 1 -- Interval in hours to check for suspended licenses
Config.ExpirationCheckIntervalHours = 1 -- Interval in hours to check for expired licenses

Config.UseLaptopApp = false -- Enable to use the license system as a laptop app (requires free devhub_laptop resource https://store.devhub.gg/product/7054272)

Config.LaptopApp = {
    label = "Id cards & Licenses",
    img = "https://upload.devhub.gg/dh_upload/laptop/appStore/apps/licenses.webp",
    path = "https://cfx-nui-devhub_licenses/html/index.html",
    category = "premium",
    rating = 5,
    description = "Id cards and licenses application for managing your licenses",
    longDescription = "A comprehensive platform where you can view, manage, and track your licenses with detailed information and status updates.",
    size = 52,
    downloads = 1000,
    fullScreen = true,
    reviews = {
        {
            user = "Tom",
            rating = 5,
            comment = "The license system is fantastic! It keeps everything organized and easy to manage.",
            date = "2025-08-14"
        },
        {
            user = "Sarah",
            rating = 4,
            comment = "I love the interface and how easy it is to check my licenses.",
            date = "2025-08-15"
        },
    }
}

Config.ItemShop = { -- Items available for purchase from the License Pickup NPC
    enabled = true, -- Master switch: false removes the "buy items" option from the pickup NPC and blocks purchases server-side
    paymentMethod = "both", -- "cash", "card" or "both"
    items = {
        { name = 'devhub_licenseholder', price = 500, max = 1 },
        { name = 'devhub_licensesmdt',    price = 750, max = 1 },
        { name = 'devhub_favlicenses',    price = 300, max = 1 },
    },
}

Config.UndergroundItemShop = { -- Items available for purchase from the Underground NPC (John)
    enabled = true, -- Master switch: false removes the "buy supplies" option from the underground NPC and blocks purchases server-side
    paymentMethod = "cash", -- "cash", "card" or "both"
    items = {
        { name = 'devhub_fakelicenses', price = 1500, max = 1 },
    },
}

Config.CreatorOnlyForAdmins = true -- If true, only admins can access the license creator, its using Core.IsPlayerAdmin from devhub_lib

Config.HideoutLocations = {
    {
        coords = vec4(393.3414, 3000.3530, 39.5347, 150.4899),
        spawnDistance = 200.0,
    },
}

Config.UndergroundNpc = {
    model = "s_m_y_ammucity_01",
    offset = vec3(11.2125, -3.5820, -8.1847), -- Offset from underground parent entity
    heading = 46.3, -- NPC heading (relative to underground parent heading)
}

Config.Papercutter = {
    offset = vec3(19.44, -1.4, -8.19), -- Offset from underground parent entity (between the two desks)
    heading = 235.0, -- Heading (relative to underground parent heading)
}

Config.Foiltipper = {
    offset = vec3(17.04, -5.10, -7.39), -- Offset from underground parent entity (left desk)
    heading = 235.0, -- Heading (relative to underground parent heading)
}

Config.Embosser = {
    offset = vec3(22.04, 2.00, -7.40), -- Offset from underground parent entity (right desk)
    heading = 235.0, -- Heading (relative to underground parent heading)
}

Config.FakeIdPhotos = {
    'https://upload.devhub.gg/dh_upload/licenses/fakeIdPhoto1.jpg',
    'https://upload.devhub.gg/dh_upload/licenses/fakeIdPhoto2.jpg',
    'https://upload.devhub.gg/dh_upload/licenses/fakeIdPhoto3.jpg',
    'https://upload.devhub.gg/dh_upload/licenses/fakeIdPhoto4.jpg',
    'https://upload.devhub.gg/dh_upload/licenses/fakeIdPhoto5.jpg',
    'https://upload.devhub.gg/dh_upload/licenses/fakeIdPhoto6.jpg',
    'https://upload.devhub.gg/dh_upload/licenses/fakeIdPhoto7.jpg',
    'https://upload.devhub.gg/dh_upload/licenses/fakeIdPhoto8.jpg',
}

Config.FakeIdMissionConfig = {
    deliveryLocations = {
        { coords = vec4(-683.3203, -172.8938, 36.8213, 295.9203) },
        { coords = vec4(-276.5885, 303.0736, 89.7183, 344.4300) },
        { coords = vec4(845.5369, -962.2592, 25.5211, 279.7717) },
        { coords = vec4(967.6248, -1828.8547, 30.2365, 352.4440) },
    },
    npcModel = { -- Random NPC model will be selected from this list
        "a_m_m_hillbilly_02",
        "a_m_o_soucent_02",
        "a_m_o_soucent_03",
        "a_m_o_tramp_01",
    },
    payMin = 500,
    payMax = 2000,
    blipSprite = 280,
    blipColor = 5,
    blipScale = 0.85,
}