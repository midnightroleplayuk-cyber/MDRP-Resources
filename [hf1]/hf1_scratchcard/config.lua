Config = {}

Config.PropModel = `v_ret_247_lotterysign`
Config.ItemName = 'scratchcard'
Config.CardPrice = 250

-- Purchase security. Set to 0 to disable. This is a rolling real-world 24-hour window,
-- persisted to disk, so reconnecting or restarting the resource does not reset it.
Config.MaximumScratchcardsPer24Hours = 5
Config.PurchaseLimitWindowSeconds = 24 * 60 * 60
Config.PurchaseLimitFile = 'purchase_limits.json'
Config.PurchaseLimitMessage = 'Sorry, we are out of stock, please visit tomorrow.'
Config.PaymentAccount = 'cash'
Config.PayoutAccount = 'bank' -- Recommended with LGMods_Banking/Qbox.
Config.TargetDistance = 2.0
Config.PlaceDistance = 2.0
Config.ClaimDistance = 3.0 -- server-side anti-event-abuse distance check

Config.AllowedIdentifiers = {
    'license:9644ec5d883ebf65f1e18006ce3ee478e07f6cee', --HardyF1
    'license:21cb933ca3b23ddf81816dda68e35afcb7ca576c', --Kapper
}

Config.ManagerAce = 'scratchcards.manage'

-- Chance that the MAIN 3-match game is a winner. 0.10 = 10% of cards.
-- Prize weights below are conditional on the main game being a winner.
Config.WinChance = 0.10

-- Maximum main-game prize. The bonus is allowed on top of this amount.
Config.MaximumWin = 10000
Config.MaximumTotalWin = 12000

-- Main-game prize distribution among winning main games.
-- £10 + £50 = 40% combined, £100/£250/£500 = 15% combined,
-- and the £10,000 grand prize is 2% of main-game wins.
Config.Prizes = {
    { amount = 10,    weight = 20 },
    { amount = 50,    weight = 20 },
    { amount = 100,   weight = 5 },
    { amount = 250,   weight = 5 },
    { amount = 500,   weight = 5 },
    { amount = 1000,  weight = 18 },
    { amount = 2500,  weight = 12 },
    { amount = 5000,  weight = 13 },
    { amount = 10000, weight = 2 },
}

-- The bonus game is rolled independently from the main game. Revealing the crossed fingers icon
-- adds this amount to whatever was won in the 3-match game (including £0).
Config.BonusWinShare = 0.18
Config.BonusPrize = 2000
Config.BonusSymbol = '👑'
Config.LosingBonusSymbols = { 'ruby.png', 'goldkey.png', 'necklace.png', 'pocketwatch.png', 'goldcup.png', 'bag.png', 'vault.png', 'camera.png', 'cloud.png', 'phone.png' }
Config.DisplayAmounts = { 10, 20, 50, 100, 200, 250, 500, 1000, 2500, 5000, 10000 }

-- LGMods_Banking on Qbox uses the player's framework bank balance, so bank payouts
-- are made through qbx_core. This keeps the money visible to LGMods_Banking while
-- avoiding reliance on undocumented/private LGMods exports.
Config.Banking = 'auto' -- 'auto', 'qbox', or 'lgmods'

-- Stand persistence is database-backed. The table is created automatically via oxmysql.
Config.PersistStands = true
Config.StandTable = 'hf1_scratchcard_stands'
Config.ManageStandDistance = 4.0
-- Legacy JSON setting retained only for compatibility; new/updated stands use the database.
Config.PersistenceFile = 'stands.json'

-- Optional Discord webhook logging. Leave Enabled = false or Webhook = '' to disable.
Config.DiscordLogging = {
    Enabled = false,
    Webhook = '',
    Username = 'HF1 Scratchcards',
    AvatarUrl = '',
    LogPurchases = true,
    LogWins = true,
    LogLosingClaims = true,
    LogStandChanges = true,

    -- Optional high-value win alert. Put the Discord ROLE ID here (not a user ID).
    -- Example: Threshold = 2000 means wins of £2,000 or more will ping the role.
    HighValueWinPing = {
        Enabled = true,
        Threshold = 2000,
        RoleId = '',
    },
}

-- Maximum distance from the manager while interactively positioning a new stand.
Config.PlacementMaxDistance = 12.0
