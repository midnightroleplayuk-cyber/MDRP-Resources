Config = Config or {}

Config.Locale    = "en"   -- config/locale/*.lua
Config.Framework = "qbx" -- "qb", "qbx", "esx" or "auto" (detect the running core)
Config.Inventory = "ox_inventory" -- "ox_inventory", "qb-inventory", "qs-inventory", "codem-inventory", "origen_inventory" or "auto"
Config.Notify    = "ox_lib"    -- "ox_lib" or "framework", nil to auto-detect (ox_lib, else framework)

Config.Debug = false
