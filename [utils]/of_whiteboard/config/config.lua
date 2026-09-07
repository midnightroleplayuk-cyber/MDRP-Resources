Config = Config or {}

Config.Locale    = "en"   -- config/locale/*.lua
Config.Framework = "auto" -- "qb", "qbx", "esx" or "auto" (detect the running core)
Config.Inventory = "auto" -- "ox_inventory", "qb-inventory", "qs-inventory", "codem-inventory", "origen_inventory" or "auto"
Config.Notify    = nil    -- "ox_lib" or "framework", nil to auto-detect (ox_lib, else framework)

Config.Debug = false
