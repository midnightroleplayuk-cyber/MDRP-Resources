Config = Config or {}
-- Supplies general settings
Config.SuppliesBlip = {
    sprite = 478,
    color = 3,
    label = "Supplies"
}
Config.SuppliesLocations = {
    {model = `mp_m_shopkeep_01`, x = 526.1072, y = -1655.1650, z = 29.3594, heading = 47.4738},
    {model = `mp_m_shopkeep_01`, x = 92.3224, y = 6359.4932, z = 31.3759, heading = 21.1605},
}
Config.SuppliesStash = { -- Stash used to pickup ingredients after purchase
    prefix = "supplies", -- stash name prefix / supplies stash is a mix of prefix + job name (e.g. suppliesuwucafe, suppliespolice, suppliesburgershot)
    label = "Supplies",
    slots = 100,
    weight = 100000
}
Config.MaxSupplies = 100 -- Max amount of items player can buy from the same ingredient