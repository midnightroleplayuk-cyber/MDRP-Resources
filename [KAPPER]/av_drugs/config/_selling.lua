Config = Config or {}
-- You can find more config in server/editable/_sell.lua
Config.DrugMoney = "cash" -- Money received for corner selling | QB uses "cash", ESX uses "money"
Config.SellingDistance = 50.0 -- Max distance the player can be selling far from his vehicle
Config.SellingCooldown = math.random(30000,45000) -- Time in miliseconds before the script picks a random client in the streets (30 - 45 seconds)
Config.BlacklistedClasses = { -- Player can't start sell using this vehicle classes
    [7] = true, -- Super
    [8] = true, -- Motorcycles
    [10] = true, -- Industrial
    [14] = true, -- Boats, who uses boats to sell drugs?
    [15] = true, -- Helicopters... wait what?
    [18] = true, -- Emergency
    [19] = true, -- Military
}
Config.BlacklistedPeds = { --Players won't be able to sell drugs to this peds
    [`s_f_y_cop_01`] = true,
    [`s_m_m_security_01`] = true,
    [`s_m_y_cop_01`] = true,
    [`s_m_y_hwaycop_01`] = true,
}