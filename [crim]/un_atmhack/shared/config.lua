Config = {}

Config.Debug = false
Config.Locale = 'en'

Config.Framework = 'auto' -- auto, esx, qbcore
Config.Inventory = 'auto' -- auto, framework, ox_inventory, qb-inventory, lj-inventory, ps-inventory, qs-inventory, codem-inventory
Config.Target = 'auto' -- auto, ox_target, qb-target
Config.TargetItemCheck = 'auto' -- auto, true, false
Config.Notify = 'ox' -- ox, esx, qb, okok, wasabi, brutal_notify, custom

Config.RequiredItem = 'lockpick'
Config.RemoveItemOnUse = true

Config.ATMModels = {
    'prop_fleeca_atm',
    'prop_atm_01',
    'prop_atm_02',
    'prop_atm_03'
}

Config.MinPolice = 0
Config.PoliceJobs = { 'police' }
Config.AlertPolice = false

Config.Dispatch = {
    System = 'default', -- default, ps-dispatch, cd_dispatch, qs-dispatch, core_dispatch, lb-tablet, custom, none
    BlipTime = 60,
    Code = '10-90',
    Title = 'ATM ryosto',
    Message = 'ATM-hakkerointi kaynnissa',
    Icon = 'fas fa-building-columns',
    Priority = 'medium', -- high, medium, low
    Sound = 'notification.mp3',
    LocationLabel = 'ATM-halytys'
}

Config.CooldownSeconds = 600
Config.DistanceCheck = 2.0
Config.PickupDistance = 5.0

Config.Progress = {
    StartHackMs = 2500,
    CollectCashMs = 12000,
    CollectPileRemoveDelayMs = 450
}

Config.Hacking = {
    Minigame = 'ox_lib', -- ox_lib, utk_fingerprint, ps-ui, ps-ui-circle, ps-ui-maze, ps-ui-scrambler
    PsGame = 'circle', -- circle, maze, scrambler
    OxLibDifficulty = { 'medium', 'easy', { areaSize = 60, speedMultiplier = 1 }, 'easy' },
    OxLibKeys = { 'w', 'a', 's', 'd' },
    PsCircle = { circles = 4, time = 60 },
    PsMaze = { time = 20 },
    PsScrambler = { type = 'numeric', time = 20, mirrored = 0 }
}

Config.Reward = {
    Type = 'account', -- item, account
    Item = 'cash',
    Account = 'cash', -- qbcore: cash, bank | esx: money, bank, black_money
    AmountMin = 250,
    AmountMax = 500
}

Config.CashDrop = {
    Models = {
        'prop_anim_cash_pile_01',
        'hei_prop_heist_cash_pile',
        'prop_cash_pile_01',
        'bkr_prop_bkr_cashpile_01'
    },
    PileCount = 6,
    StartForwardOffset = 0.08,
    ForwardOffset = 0.44,
    ForwardDirection = -1.0,
    SideSpacing = 0.18,
    RowSpacing = 0.16,
    HeightOffset = 1.00,
    LaunchArcHeight = 0.025,
    HeadingDrift = 6.0,
    EffectStaggerMs = 70,
    LaunchDurationMs = 180,
    TimeoutSeconds = 90
}

Config.Discord = {
    Enabled = true,
    Webhook = 'PUT YOUR WEBHOOK HERE',
    BotName = 'un atmhack',
    AvatarUrl = 'https://i.postimg.cc/yx7y82b4/Copilot_20260115_222348.png',
    Colors = {
        info = 3447003,
        success = 5763719,
        error = 15158332,
        warning = 15844367
    }
}
