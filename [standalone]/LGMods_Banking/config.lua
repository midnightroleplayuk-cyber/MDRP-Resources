Config = {}

-- Choose your framework: "esx" or "qbcore"
Config.Framework = "qbcore"

-- Inventory System
-- Options: "qb-inventory", "qs-inventory", "esx_inventory", "ox_inventory"
Config.Inventory = "ox_inventory"

Config.UseTarget = true  -- set to true to use target system, false to use proximity
Config.TargetSystem = "ox-target"  -- "qb-target" or "ox-target"


-- list the jobs that have a business account and the minimum grade required.
Config.BusinessAccounts = {
    police   = { minGrade = 4 },
    ambulance   = { minGrade = 4 },
    mechanic   = { minGrade = 4 }
}

-- Paycheck Configuration
Config.UseBuiltInPayChecks = false     -- If true, this script will handle paychecks instead of the default ESX/QBCore system
Config.UseBusinessAccountsForPaychecks = false  -- If true, withdraws payment from business accounts instead of creating money
Config.PayCheckInterval = 10           -- Interval in minutes for paychecks to be distributed

Config.sortcode = '27-08-44'

Config.Banks = {
    { name = "Legion Bank", coords = vector3(149.9084, -1040.7687, 29.3741) },
    -- Add more banks here…
}

-- interest rate cannot be a decimal number e.go 3.2, it must be whole number
Config.SavingsAccount = {
    interestRate = 3,         -- or whatever percentage you want
    interestInterval = 7200     -- in seconds (e.g., 7200 = 2 hours)
}

Config.PinResetCost = 0
Config.WebsiteLink = "https://discord.gg/RQArbRYpYj"

Config.newdebitcardcost = 250   -- cost for a new card if one already exists

Config.ATMItem = "debitcard"  -- inventory item required to use an ATM
Config.ATMProps = {
    "prop_atm_01",       
    "prop_atm_02",      
    "prop_atm_03",        
    "prop_fleeca_atm",  
    "prop_atm_01_tube",   
    "prop_atm_02_strap", 
    "prop_atm_03_pole"    
}

Config.BankPromptDistance = 2.0
Config.BankBlipSprite = 108
Config.BankBlipColour = 1  -- red

-- Invoice Menu Configuration
Config.InvoiceMenu = {
    Command = "invoices",  -- Command to open invoice menu
    Key = "F3",           -- Key to open invoice menu
    KeyDescription = "Open Invoices Menu"
}

-- Personal Loans Configuration
Config.Loans = {
    -- Credit score configuration
    CreditScore = {
        MinScore = 300,           -- Minimum possible credit score
        MaxScore = 850,           -- Maximum possible credit score
        DefaultScore = 650,       -- Default score for new players
        -- Factors affecting credit score
        DepositBonus = 1,         -- Points added per deposit (scaled by amount)
        WithdrawalPenalty = 0.5,  -- Points subtracted per withdrawal when balance is low
        LoanRepaymentBonus = 5,   -- Points added per successful loan payment
        MissedPaymentPenalty = 15 -- Points subtracted per missed payment
    },
    -- Loan terms configuration
    Terms = {
        MinAmount = 1000,         -- Minimum loan amount
        MaxAmount = 10000,        -- Maximum loan amount
        MinCreditScoreRequired = 500, -- Minimum credit score to be eligible for a loan
        InterestRates = {         -- Interest rates based on credit score brackets
            {min = 300, max = 549, rate = 15}, -- Poor credit: 15% interest
            {min = 550, max = 649, rate = 10}, -- Fair credit: 10% interest
            {min = 650, max = 749, rate = 7},  -- Good credit: 7% interest
            {min = 750, max = 850, rate = 5}   -- Excellent credit: 5% interest
        },
        PaymentPeriods = {        -- Available repayment periods
            {days = 7, label = "7 Days"},
            {days = 14, label = "14 Days"},
            {days = 30, label = "30 Days"},
            {days = 60, label = "60 Days"}
        },
        MaxActiveLoans = 5,       -- Maximum number of active loans a player can have
        EarlyRepaymentFee = 0.05  -- 5% fee for early repayment
    },
    -- Payment processing
    Payments = {
        AutomaticDeduction = true,   -- Automatically deduct payments from bank account
        PaymentInterval = 24,        -- Hours between payments (24 = daily payments)
        OverdraftAllowed = true,     -- Allow account to go negative for loan payments
        OverdraftInterest = 20,      -- Interest rate applied to negative balances
        MinCustomPayment = 10        -- Minimum amount for custom loan payments
    },
    
    -- Test Loan Configuration (for development and testing)
    TestLoan = {
        Enabled = false,              -- Set to false to disable test loan functionality
        Amount = 5000,               -- Default test loan amount
        InterestRate = 10,           -- 10% interest rate 
        Days = 1,                    -- Loan duration in days
        PaymentInterval = 1,        -- Seconds between payments (30 seconds for testing)
        Payments = 5,               -- Number of payments to divide the loan into
        Command = "testloan",        -- Command to create a test loan
        Description = "Creates a test loan with accelerated payments every 30 seconds"
    }
}

-- debug settings 
Config.ProximityCheckInterval = 500  -- ms between proximity checks
Config.ATMDistance = 1.0             -- Distance for ATM interaction
Config.CacheTimeout = 2000           -- Distance cache timeout in ms