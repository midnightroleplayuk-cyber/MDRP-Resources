Config = {}

Config.Framework = 'qb' -- esx/qb
Config.NotificationType = 'ox' -- esx/qb/mythic
Config.Locale = 'en' -- en/fi
Config.DebugMode = false -- false / true

Config.Inventory = 'ox' -- default/ox
Config.License = 'qb' -- default/esx/qb
Config.Phone = 'default' -- default/lb/qs/gks/gks2/high/yseries -- you can add your own in server/main_editable.lua
Config.Housing = '' -- tk/tk_v2/ps/loaf/qb/qbx/qs/cylex/nolag/bcs/vms/rx -- you can add your own in server/main_editable.lua
Config.Dispatch = '' -- tk/cd/qs/ps/core/rcore/loverp -- see server/main_editable.lua for examples on how to add your own
Config.Jail = '' -- tk/pickle/rcore -- see client/main_editable.lua for examples on how to add your own
Config.UseOxLib = false -- false / true, remember to add " shared_script '@ox_lib/init.lua' " to fxmanifest.lua if set to true
Config.UseOxTarget = false -- false / true
Config.BPS = 500000 -- affects how fast data is sent from server to client when opening MDT for first time, if server lags or player crashes when opening, try lowering this value

Config.UISettings = {
    color = 'blue', -- https://v6.mantine.dev/theming/colors/
    shade = 6, -- 1-9, 1 being the lightest and 9 being the darkest
    scheme = 'dark', -- light/dark
}

Config.TabletAnim = {
    dict = 'amb@world_human_seat_wall_tablet@female@idle_a',
    name = 'idle_c',
    model = `prop_cs_tablet`,
    bone = 60309,
    pos = vec3(0.0, 0.0, -0.04),
    rot = vec3(0.0, 0.0, 0.0),
}

Config.MDTNotifications = true -- true / false, enable or disable MDT notifications
Config.ShowProfileIdentifiers = true -- true / false, show or hide identifiers in profiles
Config.ShowAddLicenseButton = true -- true / false, show or hide add license button in profiles
Config.ShowRemoveLicenseButton = true -- true / false, show or hide remove license button in profiles
Config.EnableIncidentExporting = false -- false / true, enable or disable exporting incidents
Config.NeedItemCommand = false -- true / false, should player need the item to use the command
Config.UseProfileImagesForEmployeePage = false -- true / false, use profile images for employee page

Config.PoliceReportLocations = { -- coords for police report remove if you dont want to use
    {coords = vec4(441.1595, -978.8431, 30.6896, 178.8787), dist = 5.0, ped = `s_f_y_cop_01`, scenario = 'WORLD_HUMAN_COP_IDLES', page = 'police'},
}

