Config = Config or {}
Config.CashierCommission = 10 -- Cashier will receive a % of the sell or false 
Config.PaymentMethods = { -- Available payment methods for cashier
    {value = "bank", label = "Bank"},
--    {value = "cash", label = "Cash"}, -- used in qb-core/qbox
--    {value = "money", label = "Cash"}, -- used in esx
}