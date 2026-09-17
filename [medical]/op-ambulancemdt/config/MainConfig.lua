-- ──────────────────────────────────────────────────────────────────────────────
-- Dependency Check Helper                                                     
-- (Information) ► Returns the first matching started resource alias from provided table.
-- (Information) ► Used by Fuel/Keys/TextUI/Inventory/Target detection above.
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
--  OTHERPLANET / OP Ambulance MDT / Main CONFIGURATION
-- ──────────────────────────────────────────────────────────────────────────────
--  This configuration file controls all customizable behaviour of OP Ambulance MDT
--  Always make a backup before editing.
--  Wrong edits can break the resource.
-- ──────────────────────────────────────────────────────────────────────────────

Config = {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Locale & Debug                                                             
-- (Information) ► Locale controls which language file from locales/* will be used.
-- (Information) ► Debug enables extra logging to help with issue tracking.
-- ──────────────────────────────────────────────────────────────────────────────

Config.Locale = "en"                  -- Supported: EN, DE, EL, ES, FR, HR, IT, LT, NL, SK, SL, SV, TR
Config.Debug  = false                 -- true = verbose debug output in console.

-- ──────────────────────────────────────────────────────────────────────────────
-- Currency Formatting                                                         
-- (Information) ► Visual formatting of money values in the UI (JS Intl.NumberFormat).
-- (Information) ► This does NOT change internal game currency logic, only display.
-- ──────────────────────────────────────────────────────────────────────────────

Config.CurrencySettings = {
    -- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat
    currency = "USD",
    style = "currency",
    format = "en-US"
}

-- ──────────────────────────────────────────────────────────────────────────────
-- MISC CONFIGURATION                                                   
-- (Information) ► Notifications and Target
-- ──────────────────────────────────────────────────────────────────────────────

local targets = { -- Target libraries detection
    ['ox_target'] = "ox-target",
    ['qb-target'] = "qb-target"
}

local notifyScripts = { -- Notify libraries detection
    ['op-hud'] = "op_hud",
    ['okokNotify'] = "okokNotify",
    ['vms_notify'] = "vms_notify",
    ['ox_lib'] = "ox_lib",
    ['brutal_notify'] = "brutal_notify",
}

Config.Target = scriptCheck(targets) or 'none' -- Supported: ox-target / qb-target / none
Config.Notify = scriptCheck(notifyScripts) or 'none'

-- ──────────────────────────────────────────────────────────────────────────────
-- Text UI Dependency Detection                                                
-- (Information) ► Auto-detects supported 3D/2D Text UI libraries.
-- (Information) ► If none is found, some prompts may fallback to default behaviour.
-- ──────────────────────────────────────────────────────────────────────────────
local textUIScripts = {              
    ['ox_lib']        = "ox_lib",
    ['jg-textui']     = "jg-textui",
    ['okokTextUI']    = "okokTextUI",
    ['brutal_textui'] = "brutal_textui",
    ['0r-textui']     = "0r-textui",
}
Config.TextUI = scriptCheck(textUIScripts) or 'none' 

-- ──────────────────────────────────────────────────────────────────────────────
-- Banking SCRIPT Detection                                           
-- (Information) ► Auto-detects supported banking scripts
-- (Information) ► If none is found, some prompts may fallback to default behaviour.
-- ──────────────────────────────────────────────────────────────────────────────

local bankingScripts = {              
    ['esx_addonaccount'] = "esx_addonaccount",
    ['qb-banking']       = "qb-banking",
    ['fd_banking']       = "fd_banking",
    ['okokBanking']      = "okokBanking",
    ['Renewed-Banking']  = "Renewed-Banking",
    ['tgg-banking']      = "tgg-banking"
}
Config.Banking = scriptCheck(bankingScripts) or 'none' 

-- ──────────────────────────────────────────────────────────────────────────────
-- Garage Script                                                               
-- (Information) ► Manual selection of external garage script integration.
-- ──────────────────────────────────────────────────────────────────────────────

Config.GarageScript = "op-garages" -- op-garages / jg-advancedgarages 

-- ──────────────────────────────────────────────────────────────────────────────
-- Jobs Configuration                                                          
-- (Information) ► Defines which jobs can access the MDT.
-- (Information) ► Each job has its own separated tablet and data.
-- (Information) ► This is NOT a multi-job tablet – each job must be defined separately.
-- (Information) ► Key = job name | Value = job display label.
-- ──────────────────────────────────────────────────────────────────────────────
Config.Jobs = {
    ["ambulance"] = "Emergency Medical Services",
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Commands Configuration                                                       
-- (Information) ► Enables or disables available MDT-related commands.
-- (Information) ► Commands are optional and can be fully disabled.
-- (Information) ► Command names must be unique and not conflict with other scripts.
-- ──────────────────────────────────────────────────────────────────────────────
Config.Commands = {
    openMDT = {
        enable = true, 
        command = "ambulancemdt"
    },
    adjustdispatch = {
        enable = true, 
        command = "adjustdispatch"
    },
    toggleDispatch = {
        enable = true, 
        command = "toggledispatch"
    }
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Vehicle Shop Configuration                                                   
-- (Information) ► Defines vehicles available for purchase via MDT.
-- (Information) ► Vehicles are assigned per job.
-- (Information) ► Prices, resale value and preview images are configurable.
-- (Information) ► Vehicle models must exist in the server files.
-- ──────────────────────────────────────────────────────────────────────────────
Config.VehicleShop = {
    ["ambulance"] = {
        {
            label = "Ambulance",
            model = "ambulance",
            price = 95000,
            image = "https://docs.fivem.net/vehicles/ambulance.webp",
            resellPrice = 8500,
        },
        {
            label = "Lifeguard",
            model = "lguard",
            price = 120000,
            image = "https://docs.fivem.net/vehicles/lguard.webp",
            resellPrice = 100000,
        },
    }
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Insurance System Configuration                                               
-- (Information) ► Controls the insurance system used by MDT.
-- (Information) ► Players can extend insurance for a selected time period.
-- (Information) ► Insurance time is stored in UTC ISO format.
-- ──────────────────────────────────────────────────────────────────────────────
Config.Insurance = {

    -- ──────────────────────────────────────────────────────────────────────────
    -- Insurance Extend Options                                                   
    -- (Information) ► Available insurance extension plans.
    -- (Information) ► Key does not matter, value.value defines duration.
    -- (Information) ► Time value is defined in HOURS.
    -- (Information) ► Price is charged from selected payment method.
    -- ──────────────────────────────────────────────────────────────────────────
    ExtendOptions = {
        [24] = {
            value = 24, -- Time in hours
            price = 5500
        },
        [72] = {
            value = 72, -- Time in hours
            price = 9500
        },
        [144] = {
            value = 144, -- Time in hours
            price = 14500
        },
    },

    -- ──────────────────────────────────────────────────────────────────────────
    -- Insurance Ped Configuration                                                
    -- (Information) ► Defines NPC used to access insurance features.
    -- (Information) ► NPC can be interacted with via target or marker.
    -- (Information) ► Ped animation and prop are fully configurable.
    -- ──────────────────────────────────────────────────────────────────────────
    InsurancePed = {
        ped_coords = vec4(340.8385, -1398.8954, 31.5093, 71.7369),
        ped_model = "s_m_m_paramedic_01",
        ped_gender = "male",

        ped_animation = false,
        --ped_animation = {
        --    Dict = "missheistdockssetup1clipboard@base",
        --    Lib  = "base",
        --    Prop = {
        --        Prop = 'prop_notepad_01',
        --        PropBone = 18905,
        --        PropPlacement = {
        --            0.1,
        --            0.02,
        --            0.05,
        --            10.0,
        --            0.0,
        --            0.0
        --        }
        --    }
        --},

        enable = true,

        -- Marker settings (used only when target system is disabled)
        markerColor = {
            r = 219,
            g = 0,
            b = 0,
        },

        -- Map blip configuration
        ped_blip = {
            BlipScale = 0.8, 
            blipId = 51,
            blipColor = 7
        }
    },

    -- ──────────────────────────────────────────────────────────────────────────
    -- Insurance Command Configuration                                            
    -- (Information) ► Optional command to open insurance menu.
    -- (Information) ► Useful when NPC is disabled or for quick access.
    -- ──────────────────────────────────────────────────────────────────────────
    InsuranceCommand = {
        enable = false,
        command = "myinsurance"
    }
}

Config.TabletAnimation = {
    enable = true,
    dict = "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a",
    name = "idle_a",
    prop = { -- Replace prop table with false (prop = false) if you want to disable it!
        Prop = "prop_cs_tablet",
        PropBone = 28422,
        PropPlacement = {
            -0.05,
            0.0,
            0.0,
            0.0,
            -90.0,
            0.0
        }
    }
}

Config.DispatchKeybinds = {
    next_call = "RIGHT",
    prev_call = "LEFT",
    accept_call = "U"

    -- WARNING!
    -- If you already joined on server, changing those settings will apply only for new Players!
    -- You need to change keybind for your self in Keybinds settings in FiveM!
    
    -- List of avaialbe keys:
    -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Dispatch Map Blips (GTA pause-map / minimap)                                 
-- (Information) ► Shows real GTA map blips for active dispatch alerts.
-- (Information) ► Blips are visible only to on-duty job employees who receive alerts.
-- (Information) ► Sprite/color list: https://docs.fivem.net/docs/game-references/blips/
-- ──────────────────────────────────────────────────────────────────────────────
Config.DispatchMapBlips = {
    enable = true,              -- false = disable GTA map blips for dispatch calls
    BlipScale = 0.9,
    blipId = 61,                -- 61 = hospital
    shortRange = false,         -- false = visible on full map, true = only nearby
    showForAccepted = true,     -- keep blip after call was accepted
    colors = {
        pending = 1,            -- red
        accepted = 2,           -- green
    },
    -- Blip label on the map. Placeholders: {id}, {header}
    label = "EMS: {id}",
}