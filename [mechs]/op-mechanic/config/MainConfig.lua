-- ──────────────────────────────────────────────────────────────────────────────
-- Dependency Check Helper
-- ──────────────────────────────────────────────────────────────────────────────
function scriptCheck(data)
    for k, v in pairs(data) do
        if GetResourceState(k):find('started') ~= nil then
            return v
        end
    end
    return false
end

-- ──────────────────────────────────────────────────────────────────────────────
--  OTHERPLANET / OP Mechanic / Main CONFIGURATION
-- ──────────────────────────────────────────────────────────────────────────────

Config = Config or {}

-- ──────────────────────────────────────────────────────────────────────────────
-- Locale & Debug
-- ──────────────────────────────────────────────────────────────────────────────
Config.Locale = 'en' -- See available languages in locales/*.json
Config.Debug = true

-- ──────────────────────────────────────────────────────────────────────────────
-- Framework Detection
-- ──────────────────────────────────────────────────────────────────────────────
local frameworks = {
    ['es_extended'] = 'esx',
    ['qb-core'] = 'qb',
}

if GetResourceState('qbx_core'):find('started') ~= nil then
    Config.Framework = 'qbox'
else
    Config.Framework = scriptCheck(frameworks) or 'standalone'
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Inventory System Detection
-- ──────────────────────────────────────────────────────────────────────────────
local inventoryScripts = {
    ['ox_inventory'] = 'ox_inventory',
    ['qb-inventory'] = 'qb-inventory',
    ['codem-inventory'] = 'codem-inventory',
    ['tgiann-inventory'] = 'tgiann_inventory',
    ['origen_inventory'] = 'origen_inventory',
    ['one_inventory'] = 'one_inventory',
}

Config.Inventory = {
    inventoryScript = scriptCheck(inventoryScripts) or 'none',
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Banking / Society Detection
-- When none of these are started, society money is stored in opm_society_balances.
-- ──────────────────────────────────────────────────────────────────────────────
local bankingScripts = {
    ['esx_addonaccount'] = 'esx_addonaccount',
    ['qb-banking'] = 'qb-banking',
    ['fd_banking'] = 'fd_banking',
    ['okokBanking'] = 'okokBanking',
    ['Renewed-Banking'] = 'Renewed-Banking',
    ['tgg-banking'] = 'tgg-banking',
    ['p_banking'] = 'p_banking',
}
Config.Banking = 'LGMods_Banking'

-- ──────────────────────────────────────────────────────────────────────────────
-- Garage Script Detection
-- ──────────────────────────────────────────────────────────────────────────────
local garageScripts = {
    ['op-garages'] = 'op-garages',
    ['jg-advancedgarages'] = 'jg-advancedgarages',
}
Config.GarageScript = scriptCheck(garageScripts) or 'none'

-- ──────────────────────────────────────────────────────────────────────────────
-- Target / TextUI Detection
-- ──────────────────────────────────────────────────────────────────────────────
local targets = {
    ['ox_target'] = 'ox-target',
    ['qb-target'] = 'qb-target',
}
Config.Target = scriptCheck(targets) or 'none'

local textUIScripts = {
    ['ox_lib'] = 'ox_lib',
    ['jg-textui'] = 'jg-textui',
    ['okokTextUI'] = 'okokTextUI',
    ['brutal_textui'] = 'brutal_textui',
    ['0r-textui'] = '0r-textui',
}
Config.TextUI = scriptCheck(textUIScripts) or 'none'

-- ──────────────────────────────────────────────────────────────────────────────
-- Progress bar
-- ──────────────────────────────────────────────────────────────────────────────
local progressScripts = {
    ['ox_lib'] = 'ox_lib',
}
Config.ProgressBar = scriptCheck(progressScripts) or 'ox_lib'

-- ──────────────────────────────────────────────────────────────────────────────
-- Notifications
-- ──────────────────────────────────────────────────────────────────────────────
local notifyScripts = {
    ['op-hud'] = 'op_hud',
    ['okokNotify'] = 'okokNotify',
    ['vms_notify'] = 'vms_notify',
    ['ox_lib'] = 'ox_lib',
    ['brutal_notify'] = 'brutal_notify',
}
Config.Notify = 'ox_lib'

-- ──────────────────────────────────────────────────────────────────────────────
-- Admin Panel Permissions
-- ──────────────────────────────────────────────────────────────────────────────
Config.AdminPanelPlayers = {
    -- ['license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'] = true,
}

Config.RanksPermissions = {
    AdminPanelPlayers = {
        ['esx'] = { 'superadmin', 'admin', 'mod' },
        ['qbcore'] = { 'god', 'admin' },
        ['qbox'] = { 'god', 'admin' },
    },
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Currency Formatting
-- ──────────────────────────────────────────────────────────────────────────────
Config.Currency = {
    symbol = '£',
    position = 'before', -- before | after
    decimals = 0,
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Labor discount by mechanic grade
-- ──────────────────────────────────────────────────────────────────────────────
Config.LaborDiscountByGrade = {
    [0] = 1.0,
    [1] = 0.95,
    [2] = 0.90,
    [3] = 0.85,
    [4] = 0.80,
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Commands
-- ──────────────────────────────────────────────────────────────────────────────
Config.Commands = {
    openTablet = {
        enable = true,
        command = 'mechtablet',
    },
    pendingInvoices = {
        enable = true,
        command = 'pendinginvoices',
    },
    mechanicDispatch = {
        enable = true,
        command = 'mechanicdispatch',
        cooldown = 60, -- seconds per player
    },
    adjustdispatch = {
        enable = true,
        command = 'adjustdispatch',
    },
    toggleDispatch = {
        enable = true,
        command = 'toggledispatch',
    },
    giveAllItems = {
        enable = true,
        command = 'opmitems',
        amount = 5, -- requires Config.Debug + admin perm
    },
    adminTuning = {
        enable = true,
        command = 'openadmintuning',
    },
}

Config.DispatchKeybinds = {
    next_call = 'RIGHT',
    prev_call = 'LEFT',
    accept_call = 'U',
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Tuning
-- ──────────────────────────────────────────────────────────────────────────────
Config.Tuning = {
    maxDistance = 5.0, -- free-cam wander limit from vehicle
    freePreview = true,
    autoRestoreOnClose = true,
    autoRestoreOnDisconnect = true,
    allowEmptyCartConfirm = false,
    sessionTimeoutMs = 15 * 60 * 1000,
    requireJob = false,
    taxRate = 0.0,
}

Config.SelfService = {
    allowedCategories = {
        'repair',
    },
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Player repair kit 
-- ──────────────────────────────────────────────────────────────────────────────
Config.RepairKit = {
    enabled = true,
    item = 'repair_kit',
    removeOnUse = true,
    repair = 'engine_body', -- engine + body (keeps dirt)
    point = 'front',
    scanDistance = 6.0,
    interactDistance = 2.25,
    minigame = 'bolts',
    progressMs = 4000,
    progressCanCancel = true,
    preset = 'repair_body', -- anim from Config.TaskPresets
}

Config.Keys = {
    rotateModifier = 'MOUSE',
    zoomModifier = 'SCROLL',
    cancel = 'ESCAPE',
}

Config.SwitchHud = function(toggle)
    if toggle then
        TriggerEvent('op-hud:toggleHud', true)
    else
        TriggerEvent('op-hud:toggleHud', false)
    end
end