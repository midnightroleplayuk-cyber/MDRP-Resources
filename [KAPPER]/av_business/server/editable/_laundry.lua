-- All laundry config can be found here
Config = Config or {}
Config.DirtyMoneyItem = 'markedbills' -- Name of the dirty money item, most common are "black_money" for ESX or "markedbills" for qb-core/qbox
Config.UsesMetadata = "worth" -- string|false metadata used by DirtyMoneyItem (for qb-core/qbox markedbills), if using ESX change this option to false to use item count and not metadata
Config.VaultStash = { -- Vault stash slots and weight
    slots = 5,
    weight = 5000
}
Config.GlobalLaundryFee = 0.15 -- Global fee taken when converting dirty cash to clean (0.15 = 15%)
Config.GlobalMaxWash = 100000 -- Global washing limit per "Tsunami" (Server Restart)
-- Max legal amount PER SALE that will count towards washing
-- (Prevents a friend from paying $1,000,000 to wash everything at once)
Config.GlobalMaxPerOrder = 1000
-- LaundryAccess moved to json/settings/job_access.json (managed via admin panel)
-- Labels used for the Transactions UI in the Laundry tab
Config.ActivitiesLabels = {
    ['billing'] = "Billing",
    ['deliveries'] = "Deliveries",
    ['cashiers'] = "Front Desk",
}
-- BANK LOGS TITLE AND DESCRIPTION
Config.GlobalMessage = { -- Default title/description used for bank logs when the cleaned funds are transferred
    title = "Business",
    description = "Misc. Store Extras"
}
Config.CustomMessage = { -- Custom bank log description per business
    ['avscripts'] = {
        title = "Support",
        description = "Technical Consulting Fees"
    },
    ['uwucafe'] = {
        title = "Tips",
        description = "Daily Service Gratuities"
    },
}
--- MULTIPLIER CONFIG
Config.LaundryMultiplier = 1.0 -- Default global multiplier ($1 legal sale = $1 dirty washed)
Config.CustomLaundryMultiplier = { -- Custom multiplier per business (Businesses with cheaper items need a higher multiplier)
    ['avscripts'] = 5.0,
    ['uwucafe']   = 10.0,  -- Sells cheap coffee, needs a x10 multiplier to be viable... this is obviously an EXAMPLE
}
-- Toggle which business activities will trigger the money cleaning process.
Config.GlobalCleanActivities = {
    ['cashiers']   = true,  -- Sales made at the front desk
    ['deliveries'] = true,  -- Completed delivery missions
    ['billing']    = false, -- Customer invoices (Disabled by default)
}
-- Use this to create custom rules for specific businesses.
-- This table takes priority over the Global settings.
Config.JobCleanActivities = {
    ['avscripts'] = {
        ['cashiers']   = true,
        ['deliveries'] = true,
        ['billing']    = true, -- Special permission: This job CAN wash via billing
    },
    ['uwucafe'] = {
        ['cashiers']   = true,
        ['deliveries'] = false,
        ['billing']    = false,
    },
}
-- Custom fee per business (Overrides the global fee)
Config.CustomLaundryFee = {
    ['avscripts'] = 0.10, -- 10%
    ['uwucafe']   = 0.20, -- 20%
}
-- Custom max legal amount PER SALE that will count towards washing
Config.CustomMaxPerOrder = {
    ['avscripts'] = 1500,
    ['uwucafe']   = 2500,
}
-- Maximum washing limit per "Tsunami" (Server Restart), this overrides the GlobalMaxWash limit
-- Once this cap is reached, legal sales will no longer wash dirty money for that shift.
Config.MaxWashPerRestart = {
    ['avscripts'] = 100000,
    ['uwucafe']   = 250000,
}