Config.MDTs = {
    police = {
        label = 'Police',
        --image = '',
        color = 'blue',
        shade = 6,
        jobs = {
            police = 0,
            leo = 0,
            sheriff = 0,
        },
        items = {'pol_mdt'},
        command = 'polmdt',
        locations = {
            {coords = vec4(449.33, -984.9, 30.69, 90.0), dist = 3.0, ped = `s_f_y_cop_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
        },
        statuses = {'Active', 'Inactive'}, -- for employee page
        licenses = {'Motorcycle', 'Helicopter', 'Investigation'}, -- for employee page
        templates = { -- default text that will be used in reports, you can use html tags like <br>, <b>, etc., for example: 'First officer on scene: <br>Location:  <br>Details: '
            incident = '',
            report = '',
            trainingReport = '',
            -- you can also specify templates for report types, for example:
            -- arrest = '',
            -- crime_scene = '',
            -- traffic_incident = '',
            -- investigation = '',
        },
        reportTypes = {
            --[[ arrest = { -- report name, remember to add to locales
                detective = 0, -- you can add additional jobs that can this report ("shared reports"), job name and minimum grade
            },
            crime_scene = {
                detective = 0,
            },
            traffic_incident = {
                detective = 0,
                ambulance = 0,
            },
            investigation = {
                detective = 0,
            }, ]]
        },
        pages = {
            {
                name = 'home',
                icon = 'IconHome', -- tabler react icon name, see https://tabler-icons.io/ for all icons
                components = {
                    chat = { -- default permissions
                        read = {
                            police = 0, -- job name, minimum grade
                        },
                        write = {
                            police = 0,
                        },
                        delete = {
                            police = 0,
                        },
                    },
                    announcements = {
                        read = {
                            police = 0,
                        },
                        write = {
                            police = 0,
                        },
                        delete = {
                            police = 0,
                        },
                    },
                    warrants = {
                        read = {
                            police = 0,
                        },
                        write = {
                            police = 0,
                        },
                        delete = {
                            police = 0,
                        },
                    },
                    bolos = {
                        read = {
                            police = 0,
                        },
                        write = {
                            police = 0,
                        },
                        delete = {
                            police = 0,
                        },
                    },
                },
            },
            {
                name = 'profiles',
                icon = 'IconUser',
                sidebar = {
                    'warrants',
                    'tags',
                    'vehicles',
                    'licenses',
                    'properties',
                    'jobs',
                    'weapons',
                    'charges',
                    'linkedIncidents',
                    'linkedReports',
                    'linkedProfiles',
                    'photos',
                },
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 0,
                    },
                },
            },
            {
                name = 'vehicles',
                icon = 'IconCar',
                sidebar = {
                    'bolos',
                    'tags',
                    'linkedIncidents',
                    'linkedReports',
                    'photos',
                },
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 0,
                    },
                },
            },
            {
                name = 'properties',
                icon = 'IconHome',
                sidebar = {
                    'tags',
                    'linkedProfiles',
                    'photos',
                },
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 0,
                    },
                },
            },
            {
                name = 'businesses',
                icon = 'IconBuilding',
                sidebar = {
                    'tags',
                    'employees',
                    'photos',
                },
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 0,
                    },
                },
            },
            {
                name = 'incidents',
                icon = 'IconAlertTriangle',
                sidebar = {
                    'tags',
                    'employees',
                    'criminals',
                    'civilians',
                    'vehicles',
                    'weapons',
                    'evidence',
                    'linkedIncidents',
                    'linkedReports',
                    'linkedPoliceReports',
                    'photos',
                },
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 0,
                    },
                    delete = {
                        police = 0,
                    },
                },
            },
            {
                name = 'reports',
                icon = 'IconNotebook',
                sidebar = {
                    'tags',
                    'employees',
                    'suspects',
                    'civilians',
                    'vehicles',
                    'weapons',
                    'evidence',
                    'linkedIncidents',
                    'linkedReports',
                    'linkedPoliceReports',
                    'photos',
                },
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 0,
                    },
                    delete = {
                        police = 0,
                    },
                },
            },
            {
                name = 'trainingReports',
                icon = 'IconReportAnalytics',
                sidebar = {
                    'reports',
                    'driving',
                    'professionalism',
                    'radio',
                    'generalKnowledge',
                    'shooting',
                },
                permissions = {
                    read = {
                        police = 1,
                    },
                    write = {
                        police = 1,
                    },
                    delete = {
                        police = 1,
                    },
                },
            },
            {
                name = 'policeReports',
                icon = 'IconMessageReport',
                sidebar = {
                    'tags',
                    'linkedIncidents',
                    'linkedReports',
                },
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 0,
                    },
                    delete = {
                        police = 5,
                    },
                },
            },
            {
                name = 'evidence',
                icon = 'IconZoomExclamation',
                sidebar = {
                    'tags',
                    'linkedIncidents',
                    'linkedReports',
                },
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 0,
                    },
                    delete = {
                        police = 0,
                    },
                },
            },
            {
                name = 'weapons',
                icon = 'IconMicroscope',
                sidebar = {
                    'tags',
                    'owners',
                    'linkedIncidents',
                    'linkedReports',
                },
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 0,
                    },
                    delete = {
                        police = 0,
                    },
                },
            },
            {
                name = 'map',
                icon = 'IconMap',
                components = {
                    map = {
                        read = {
                            police = 0,
                        },
                    },
                    activeUnits = {
                        read = {
                            police = 0,
                        },
                    },
                    calls = {
                        read = {
                            police = 0,
                        },
                    },
                },
            },
            {
                name = 'charges',
                icon = 'IconFileInvoice',
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 0,
                    },
                    delete = {
                        police = 0,
                    },
                },
            },
            {
                name = 'legislation',
                icon = 'IconGavel',
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 0,
                    },
                    delete = {
                        police = 0,
                    },
                },
            },
            {
                name = 'employees',
                icon = 'IconUsers',
                licenses = {
                    'Motorcycle',
                    'Helicopter',
                    'Investigation',
                },
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 3,
                    },
                },
            },
            {
                name = 'tags',
                icon = 'IconTag',
                permissions = {
                    read = {
                        police = 0,
                    },
                    write = {
                        police = 0,
                    },
                    delete = {
                        police = 5,
                    },
                },
            },
            {
                name = 'permissions',
                icon = 'IconShieldCheck',
                permissions = {
                    read = {
                        police = 3,
                    },
                    write = {
                        police = 3,
                    },
                    delete = {
                        police = 3,
                    },
                },
            },
            {
                name = 'logs',
                icon = 'IconFileText',
            },
            {
                name = 'settings',
                icon = 'IconSettings',
            },
            --[[ {
                name = 'senate',
                label = 'Senate Legislation',
                icon = 'IconGavel',
                iframeUrl = 'https://governement.de/',
            }, ]]
            --[[ { -- Requires tk_cctv
                name = 'cctv',
                label = 'CCTV',
                icon = 'IconCamera',
                onClick = function()
                    exports.tk_mdt:closeUI()
                    exports.tk_cctv:openCameraTablet()
                end,
            }, ]]
            --[[ { -- Requires tk_jail
                name = 'jailMDT',
                label = 'Jail MDT',
                icon = 'IconPrison',
                onClick = function()
                    TriggerEvent('tk_jail:useTablet')
                end,
            }, ]]
            --[[ { -- Requires tk_dispatch
                name = 'dispatch',
                label = 'Dispatch',
                icon = 'IconBellRinging',
                onClick = function()
                    exports.tk_dispatch:toggleUI('map')
                end,
            }, ]]
        },
    },
    ambulance = {
        label = 'Ambulance',
        --image = '',
        color = 'red',
        shade = 6,
        jobs = {
            ambulance = 0
        },
        items = {'ems_mdt'},
        command = 'emsmdt',
        statuses = {'Active', 'Inactive'}, -- for employee page
        pages = {
            {
                name = 'home',
                icon = 'IconHome', -- tabler react icon name, see https://tabler-icons.io/ for all icons
                components = {
                    chat = { -- default permissions
                        read = {
                            ambulance = 0, -- job name, minimum grade
                        },
                        write = {
                            ambulance = 0,
                        },
                        delete = {
                            ambulance = 0,
                        },
                    },
                    announcements = {
                        read = {
                            ambulance = 0,
                        },
                        write = {
                            ambulance = 0,
                        },
                        delete = {
                            ambulance = 0,
                        },
                    },
                },
            },
            {
                name = 'profiles',
                icon = 'IconUser',
                sidebar = {
                    'tags',
                    'linkedIncidents',
                    'linkedReports',
                    'linkedProfiles',
                    'photos',
                },
                permissions = {
                    read = {
                        ambulance = 0,
                    },
                    write = {
                        ambulance = 0,
                    },
                },
            },
            {
                name = 'reports',
                icon = 'IconNotebook',
                sidebar = {
                    'tags',
                    'employees',
                    'civilians',
                    'evidence',
                    'linkedIncidents',
                    'linkedReports',
                    'linkedambulanceReports',
                    'photos',
                },
                permissions = {
                    read = {
                        ambulance = 0,
                    },
                    write = {
                        ambulance = 0,
                    },
                    delete = {
                        ambulance = 0,
                    },
                },
            },
            {
                name = 'trainingReports',
                icon = 'IconReportAnalytics',
                sidebar = {
                    'reports',
                    'driving',
                    'professionalism',
                    'radio',
                    'generalKnowledge',
                },
                permissions = {
                    read = {
                        ambulance = 1,
                    },
                    write = {
                        ambulance = 1,
                    },
                    delete = {
                        ambulance = 1,
                    },
                },
            },
            {
                name = 'evidence',
                icon = 'IconZoomExclamation',
                sidebar = {
                    'tags',
                    'linkedIncidents',
                    'linkedReports',
                },
                permissions = {
                    read = {
                        ambulance = 0,
                    },
                    write = {
                        ambulance = 0,
                    },
                    delete = {
                        ambulance = 0,
                    },
                },
            },
            {
                name = 'map',
                icon = 'IconMap',
                components = {
                    map = {
                        read = {
                            ambulance = 0,
                        },
                    },
                    activeUnits = {
                        read = {
                            ambulance = 0,
                        },
                    },
                    calls = {
                        read = {
                            ambulance = 0,
                        },
                    },
                },
            },
            {
                name = 'employees',
                icon = 'IconUsers',
                permissions = {
                    read = {
                        ambulance = 0,
                    },
                    write = {
                        ambulance = 3,
                    },
                },
            },
            {
                name = 'tags',
                icon = 'IconTag',
                permissions = {
                    read = {
                        ambulance = 0,
                    },
                    write = {
                        ambulance = 0,
                    },
                    delete = {
                        ambulance = 0,
                    },
                },
            },
            {
                name = 'permissions',
                icon = 'IconShieldCheck',
                permissions = {
                    read = {
                        ambulance = 3,
                    },
                    write = {
                        ambulance = 3,
                    },
                    delete = {
                        ambulance = 3,
                    },
                },
            },
            {
                name = 'logs',
                icon = 'IconFileText',
            },
            {
                name = 'settings',
                icon = 'IconSettings',
            }
        },
    },
    --[[ citizen = {
        label = 'Citizen',
        color = 'indigo',
        shade = 6,
        locations = {
            {coords = vec4(438.5239, -987.7390, 30.6896, 6.9378), dist = 3.0, ped = `s_f_y_cop_01`, scenario = 'WORLD_HUMAN_COP_IDLES'},
        },
        pages = {
            {
                name = 'profiles',
                icon = 'IconUser',
                sidebar = {
                    'warrants',
                    'licenses',
                    'properties',
                    'jobs',
                    'charges',
                },
                dataPage = 'police', -- will get data from police MDT
                permissions = {
                    write = {
                        none = 99,
                    },
                    delete = {
                        none = 99,
                    },
                },
            },
            {
                name = 'charges',
                icon = 'IconFileInvoice',
                dataPage = 'police',
                permissions = {
                    write = {
                        none = 99,
                    },
                    delete = {
                        none = 99,
                    },
                },
            },
            {
                name = 'legislation',
                icon = 'IconGavel',
                dataPage = 'police',
                permissions = {
                    write = {
                        none = 99,
                    },
                    delete = {
                        none = 99,
                    },
                },
            },
        },
    }, ]]
}

Config.ExcludedBusinesses = {'unemployed'}
Config.DateFormat = {year = 'numeric', month = '2-digit', day = '2-digit', hour = '2-digit', minute = '2-digit' } -- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/toLocaleString#options
Config.DateLocale = 'en-GB'
Config.Licenses = { -- edit this if Config.License is set to 'esx' or 'qb', the license names (weapon, driver, etc.) need to match your framework license names (labels can be anything)
    weapon = 'Weapon license',
    driver = 'Driver\'s license',
    fishing = 'Fishing license',
    hunting = 'Hunting license',
}

Config.WarrantDuration = 30 -- days
Config.BOLODuration = 7 -- days
Config.LicensePointsDuration = 7 -- days (remove if you dont want to use)
Config.LogDuration = 7 -- logs will be removed after this time (in days) (I recommend keeping this quite low as there can be a lot of logs)

Config.Controls = { -- https://docs.fivem.net/docs/game-references/controls/
    interact = 38,
    takePhoto = 38,
    cancelPhoto = 177,
}

Config.Colors = {
    [0] = "Metallic Black",
    [1] = "Metallic Graphite Black",
    [2] = "Metallic Black Steel",
    [3] = "Metallic Dark Silver",
    [4] = "Metallic Silver",
    [5] = "Metallic Blue Silver",
    [6] = "Metallic Steel Gray",
    [7] = "Metallic Shadow Silver",
    [8] = "Metallic Stone Silver",
    [9] = "Metallic Midnight Silver",
    [10] = "Metallic Gun Metal",
    [11] = "Metallic Anthracite Grey",
    [12] = "Matte Black",
    [13] = "Matte Gray",
    [14] = "Matte Light Grey",
    [15] = "Util Black",
    [16] = "Util Black Poly",
    [17] = "Util Dark silver",
    [18] = "Util Silver",
    [19] = "Util Gun Metal",
    [20] = "Util Shadow Silver",
    [21] = "Worn Black",
    [22] = "Worn Graphite",
    [23] = "Worn Silver Grey",
    [24] = "Worn Silver",
    [25] = "Worn Blue Silver",
    [26] = "Worn Shadow Silver",
    [27] = "Metallic Red",
    [28] = "Metallic Torino Red",
    [29] = "Metallic Formula Red",
    [30] = "Metallic Blaze Red",
    [31] = "Metallic Graceful Red",
    [32] = "Metallic Garnet Red",
    [33] = "Metallic Desert Red",
    [34] = "Metallic Cabernet Red",
    [35] = "Metallic Candy Red",
    [36] = "Metallic Sunrise Orange",
    [37] = "Metallic Classic Gold",
    [38] = "Metallic Orange",
    [39] = "Matte Red",
    [40] = "Matte Dark Red",
    [41] = "Matte Orange",
    [42] = "Matte Yellow",
    [43] = "Util Red",
    [44] = "Util Bright Red",
    [45] = "Util Garnet Red",
    [46] = "Worn Red",
    [47] = "Worn Golden Red",
    [48] = "Worn Dark Red",
    [49] = "Metallic Dark Green",
    [50] = "Metallic Racing Green",
    [51] = "Metallic Sea Green",
    [52] = "Metallic Olive Green",
    [53] = "Metallic Green",
    [54] = "Metallic Gasoline Blue Green",
    [55] = "Matte Lime Green",
    [56] = "Util Dark Green",
    [57] = "Util Green",
    [58] = "Worn Dark Green",
    [59] = "Worn Green",
    [60] = "Worn Sea Wash",
    [61] = "Metallic Midnight Blue",
    [62] = "Metallic Dark Blue",
    [63] = "Metallic Saxony Blue",
    [64] = "Metallic Blue",
    [65] = "Metallic Mariner Blue",
    [66] = "Metallic Harbor Blue",
    [67] = "Metallic Diamond Blue",
    [68] = "Metallic Surf Blue",
    [69] = "Metallic Nautical Blue",
    [70] = "Metallic Bright Blue",
    [71] = "Metallic Purple Blue",
    [72] = "Metallic Spinnaker Blue",
    [73] = "Metallic Ultra Blue",
    [74] = "Metallic Bright Blue",
    [75] = "Util Dark Blue",
    [76] = "Util Midnight Blue",
    [77] = "Util Blue",
    [78] = "Util Sea Foam Blue",
    [79] = "Util Lightning blue",
    [80] = "Util Maui Blue Poly",
    [81] = "Util Bright Blue",
    [82] = "Matte Dark Blue",
    [83] = "Matte Blue",
    [84] = "Matte Midnight Blue",
    [85] = "Worn Dark blue",
    [86] = "Worn Blue",
    [87] = "Worn Light blue",
    [88] = "Metallic Taxi Yellow",
    [89] = "Metallic Race Yellow",
    [90] = "Metallic Bronze",
    [91] = "Metallic Yellow Bird",
    [92] = "Metallic Lime",
    [93] = "Metallic Champagne",
    [94] = "Metallic Pueblo Beige",
    [95] = "Metallic Dark Ivory",
    [96] = "Metallic Choco Brown",
    [97] = "Metallic Golden Brown",
    [98] = "Metallic Light Brown",
    [99] = "Metallic Straw Beige",
    [100] = "Metallic Moss Brown",
    [101] = "Metallic Biston Brown",
    [102] = "Metallic Beechwood",
    [103] = "Metallic Dark Beechwood",
    [104] = "Metallic Choco Orange",
    [105] = "Metallic Beach Sand",
    [106] = "Metallic Sun Bleeched Sand",
    [107] = "Metallic Cream",
    [108] = "Util Brown",
    [109] = "Util Medium Brown",
    [110] = "Util Light Brown",
    [111] = "Metallic White",
    [112] = "Metallic Frost White",
    [113] = "Worn Honey Beige",
    [114] = "Worn Brown",
    [115] = "Worn Dark Brown",
    [116] = "Worn straw beige",
    [117] = "Brushed Steel",
    [118] = "Brushed Black steel",
    [119] = "Brushed Aluminium",
    [120] = "Chrome",
    [121] = "Worn Off White",
    [122] = "Util Off White",
    [123] = "Worn Orange",
    [124] = "Worn Light Orange",
    [125] = "Metallic Securicor Green",
    [126] = "Worn Taxi Yellow",
    [127] = "Police Car Blue",
    [128] = "Matte Green",
    [129] = "Matte Brown",
    [130] = "Worn Orange",
    [131] = "Matte White",
    [132] = "Worn White",
    [133] = "Worn Olive Army Green",
    [134] = "Pure White",
    [135] = "Hot Pink",
    [136] = "Salmon pink",
    [137] = "Metallic Vermillion Pink",
    [138] = "Orange",
    [139] = "Green",
    [140] = "Blue",
    [141] = "Mettalic Black Blue",
    [142] = "Metallic Black Purple",
    [143] = "Metallic Black Red",
    [144] = "Hunter Green",
    [145] = "Metallic Purple",
    [146] = "Metallic V Dark Blue",
    [147] = "MODSHOP BLACK1",
    [148] = "Matte Purple",
    [149] = "Matte Dark Purple",
    [150] = "Metallic Lava Red",
    [151] = "Matte Forest Green",
    [152] = "Matte Olive Drab",
    [153] = "Matte Desert Brown",
    [154] = "Matte Desert Tan",
    [155] = "Matte Foilage Green",
    [156] = "DEFAULT ALLOY",
    [157] = "Epsilon Blue",
    [158] = "Pure Gold",
    [159] = "Brushed Gold",
    [160] = "MP100 Matt Army",
    [161] = "MP100 Matt Earth",
    [162] = "MP100 Matt Green",
    [163] = "MP100 Matt Gray",
    [164] = "Worn Sea Wash",
    [165] = "Worn Blue Silver",
    [166] = "MP100 Matt Brown",
    [167] = "MP100 Matt Light Blue",
    [168] = "MP100 Matt Dark Blue",
    [169] = "Metallic Garnet Red",
    [170] = "Metallic Sorrel Brown",
    [171] = "Metallic Yellow Bird",
    [172] = "Metallic Lime",
    [173] = "Metallic Lightning Yellow",
    [174] = "Metallic Astra Blue",
    [175] = "Metallic Aquamarine",
    [176] = "Metallic Bluish Silver",
    [177] = "Metallic Red",
    [178] = "Metallic Dark Red",
    [179] = "Metallic Salmon Pink",
    [180] = "Metallic Dark Green",
    [181] = "Metallic Nightshade Purple",
    [182] = "Metallic Purple",
    [183] = "Metallic Ultra Blue",
}

Config.Weapons = {
    [`WEAPON_STUNGUN`] = 'WEAPON_STUNGUN',
    [`WEAPON_VINTAGEPISTOL`] = 'WEAPON_VINTAGEPISTOL',
    [`WEAPON_SNSPISTOL`] = 'WEAPON_SNSPISTOL',
    [`WEAPON_SNSPISTOL_MK2`] = 'WEAPON_SNSPISTOL_MK2',
    [`WEAPON_PISTOL`] = 'WEAPON_PISTOL',
    [`WEAPON_PISTOL_MK2`] = 'WEAPON_PISTOL_MK2',
    [`WEAPON_COMBATPISTOL`] = 'WEAPON_COMBATPISTOL',
    [`WEAPON_APPISTOL`] = 'WEAPON_APPISTOL',
    [`WEAPON_HEAVYPISTOL`] = 'WEAPON_HEAVYPISTOL',
    [`WEAPON_PISTOL50`] = 'WEAPON_PISTOL50',
    [`WEAPON_REVOLVER`] = 'WEAPON_REVOLVER',
    [`WEAPON_REVOLVER_MK2`] = 'WEAPON_REVOLVER_MK2',
    [`WEAPON_MARKSMANPISTOL`] = 'WEAPON_MARKSMANPISTOL',
    [`WEAPON_DOUBLEACTION`] = 'WEAPON_DOUBLEACTION',
    [`WEAPON_MICROSMG`] = 'WEAPON_MICROSMG',
    [`WEAPON_SMG`] = 'WEAPON_SMG',
    [`WEAPON_SMG_MK2`] = 'WEAPON_SMG_MK2',
    [`WEAPON_ASSAULTSMG`] = 'WEAPON_ASSAULTSMG',
    [`WEAPON_COMBATPDW`] = 'WEAPON_COMBATPDW',
    [`WEAPON_MACHINEPISTOL`] = 'WEAPON_MACHINEPISTOL',
    [`WEAPON_MINISMG`] = 'WEAPON_MINISMG',
    [`WEAPON_PUMPSHOTGUN`] = 'WEAPON_PUMPSHOTGUN',
    [`WEAPON_PUMPSHOTGUN_MK2`] = 'WEAPON_PUMPSHOTGUN_MK2',
    [`WEAPON_ASSAULTSHOTGUN`] = 'WEAPON_ASSAULTSHOTGUN',
    [`WEAPON_BULLPUPSHOTGUN`] = 'WEAPON_BULLPUPSHOTGUN',
    [`WEAPON_SAWNOFFSHOTGUN`] = 'WEAPON_SAWNOFFSHOTGUN',
    [`WEAPON_DBSHOTGUN`] = 'WEAPON_DBSHOTGUN',
    [`WEAPON_HEAVYSHOTGUN`] = 'WEAPON_HEAVYSHOTGUN',
    [`WEAPON_MUSKET`] = 'WEAPON_MUSKET',
    [`WEAPON_AUTOSHOTGUN`] = 'WEAPON_AUTOSHOTGUN',
    [`WEAPON_COMBATSHOTGUN`] = 'WEAPON_COMBATSHOTGUN',
    [`WEAPON_ASSAULTRIFLE`] = 'WEAPON_ASSAULTRIFLE',
    [`WEAPON_ASSAULTRIFLE_MK2`] = 'WEAPON_ASSAULTRIFLE_MK2',
    [`WEAPON_CARBINERIFLE`] = 'WEAPON_CARBINERIFLE',
    [`WEAPON_CARBINERIFLE_MK2`] = 'WEAPON_CARBINERIFLE_MK2',
    [`WEAPON_ADVANCEDRIFLE`] = 'WEAPON_ADVANCEDRIFLE',
    [`WEAPON_SPECIALCARBINE`] = 'WEAPON_SPECIALCARBINE',
    [`WEAPON_SPECIALCARBINE_MK2`] = 'WEAPON_SPECIALCARBINE_MK2',
    [`WEAPON_BULLPUPRIFLE`] = 'WEAPON_BULLPUPRIFLE',
    [`WEAPON_BULLPUPRIFLE_MK2`] = 'WEAPON_BULLPUPRIFLE_MK2',
    [`WEAPON_COMPACTRIFLE`] = 'WEAPON_COMPACTRIFLE',
    [`WEAPON_MILITARYRIFLE`] = 'WEAPON_MILITARYRIFLE',
    [`WEAPON_MG`] = 'WEAPON_MG',
    [`WEAPON_COMBATMG`] = 'WEAPON_COMBATMG',
    [`WEAPON_COMBATMG_MK2`] = 'WEAPON_COMBATMG_MK2',
    [`WEAPON_GUSENBERG`] = 'WEAPON_GUSENBERG',
    [`WEAPON_SNIPERRIFLE`] = 'WEAPON_SNIPERRIFLE',
    [`WEAPON_HEAVYSNIPER`] = 'WEAPON_HEAVYSNIPER',
    [`WEAPON_HEAVYSNIPER_MK2`] = 'WEAPON_HEAVYSNIPER_MK2',
    [`WEAPON_MARKSMANRIFLE`] = 'WEAPON_MARKSMANRIFLE',
    [`WEAPON_MARKSMANRIFLE_MK2`] = 'WEAPON_MARKSMANRIFLE_MK2'
}

--[[ Config.Charges = {
    {
        name = 'Simple Assault',
        class = 'Misdemeanor',
        sentence = {default = 7, min = 5, max = 10},
        fine = {default = 500, min = 250, max = 750},
    },
    {
        name = 'Assault',
        class = 'Misdemeanor',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 850, min = 425, max = 1700},
    },
    {
        name = 'Aggravated Assault',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 1250, min = 625, max = 2500},
    },
    {
        name = 'Assault with a Deadly Weapon',
        class = 'Felony',
        sentence = {default = 30, min = 15, max = 60},
        fine = {default = 3750, min = 1875, max = 7500},
    },
    {
        name = 'Involuntary Manslaughter',
        class = 'Felony',
        sentence = {default = 60, min = 30, max = 120},
        fine = {default = 7500, min = 3750, max = 15000},
    },
    {
        name = 'Vehicular Manslaughter',
        class = 'Felony',
        sentence = {default = 75, min = 38, max = 150},
        fine = {default = 7500, min = 3750, max = 15000},
    },
    {
        name = 'Attempted Murder of a Civilian',
        class = 'Felony',
        sentence = {default = 50, min = 25, max = 100},
        fine = {default = 7500, min = 3750, max = 15000},
    },
    {
        name = 'Second Degree Murder',
        class = 'Felony',
        sentence = {default = 100, min = 10, max = 200},
        fine = {default = 15000, min = 7500, max = 30000},
    },
    {
        name = 'Accessory to Second Degree Murder',
        class = 'Felony',
        sentence = {default = 50, min = 25, max = 100},
        fine = {default = 5000, min = 2500, max = 10000},
    },
    {
        name = 'First Degree Murder',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Accessory to First Degree Murder',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Murder of a Public Servant or Peace Officer',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Attempted Murder of a Public Servant or Peace Officer',
        class = 'Felony',
        sentence = {default = 65, min = 33, max = 130},
        fine = {default = 10000, min = 5000, max = 20000},
    },
    {
        name = 'Accessory to the Murder of a Public Servant or Peace Officer',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Unlawful Imprisonment',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 600, min = 300, max = 1200},
    },
    {
        name = 'Kidnapping',
        class = 'Felony',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 900, min = 450, max = 1800},
    },
    {
        name = 'Accessory to Kidnapping',
        class = 'Felony',
        sentence = {default = 7, min = 4, max = 14},
        fine = {default = 450, min = 225, max = 900},
    },
    {
        name = 'Attempted Kidnapping',
        class = 'Felony',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 450, min = 225, max = 900},
    },
    {
        name = 'Hostage Taking',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 1200, min = 600, max = 2400},
    },
    {
        name = 'Accessory to Hostage Taking',
        class = 'Felony',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 600, min = 300, max = 1200},
    },
    {
        name = 'Unlawful Imprisonment of a Public Servant or Peace Officer.',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 4000, min = 2000, max = 8000},
    },
    {
        name = 'Criminal Threats',
        class = 'Misdemeanor',
        sentence = {default = 5, min = 3, max = 10},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Reckless Endangerment',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Gang Related Shooting',
        class = 'Felony',
        sentence = {default = 30, min = 15, max = 60},
        fine = {default = 2500, min = 1250, max = 5000},
    },
    {
        name = 'Cannibalism',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Torture',
        class = 'Felony',
        sentence = {default = 40, min = 20, max = 80},
        fine = {default = 4500, min = 2250, max = 9000},
    },

    {
        name = 'Petty Theft',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 250, min = 125, max = 500},
    },
    {
        name = 'Grand Theft',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 600, min = 300, max = 1200},
    },
    {
        name = 'Grand Theft Auto A',
        class = 'Felony',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 900, min = 450, max = 1800},
    },
    {
        name = 'Grand Theft Auto B',
        class = 'Felony',
        sentence = {default = 35, min = 18, max = 70},
        fine = {default = 3500, min = 1750, max = 7000},
    },
    {
        name = 'Carjacking',
        class = 'Felony',
        sentence = {default = 30, min = 15, max = 60},
        fine = {default = 2000, min = 1000, max = 4000},
    },
    {
        name = 'Burglary',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Robbery',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 2000, min = 1000, max = 4000},
    },
    {
        name = 'Accessory to Robbery',
        class = 'Felony',
        sentence = {default = 12, min = 6, max = 24},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Attempted Robbery',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Armed Robbery',
        class = 'Felony',
        sentence = {default = 30, min = 15, max = 60},
        fine = {default = 3000, min = 1500, max = 6000},
    },
    {
        name = 'Accessory to Armed Robbery',
        class = 'Felony',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Attempted Armed Robbery',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Grand Larceny',
        class = 'Felony',
        sentence = {default = 45, min = 23, max = 90},
        fine = {default = 7500, min = 3750, max = 15000},
    },
    {
        name = 'Leaving Without Paying',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Possession of Nonlegal Currency',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 750, min = 375, max = 1500},
    },
    {
        name = 'Possession of Government-Issued Items',
        class = 'Misdemeanor',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Possession of Items Used in the Commission of a Crime',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Sale of Items Used in the Commission of a Crime',
        class = 'Felony',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Theft of an Aircraft',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 1000, min = 500, max = 2000},
    },

    {
        name = 'Impersonating',
        class = 'Misdemeanor',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 1250, min = 625, max = 2500},
    }, 
    {
        name = 'Impersonating a Peace Officer or Public Servant',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 2750, min = 1375, max = 5500},
    },
    {
        name = 'Impersonating a Judge',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Possession of Stolen Identification',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 750, min = 375, max = 1500},
    },
    {
        name = 'Possession of Stolen Government Identification',
        class = 'Misdemeanor',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 2000, min = 1000, max = 4000},
    },
    {
        name = 'Extortion',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 900, min = 450, max = 1800},
    },
    {
        name = 'Fraud',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 450, min = 225, max = 900},
    },
    {
        name = 'Forgery',
        class = 'Misdemeanor',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 750, min = 375, max = 1500},
    },
    {
        name = 'Money Laundering',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },

    {
        name = 'Trespassing',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 450, min = 225, max = 900},
    },
    {
        name = 'Felony Trespassing',
        class = 'Felony',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Arson',
        class = 'Felony',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Vandalism',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 300, min = 150, max = 600},
    },
    {
        name = 'Vandalism of Government Property',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Littering',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 200, min = 100, max = 400},
    },

    {
        name = 'Bribery of a Government Official',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 3500, min = 1750, max = 7000},
    },
    {
        name = 'Anti-Mask Law',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 750, min = 375, max = 1500},
    },
    {
        name = 'Possession of Contraband in a Government Facility',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Criminal Possession of Stolen Property',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Escaping',
        class = 'Felony',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 450, min = 225, max = 900},
    },
    {
        name = 'Jailbreak',
        class = 'Felony',
        sentence = {default = 30, min = 15, max = 60},
        fine = {default = 2500, min = 1250, max = 5000},
    },
    {
        name = 'Accessory to Jailbreak',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 2000, min = 1000, max = 4000},
    },
    {
        name = 'Attempted Jailbreak',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Perjury',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Violation of a Restraining Order',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 2250, min = 1125, max = 4500},
    },
    {
        name = 'Embezzlement',
        class = 'Felony',
        sentence = {default = 45, min = 23, max = 90},
        fine = {default = 10000, min = 5000, max = 20000},
    },
    {
        name = 'Unlawful Practice',
        class = 'Felony',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Misuse of Emergency Systems',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 600, min = 300, max = 1200},
    },
    {
        name = 'Conspiracy',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 450, min = 225, max = 900},
    },
    {
        name = 'Violating a Court Order',
        class = 'Misdemeanor',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Failure to Appear',
        class = 'Misdemeanor',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Contempt of Court',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Resisting Arrest',
        class = 'Misdemeanor',
        sentence = {default = 5, min = 3, max = 10},
        fine = {default = 300, min = 150, max = 600},
    },

    {
        name = 'Disobeying a Peace Officer',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 750, min = 375, max = 1500},
    },
    {
        name = 'Disorderly Conduct',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 250, min = 125, max = 500},
    },
    {
        name = 'Disturbing the Peace',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 350, min = 175, max = 700},
    },
    {
        name = 'False Reporting',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 750, min = 375, max = 1500},
    },
    {
        name = 'Harassment',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Misdemeanor Obstruction of Justice',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Felony Obstruction of Justice',
        class = 'Felony',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 900, min = 450, max = 1800},
    },
    {
        name = 'Inciting a Riot',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Loitering on Government Properties',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Tampering',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Vehicle Tampering',
        class = 'Misdemeanor',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 750, min = 375, max = 1500},
    },
    {
        name = 'Evidence Tampering',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Witness Tampering',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Failure to Provide Identification',
        class = 'Misdemeanor',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Vigilantism',
        class = 'Felony',
        sentence = {default = 30, min = 15, max = 60},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Unlawful Assembly',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 750, min = 375, max = 1500},
    },
    {
        name = 'Government Corruption',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Stalking',
        class = 'Felony',
        sentence = {default = 40, min = 20, max = 80},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Aiding and Abetting',
        class = 'Misdemeanor',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 450, min = 225, max = 900},
    },
    {
        name = 'Harboring a Fugitive',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 1000, min = 500, max = 2000},
    },

    {
        name = 'Misdemeanor Possession of Marijuana',
        class = 'Misdemeanor',
        sentence = {default = 5, min = 3, max = 10},
        fine = {default = 250, min = 125, max = 500},
    },
    {
        name = 'Felony Possession of Marijuana',
        class = 'Felony',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Cultivation of Marijuana A',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 750, min = 375, max = 1500},
    },
    {
        name = 'Cultivation of Marijuana B',
        class = 'Felony',
        sentence = {default = 30, min = 15, max = 60},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Possession of Marijuana with Intent to Distribute',
        class = 'Felony',
        sentence = {default = 30, min = 15, max = 60},
        fine = {default = 3000, min = 1500, max = 6000},
    },
    {
        name = 'Misdemeanor Possession of Cocaine',
        class = 'Misdemeanor',
        sentence = {default = 7, min = 4, max = 14},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Felony Possession of Cocaine',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Possession of Cocaine with Intent to Distribute',
        class = 'Felony',
        sentence = {default = 35, min = 18, max = 70},
        fine = {default = 4500, min = 2250, max = 9000},
    },
    {
        name = 'Misdemeanor Possession of Methamphetamine',
        class = 'Misdemeanor',
        sentence = {default = 7, min = 4, max = 14},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Felony Possession of Methamphetamine',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Possession of Methamphetamine with Intent to Distribute',
        class = 'Felony',
        sentence = {default = 35, min = 18, max = 70},
        fine = {default = 4500, min = 2250, max = 9000},
    },
    {
        name = 'Misdemeanor Possession of Oxy / Vicodin',
        class = 'Felony',
        sentence = {default = 7, min = 4, max = 14},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Felony Possession of Oxy / Vicodin',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Felony Possession of Oxy / Vicodin with Intent to Distribute',
        class = 'Felony',
        sentence = {default = 35, min = 18, max = 70},
        fine = {default = 4500, min = 2250, max = 9000},
    },
    {
        name = 'Misdemeanor Possession of Ecstasy',
        class = 'Misdemeanor',
        sentence = {default = 7, min = 4, max = 14},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Felony Possession of Ecstasy',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Possession of Ecstasy with Intent to Distribute',
        class = 'Felony',
        sentence = {default = 35, min = 18, max = 70},
        fine = {default = 4500, min = 2250, max = 9000},
    },
    {
        name = 'Misdemeanor Possession of Opium',
        class = 'Misdemeanor',
        sentence = {default = 7, min = 4, max = 14},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Felony Possession of Opium',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Possession of Opium with Intent to Distribute',
        class = 'Felony',
        sentence = {default = 35, min = 18, max = 70},
        fine = {default = 4500, min = 2250, max = 9000},
    },
    {
        name = 'Misdemeanor Possession of Adderall',
        class = 'Misdemeanor',
        sentence = {default = 7, min = 4, max = 14},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Felony Possession of Adderall',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Possession of Adderall with Intent to Distribute',
        class = 'Felony',
        sentence = {default = 35, min = 18, max = 70},
        fine = {default = 4500, min = 2250, max = 9000},
    },
    {
        name = 'Misdemeanor Possession of Xanax',
        class = 'Misdemeanor',
        sentence = {default = 7, min = 4, max = 14},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Felony Possession of Xanax',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Possession of Xanax with Intent to Distribute',
        class = 'Felony',
        sentence = {default = 35, min = 18, max = 70},
        fine = {default = 4500, min = 2250, max = 9000},
    },
    {
        name = 'Misdemeanor Possession of Shrooms',
        class = 'Misdemeanor',
        sentence = {default = 7, min = 4, max = 14},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Felony Possession of Shrooms',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Possession of Shrooms with Intent to Distribute',
        class = 'Felony',
        sentence = {default = 35, min = 18, max = 70},
        fine = {default = 4500, min = 2250, max = 9000},
    },
    {
        name = 'Misdemeanor Possession of Lean',
        class = 'Misdemeanor',
        sentence = {default = 7, min = 4, max = 14},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Felony Possession of Lean',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Possession of Lean with Intent to Distribute',
        class = 'Felony',
        sentence = {default = 35, min = 18, max = 70},
        fine = {default = 4500, min = 2250, max = 9000},
    },
    {
        name = 'Sale of a controlled substance',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Drug Trafficking',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Desecration of a Human Corpse',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Public Intoxication',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Public Indecency',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 750, min = 375, max = 1500},
    },

    {
        name = 'Criminal Possession of Weapon Class A',
        class = 'Felony',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Criminal Possession of Weapon Class B',
        class = 'Felony',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Criminal Possession of Weapon Class C',
        class = 'Felony',
        sentence = {default = 30, min = 15, max = 60},
        fine = {default = 3500, min = 1750, max = 7000},
    },
    {
        name = 'Criminal Possession of Weapon Class D',
        class = 'Felony',
        sentence = {default = 25, min = 13, max = 50},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Criminal Sale of Weapon Class A',
        class = 'Felony',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Criminal Sale of Weapon Class B',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 2000, min = 1000, max = 4000},
    },
    {
        name = 'Criminal Sale of Weapon Class C',
        class = 'Felony',
        sentence = {default = 35, min = 18, max = 70},
        fine = {default = 7000, min = 3500, max = 14000},
    },
    {
        name = 'Criminal Sale of Weapon Class D',
        class = 'Felony',
        sentence = {default = 30, min = 15, max = 60},
        fine = {default = 3000, min = 1500, max = 6000},
    },
    {
        name = 'Criminal Use of Weapon',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 450, min = 225, max = 900},
    },
    {
        name = 'Possession of Illegal Firearm Modifications',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 300, min = 150, max = 600},
    },
    {
        name = 'Weapon Trafficking',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Brandishing a Weapon',
        class = 'Misdemeanor',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 500, min = 250, max = 1000},
    },
    {
        name = 'Insurrection',
        class = 'Felony',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 0, min = 0, max = 0},
    },
    {
        name = 'Flying into Restricted Airspace',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 1500, min = 750, max = 3000},
    },
    {
        name = 'Jaywalking',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 150, min = 75, max = 300},
    },
    {
        name = 'Criminal Use of Explosives',
        class = 'Felony',
        sentence = {default = 30, min = 15, max = 60},
        fine = {default = 2500, min = 1250, max = 5000},
    },

    {
        name = 'Driving While Intoxicated',
        class = 'Misdemeanor',
        sentence = {default = 5, min = 3, max = 10},
        fine = {default = 300, min = 150, max = 600},
    },
    {
        name = 'Evading',
        class = 'Misdemeanor',
        sentence = {default = 5, min = 3, max = 10},
        fine = {default = 400, min = 200, max = 800},
        points = 2,
    },
    {
        name = 'Reckless Evading',
        class = 'Felony',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 800, min = 400, max = 1600},
        points = 4,
    },
    {
        name = 'Failure to Yield to Emergency Vehicle',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 600, min = 300, max = 1200},
        points = 2,
    },
    {
        name = 'Failure to Obey Traffic Control Device',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 150, min = 75, max = 300},
        points = 2,
    },
    {
        name = 'Nonfunctional Vehicle',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 75, min = 38, max = 150},
        points = 2,
    },
    {
        name = 'Negligent Driving',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 300, min = 150, max = 600},
        points = 3,
    },
    {
        name = 'Reckless Driving',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 750, min = 375, max = 1500},
        points = 4,
    },
    {
        name = 'Third Degree Speeding',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 225, min = 113, max = 450},
        points = 4,
    },
    {
        name = 'Second Degree Speeding',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 450, min = 225, max = 900},
        points = 3,
    },
    {
        name = 'First Degree Speeding',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 750, min = 375, max = 1500},
        points = 2,
    },
    {
        name = 'Unlicensed Operation of Vehicle',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 500, min = 250, max = 1000},
        points = 2,
    },
    {
        name = 'Illegal U-Turn',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 75, min = 38, max = 150},
        points = 1,
    },
    {
        name = 'Illegal Passing',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 300, min = 150, max = 600},
        points = 1,
    },
    {
        name = 'Failure to Maintain Lane',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 300, min = 150, max = 600},
        points = 1,
    },
    {
        name = 'Illegal Turn',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 150, min = 75, max = 300},
        points = 1,
    },
    {
        name = 'Failure to Stop',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 600, min = 300, max = 1200},
        points = 1,
    },
    {
        name = 'Unauthorized Parking',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 300, min = 150, max = 600},
        points = 1,
    },
    {
        name = 'Hit and Run',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 500, min = 250, max = 1000},
        points = 4,
    },
    {
        name = 'Driving without Headlights or Signals',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 300, min = 150, max = 600},
        points = 1,
    },
    {
        name = 'Street Racing',
        class = 'Felony',
        sentence = {default = 15, min = 8, max = 30},
        fine = {default = 1500, min = 750, max = 3000},
        points = 5,
    },
    {
        name = 'Piloting without Proper Licensing',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 1500, min = 750, max = 3000},
        points = 3,
    },
    {
        name = 'Unlawful Use of a Motorvehicle',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 750, min = 375, max = 1500},
        points = 3,
    },

    {
        name = 'Hunting in Restricted Areas',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 450, min = 225, max = 900},
    },
    {
        name = 'Unlicensed Hunting',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 450, min = 225, max = 900},
    },
    {
        name = 'Animal Cruelty',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 450, min = 225, max = 900},
    },
    {
        name = 'Hunting with a Non-Hunting Weapon',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 750, min = 375, max = 1500},
    },
    {
        name = 'Hunting outside of hunting hours',
        class = 'Infraction',
        sentence = {default = 0, min = 0, max = 0},
        fine = {default = 750, min = 375, max = 1500},
    },
    {
        name = 'Overhunting',
        class = 'Misdemeanor',
        sentence = {default = 10, min = 5, max = 20},
        fine = {default = 1000, min = 500, max = 2000},
    },
    {
        name = 'Poaching',
        class = 'Felony',
        sentence = {default = 20, min = 10, max = 40},
        fine = {default = 1250, min = 625, max = 2500},
    },
} ]]