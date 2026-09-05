-- ──────────────────────────────────────────────────────────────────────────────
-- Dependency Check Helper
-- (Information) ► Returns the first matching started resource alias from provided table.
-- (Information) ► Used by Fuel/Keys/TextUI/Notify/Target detection below.
-- ──────────────────────────────────────────────────────────────────────────────
function scriptCheck(data)            -- Do not modify unless you know what you're doing.
    for k, v in pairs(data) do
        if GetResourceState(k):find('started') ~= nil then
            return v
        end
    end
    return false
end

-- ──────────────────────────────────────────────────────────────────────────────
--  OTHERPLANET / OP Garages CONFIGURATION
-- ──────────────────────────────────────────────────────────────────────────────
--  This configuration file controls all customizable behaviour of OP Garages.
--  Always make a backup before editing.
--  Wrong edits can break the resource.
-- ──────────────────────────────────────────────────────────────────────────────

Config = {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Locale & Debug
-- (Information) ► Locale controls which language file from locales/* will be used.
-- (Information) ► Debug enables extra logging to help with issue tracking.
-- ──────────────────────────────────────────────────────────────────────────────
Config.Locale = "en"                  -- Supported: EN, PL, EL, FR, HR, IT, SK, SL, CZ, SV, PT, TW, ES, AR, NO, DE, BG
Config.Debug  = false                 -- true = verbose debug output in console.

-- Translations in progress: TR / LT / HU

-- ──────────────────────────────────────────────────────────────────────────────
-- Default Locations Helper
-- (Information) ► Inserts default garages/impounds into database (server console).
-- ──────────────────────────────────────────────────────────────────────────────
-- IF YOU WANT DO USE OUR DEFAULT GARAGES AND IMPOUND LOCATIONS USE COMMAND USING SERVER CONSOLE
-- /insertDefaultLocations
-- Then restart the server.

-- ──────────────────────────────────────────────────────────────────────────────
-- Fuel Dependency Detection
-- (Information) ► Auto-detects your active fuel resource.
-- ──────────────────────────────────────────────────────────────────────────────
local fuelScripts = {
    ['cdn-fuel']    = "cdn-fuel",
    ['ox_fuel']     = "ox-fuel",
    ['LegacyFuel']  = "LegacyFuel",
    ['rcore_fuel']  = "rcore-fuel",
    ['codem-xfuel'] = "codem-xfuel",
    ['lc_fuel']     = "lc_fuel",
    ['stg-fuel']    = "stg-fuel",
    ['myFuel']      = "myFuel",
    ['lt-fuel']      = "lt-fuel",
}
Config.FuelDependency = scriptCheck(fuelScripts) or 'none'

-- ──────────────────────────────────────────────────────────────────────────────
-- Vehicle Keys Dependency Detection
-- (Information) ► Auto-detects supported vehicle key systems.
-- ──────────────────────────────────────────────────────────────────────────────
local keyScripts = {
    ['brutal_keys']         = "brutal_keys",
    ['qbx_vehiclekeys']     = "qb-keys",
    ['qb-vehiclekeys']      = "qb-keys",
    ['wasabi_carlock']      = "wasabi_carlock",
    ['sna-vehiclekeys']     = "sna-vehiclekeys",
    ['dusa_vehiclekeys']    = "dusa_vehiclekeys",
    ['Renewed-Vehiclekeys'] = "Renewed-Vehiclekeys",
    ['tgiann-hotwire']      = "tgiann-keys",
    ['ak47_vehiclekeys']    = "ak47_vehiclekeys",
    ['ak47_qb_vehiclekeys'] = "ak47_qb_vehiclekeys",
    ['mVehicle']            = "mVehicle",
    ['sy_carkeys']          = "sy_carkeys",
    ['MrNewbVehicleKeys']   = "MrNewbVehicleKeys",
    ['p_carkeys']           = "p_carkeys",
    ['p_vehiclekeys']       = "p_vehiclekeys",
    ['ic3d_vehiclekeys']    = "ic3d_vehiclekeys",
    ['filo_vehiclekeys']    = "filo_vehiclekeys",
    ['vehicle_keys']        = "jaksam_keys",
    -- Older / custom QB variants (keep as manual options when needed):
    -- old-qb-keys / custom-qb-keys
}
Config.KeysDependency = scriptCheck(keyScripts) or 'none'

-- ──────────────────────────────────────────────────────────────────────────────
-- Mechanic Script (vehicle properties get/set)
-- (Information) ► Auto-detects op-mechanic or jg-mechanic. Falls back to ox_lib.
-- (Information) ► Force manually: Config.MechanicScript = 'none' | 'op-mechanic' | 'jg-mechanic'
-- (Information) ► jg-mechanic: op-garages uses ox_lib for get/set (jg export needs valid netId).
-- (Information) ► Plate changes still call jg vehiclePlateUpdated on the server.
-- ──────────────────────────────────────────────────────────────────────────────
local mechanicScripts = {
    ['op-mechanic'] = 'op-mechanic',
    ['jg-mechanic'] = 'jg-mechanic',
}
Config.MechanicScript = scriptCheck(mechanicScripts) or 'none'
-- Set true ONLY if you want jg setVehicleProperties on fully networked spawns (not preview).
Config.MechanicJgProps = false

-- ──────────────────────────────────────────────────────────────────────────────
-- Text UI Dependency Detection
-- (Information) ► Auto-detects supported 3D/2D Text UI libraries.
-- ──────────────────────────────────────────────────────────────────────────────
local textUIScripts = {
    ['ox_lib']        = "ox_lib",
    ['jg-textui']     = "jg-textui",
    ['okokTextUI']    = "okokTextUI",
    ['brutal_textui'] = "brutal_textui",
    ['0r-textui']     = "0r-textui",
}
Config.TextUI = scriptCheck(textUIScripts) or 'none'

Config.Addons = {
    AdvancedParking = false, -- Set to true if you're using Advanced Parking v4 Script.
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ MISC CONFIGURATION ⚒️
-- (Information) ► General behaviour, markers, notifications, target, peds, prices, etc.
-- ──────────────────────────────────────────────────────────────────────────────

Config.Misc = {
    zoneSize = 1.2, -- Marker radius.
    zoneColor = { -- Marker color.
        r = 52,
        g = 116,
        b = 235,
    },
    -- true = markers are snapped to the real ground level regardless of the Z in the coords.
    -- Useful when garage/impound coords have a wrong/floating height. Affects all drawn markers.
    MarkersOnGround = false,
    Icons = { -- OX Target / QB Target icons.
        car = "fa-solid fa-square-parking",
        sea = "fa-solid fa-sailboat",
        air = "fa-solid fa-plane",
        impound = "fa-solid fa-money-bill-wave",
        showroom = "fa-solid fa-building",
        ownedGarage = "fa-solid fa-square-parking",
        ownedGarage_purchase = "fa-solid fa-money-bill-wave",
        ownedGarage_takeOut = "fa-solid fa-square-parking",
        ownedGarageManage = "fa-solid fa-code-fork",
    }, 
    TowingPrice = 200, -- Price of towing left or destroyed vehicle.
    TowingTime = 5, -- Towing destroyed/left vehicle Time.
    TransferPrice = 500, -- Transfer Vehicle from garage to garage price.
    Peds = {
        -- You can also disable only selected ped. E.X (sea = false)
        Toggle = false, -- Disable/Enable peds.
        sea = {
            model = "player_one",
            gender = "male"
        },
        air = {
            model = "ig_floyd",
            gender = "male"
        },
        impound = {
            model = "ig_trafficwarden",
            gender = "male"
        },
        car = {
            model = "s_m_y_garbage",
            gender = "male"
        }
    },
    Markers = {
        -- If you don't use ox_target or qb-target you can setup different markers for selected interactions. 
        -- To disable selected marker drawing set it to false. (example: car = false)
        -- If peds are enabled, marker will be drawed in front of ped. 
        sea = {
            type = 35,
            size = vec3(2.2, 2.2, 2.2),
            color = { -- Marker color.
                r = 52,
                g = 116,
                b = 235,
            }
        },
        air = {
            type = 34,
            size = vec3(1.2, 1.2, 1.2),
            color = { -- Marker color.
                r = 52,
                g = 116,
                b = 235,
            }
        },
        impound = {
            type = 39,
            size = vec3(1.2, 1.2, 1.2),
            color = { -- Marker color.
                r = 242,
                g = 0,
                b = 20,
            }
        },
        car = {
            type = 36,
            size = vec3(1.2, 1.2, 1.2),
            color = { -- Marker color.
                r = 52,
                g = 116,
                b = 235,
            }
        }
    },
    WarpPedToVehicle = true, -- If false, player will be not teleported or walked to the vehicle.
    DisableVehicleHideAnimation = true, -- Disable take out vehicle animation (Player will be teleported inside vehicle instead of animation)
    DisableVehicleSpawnInGarage = false, -- Disable spawning showcase vehicle when open garage
    -- Preview spawn-slot reservation (prevents 2 players previewing on the same spot).
    -- On busy servers stale locks used to hang "Loading vehicle.." forever — locks now expire + client has a fallback.
    PreviewSlotLock = {
        Enable = true, -- false = no server lock (local free-spot check only). Use on very high pop if hangs persist.
        LockTimeoutMs = 45000, -- auto-release reserved preview slot after this time (ms)
        ClientWaitMs = 4000, -- max time client waits for a free locked slot before local-only fallback
    },
    DisableVehicleTransfer = false, -- Vehicles will be availabe to take out from every garage.
    VehicleBackToGarage = false, -- true = return vehicles to garage on disconnect (personal + job/gang fleet if player was driving or entity is gone). Also cleans orphaned state=1 after server restart.
    ReverseGradeCheck = true, -- examples: True = vehicle with minimum grade 3 will be available for grades higher than 3. False = vehicle with minimum grade 3 will be available for grades lower than 3. 
    DisableVehiclesTransferButKeepUniqueGarages = false, -- If this is true, it will keep vehicles in garages where they were stored but do not allow to transfer between garages.
    GiveKeysToSubownerWhenTakenOut = false, -- If true - script will give keys to subowner when vehicle is taken out from garage / remove keys from subowner when vehicle is stored.
    GiveKeysInsideShowroom = false, -- Give keys to all vhicles inside showroom.
    DisableReconnectTeleport = false, -- true = disable ALL showroom/private garage player teleports (entry, exit, reconnect recovery). Debug only.
}

Config.NUI = {
    GarageSmallVersion = false, -- Enable / Disable small version of garage. This option changes Garage menu to box on the middle of the screen instead on the left.
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Target / Notify Auto Detection (optional)
-- (Information) ► Detects target/notify libraries by started resources.
-- ──────────────────────────────────────────────────────────────────────────────
local targets = {
    ['ox_target'] = "ox-target",
    ['qb-target'] = "qb-target",
}
local notifyScripts = {
    ['op-hud']        = "op_hud",
    ['okokNotify']    = "okokNotify",
    ['vms_notify']    = "vms_notify",
    ['ox_lib']        = "ox_lib",
    ['brutal_notify'] = "brutal_notify",
}
Config.Misc.Notify = scriptCheck(notifyScripts) or 'ox_lib'
Config.Misc.Target = scriptCheck(targets) or 'none'

-- ──────────────────────────────────────────────────────────────────────────────
-- Markers Configuration (Store / Hide Vehicle)
-- (Information) ► These markers are used to store/hide a vehicle back into garage.
-- (Information) ► They are usually visible only when sitting in a vehicle on parking slots.
-- (Information) ► `enableWhenUsingTarget` keeps markers even if you use target interaction.
-- ──────────────────────────────────────────────────────────────────────────────
Config.Markers = {
    -- Markers for hiding vehicles in garage, visible only when inside car on parking slots!
    enable = true,
    enableWhenUsingTarget = true,
    car = {
        type = 36,
        size = vec3(1.2, 1.2, 1.2),
        color = { -- Marker color.
            r = 52,
            g = 116,
            b = 235,
        }
    },
    air = {
        type = 34,
        size = vec3(1.2, 1.2, 1.2),
        color = { -- Marker color.
            r = 52,
            g = 116,
            b = 235,
        }
    },
    sea = {
        type = 35,
        size = vec3(2.2, 2.2, 2.2),
        color = { -- Marker color.
            r = 52,
            g = 116,
            b = 235,
        }
    },
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ SUB OWNERS ⚒️
-- (Information) ► Allows sharing vehicle access with additional players.
-- (Information) ► Configure command, price and maximum subowners per vehicle.
-- (Information) ► Custom payment / restrictions: server/editable/payForSubOwner.lua & client/editable/restrictSubOwners.lua
-- ──────────────────────────────────────────────────────────────────────────────

Config.SubOwners = {
    Allow = true, -- Disable/Enable sub owners feature.
    Command = "subowner", -- Command Name
    Price = 5000, -- Price of adding subowner.
    MaxSubOwners = 3, -- Maximum amount of subowners for one vehicle.
    OpenMethod = {
        command = true, -- /subowner command (works anywhere).
        points = false, -- Enable the target/ped Points below (drive-up locations only).
    },
    -- Fixed locations players must drive to in order to manage sub-owners.
    -- Only used when OpenMethod.points = true.
    Points = {
        -- {
        --     coords = vec4(-56.5, -1096.5, 26.4, 160.0),
        --     label = "Manage Sub-Owners",
        --     ped = { model = "s_m_m_autoshop_01", gender = "male" }, -- set to false for an invisible target zone only
        --     blip = { enable = true, sprite = 526, color = 5, scale = 0.7, category = 10 },
        -- },
    },

    -- You can add your custom pay method using integrations/server/payForSubOwner.lua
    -- You can also set open menu function only for donators or whatever you want using: integrations/client/restrictSubOwners.lua
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ PERMANENT PLATE CHANGER ITEM ⚒️
-- (Information) ► Gives players an item that permanently changes the plate of a vehicle they own.
-- (Information) ► Great for selling "Custom Plates" on Tebex without manual ticket handling.
-- (Information) ► Uses the same plate-changer UI as the admin command.
-- ──────────────────────────────────────────────────────────────────────────────

Config.PlateChanger = {
    Enable = true, -- Disable/Enable the plate changer item.
    ItemName = "plate_changer", -- Inventory item that opens the plate changer.
    ConsumeOnUse = true, -- Remove one item after a successful plate change.
    Price = 0, -- Extra money charged on top of the item (0 = item only).
    OwnerOnly = true, -- true = only the main owner can change the plate. false = co-owners allowed too.
    MaxLength = 8, -- Maximum plate length allowed.
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ Mileage ⚒️
-- (Information) ► Displays vehicle mileage in garage UI.
-- (Information) ► op-mechanic: uses GetVehicleMileage(plate) export + OpMechanicColumn fallback.
-- (Information) ► Other setups: reads DatabaseColumnName from your vehicles table.
-- ──────────────────────────────────────────────────────────────────────────────

Config.Mileage = {
    Enable = true,
    DatabaseColumnName = "mileage", -- generic / jg-mileage / legacy column
    OpMechanicColumn = "mileage_km", -- op-mechanic column on player_vehicles (export fallback)
    DistanceUnit = "Mi", -- used when mileage source has no unit (op-mechanic sends odometerUnit)
    DecimalPlaces = 1,
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ ADMINISTRATORS ⚒️
-- (Information) ► Admin menu command and management commands (delete/add vehicles).
-- (Information) ► Configure who can use admin panel via identifiers below.
-- ──────────────────────────────────────────────────────────────────────────────

Config.AdminMenu = {
    Command = "garageadmin", -- Command Name
    EnableCommands = true, -- Disable/Enable commands: (/delveh, /addcar)
    PlateChangerCommand = "changeplate", -- Plate changer command.
    DeleteVehicle = "delveh", -- Permamently Delete car from database.
    AddCarCommand = "addcar", -- Add car to database.
    AddJobCarCommand = "addjobcar", -- Add job car to database.
    AddGangCarCommand = "addgangcar", -- Add gang car to database.
}

-- List of allowed identifiers to use /garageadmin
-- You can use all identifiers from TXADMIN -> `IDs` (No Hardware IDs!)
-- You can also use character identifier to allow only selected character of administrator:
-- E.X: char1:7e0ec7b80d186fd8c29f6631e4377e75812fe8fd
-- OR ON QBOX/QB CITIZENID!!

Config.AdminPanelPlayers = {
    ['fivem:1550613'] = true,
    ['discord:571105311251890186'] = true,
    ['license:94792cad7ae764305aae8f1372d3cd287848ae7c'] = true
}

-- List of allowed Ranks to use Admin Commands and Admin Panel.
Config.RanksPermissions = {
    ['esx'] = {'superadmin', 'admin', 'mod', },
    ['qbcore'] = {'god', 'admin', },
    ['qbox'] = {'god', 'admin', },
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ Impound Menu Config ⚒️
-- (Information) ► Controls impound menu access, allowed jobs/grades and release fee limits.
-- (Information) ► Locations are configured via garage admin (per job, if needed).
-- ──────────────────────────────────────────────────────────────────────────────

Config.IV = {
    jobsList = {
        ['mechanic'] = 2, -- Job name & grade.
        ['police'] = 1, -- Job name & grade.
    },
    commandName = "impoundmenu", -- Command Name
    allowPriceBeforeImpoundDate = true, -- Allows setting the vehicle release price *before* the impound date. (The player who impounded the vehicle can also set it to 0 to disable the fee.)
    allowPriceAfterImpoundDate = true,  -- Allows setting the vehicle release price *after* the impound date. (The player who impounded the vehicle can also set it to 0 to disable the fee.)
    maxPriceAfterImpoundDate = 6500,    -- Maximum fee for releasing a vehicle after the impound date.
    maxPriceBeforeImpoundDate = 14500,  -- Maximum fee for releasing a vehicle before the impound date.
    timeOptions = {
        -- Value = hours, or "never"
        {label = "Available Instantly", value = "0"},
        {label = "1 Day", value = "24"},
        {label = "3 Days", value = "72"},
        {label = "7 Days", value = "168"},
        {label = "Only By fraction member.", value = "never"},
    }
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ Owned Garages Settings ⚒️
-- (Information) ► Settings for owned garages (Purchasable places where player can invite friend etc.)
-- ──────────────────────────────────────────────────────────────────────────────

Config.OwnedGarages = {
    enablePayments = true, -- Enable or disable garage maintenance payments. If enabled and the player fails to pay the required fees, the garage will be listed for sale and the player will lose access to it.
    sellToCityPercentage = 80, -- If garage costs 100k$ player will be available to isntantly sell this garage for 80k$ 
    blips = {
        ownedGarage = {
            blipId = 524, 
            blipColor = 3,
            blipCategory = 12,
        },
        toPurchaseGarage = {
            blipId = 375, 
            blipColor = 2,
            blipCategory = 13,
        }
    },
    Markers = {
        -- If you don't use ox_target or qb-target you can setup different markers for selected interactions. 
        -- To disable selected marker drawing set it to false. (example: car = false)
        entrance = { -- entrance / leave door
            type = 6,
            size = vec3(1.2, 1.2, 1.2),
            color = { -- Marker color.
                r = 52,
                g = 116,
                b = 235,
            }
        },
        manageGarage = { -- manage garage marker
            type = 6,
            size = vec3(1.2, 1.2, 1.2),
            color = { -- Marker color.
                r = 52,
                g = 116,
                b = 235,
            }
        },
        takeOut = { -- car take out marker
            type = 36,
            size = vec3(1.2, 1.2, 1.2),
            color = { -- Marker color.
                r = 52,
                g = 116,
                b = 235,
            }
        },
        purchase = { -- garage purchase marker
            type = 29,
            size = vec3(1.2, 1.2, 1.2),
            color = { -- Marker color.
                r = 12,
                g = 209,
                b = 8,
            }
        },
    },
    availableInteriors = {
        -- Index must be unique number!!!
        [1] = {
            label = "Small Garage", 
            image = "https://forum-cfx-re.akamaized.net/original/3X/d/9/d9cd4b3a97dd0ff36b1874db8f34849f986ee48d.jpeg",
            entranceCoords = vec4(206.7799, -998.9412, -99.0000, 86.8923),
            manageGarageCoords = vec4(205.4705, -995.3528, -99.0000, 134.4235),
            parkingSlots = {
                vec4(194.4693, -1001.2854, -99.5944, 181.5290),
                vec4(202.2279, -1000.8835, -99.5956, 179.7534),
            },
            payments = {
                day1 = 300,
                day3 = 700,
                day7 = 1600,
                month = 5300,
            }
        }, 
        [2] = {
            label = "Large Garage", 
            image = "https://forum-cfx-re.akamaized.net/original/3X/d/9/d9cd4b3a97dd0ff36b1874db8f34849f986ee48d.jpeg",
            entranceCoords = vec4(237.7881, -1004.9349, -99.0000, 97.2883),
            manageGarageCoords = vec4(234.6618, -976.7750, -99.0000, 143.9041),
            parkingSlots = {
                vec4(224.5825, -1001.2023, -99.5936, 303.7140),
                vec4(224.5841, -996.5183, -99.5940, 308.2179),
                vec4(223.7261, -991.9572, -99.5950, 310.6811),
                vec4(223.5744, -986.9030, -99.5940, 309.8272),
                vec4(223.8099, -981.5557, -99.5934, 311.7174)
            },
            payments = {
                day1 = 300,
                day3 = 700,
                day7 = 1600,
                month = 5300,
            }
        },
    }
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ CarContract Settings ⚒️
-- (Information) ► Enables vehicle selling/transfer via car contract (command and/or item).
-- ──────────────────────────────────────────────────────────────────────────────

Config.CarContract = {
    command = {
        enable = true,
        name = "sellcar"
    },
    item = {
        enable = true, 
        name = "car_contract",
        removeOnUse = true,
    },
    -- Models that cannot be sold via car contract (spawn name or hash).
    -- Example: { "adder", "zentorno", `oppressor2` }
    Blacklist = {
        -- "adder",
        -- "police",
    },
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ Fake Plate Settings ⚒️
-- (Information) ► Controls required items and duration for applying/removing fake plates.
-- (Information) ► To disable: simply don't create required items (or remove them from inventory).
-- ──────────────────────────────────────────────────────────────────────────────

Config.FakePlates = {
    fakePlateItemName = "fakeplate",
    fakePlateRemoveItemName = "fakeplate_remover",
    animationDuration = 15, -- Time in seconds
    -- Only the registered owner can mount/remove. Set false to also allow co-owners.
    OwnerOnly = true,
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ Currency Settings ⚒️
-- (Information) ► Visual formatting of money values in the UI (JS Intl.NumberFormat).
-- (Information) ► This does not change economy logic, only display formatting.
-- ──────────────────────────────────────────────────────────────────────────────

Config.CurrencySettings = {
    -- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat
    currency = "USD",
    style = "currency",
    format = "en-US"
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ Blips Settings ⚒️
-- (Information) ► Map blips for garages/impound types.
-- (Information) ► Configure scale, sprite (blipId), color and blipCategory per category.
-- (Information) ► blipCategory groups blips on the map legend (SetBlipCategory) — same value = stacked together.
-- ──────────────────────────────────────────────────────────────────────────────

Config.Blips = {
    size = 0.8,
    car = {
        blipId = 357, 
        blipColor = 3,
        blipCategory = 10,
    },
    sea = {
        blipId = 356, 
        blipColor = 3,
        blipCategory = 10,
    },
    air = {
        blipId = 569, 
        blipColor = 3,
        blipCategory = 10,
    },
    impound = {
        blipId = 67, 
        blipColor = 1,
        blipCategory = 11,
    }
}

-- ──────────────────────────────────────────────────────────────────────────────
-- ⚒️ Showrooms locations ⚒️
-- (Information) ► Defines showroom interiors and parking slots for previewing vehicles.
-- (Information) ► Use `AllowOnlyInPrivateGarages` to restrict showroom access.
-- ──────────────────────────────────────────────────────────────────────────────

Config.Showrooms = {
    Config = {
        Enable = true,
        AllowOnlyInPrivateGarages = false,
    },
    car = {
        EntranceCoords = vec4(1295.2756, 261.7921, -50.0573, 174.5392),
        ParkingSlots = {
            {
                Coords = vec4(1281.2789, 240.9465, -49.4692, 243.5022),
            },
            {
                Coords = vec4(1281.3644, 250.2220, -49.4689, 242.7067),
            },
            {
                Coords = vec4(1280.8601, 258.3342, -49.4696, 239.6884),
            },
            {
                Coords = vec4(1295.1112, 249.0047, -49.4691, 177.1261),
            },
            {
                Coords = vec4(1295.1277, 241.2695, -49.4692, 180.6348),
            },
            {
                Coords = vec4(1295.1410, 231.9178, -49.4692, 178.8318),
            },
            {
                Coords = vec4(1309.6279, 230.9311, -49.4691, 52.8349),
            },
            {
                Coords = vec4(1309.7224, 241.4225, -49.4700, 54.4629),
            },
            {
                Coords = vec4(1309.9415, 249.3070, -49.4696, 62.1490),
            },
            {
                Coords = vec4(1309.5300, 258.2726, -49.4688, 63.7715),
            },
        }
    },
    air = {
        EntranceCoords = vec4(-1264.9331, -3044.3931, -49.4903, 4.1420),
        ParkingSlots = {
            {
                Coords = vec4(-1276.7047, -2973.7190, -48.4897, 195.8378)
            },
            {
                Coords = vec4(-1259.4069, -2973.9412, -48.4897, 145.3174)
            },
            {
                Coords = vec4(-1256.5042, -2994.2913, -48.4899, 148.5025)
            },
            {
                Coords = vec4(-1275.6095, -2997.0205, -48.4898, 199.9497)
            },
            {
                Coords = vec4(-1280.2980, -3018.5117, -48.4901, 238.2952)
            },
            {
                Coords = vec4(-1258.7426, -3021.3916, -48.4903, 138.1917)
            },
        }
    },

    -- You can add here sea type if you want as well!
}