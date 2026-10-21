Config = {}

-- 'auto' detects qbx_core, qb-core or es_extended. Or force 'qbx' | 'qb' | 'esx'.
Config.Framework = 'auto'

-- Account the safe price is taken from. QB/QBox: 'cash' or 'bank'. ESX: 'money' or 'bank'.
Config.Account = 'cash'

Config.Item = 'rsvx_safe'          -- ox_inventory item name (see README)
Config.Price = 25000
Config.MaxPerPlayer = 2

Config.Model = joaat('prop_ld_int_safe_01')
Config.Slots = 50
Config.MaxWeight = 200000          -- grams

Config.PlaceDistance = 4.0         -- how far from you a safe can be placed
Config.MinDistance = 3.0           -- min gap between two safes

Config.PinAttempts = 5             -- wrong PINs before a lockout
Config.LockoutSeconds = 60

-- ACE permission that can open/pick up any safe: add_ace group.admin rsvx_safe.admin allow
Config.AdminAce = 'rsvx_safe.admin'

Config.Shop = {
    label = 'Safe Dealer',
    model = joaat('s_m_y_ammucity_01'),
    coords = vec4(1628.66, 3605.59, 35.72, 204.99),
    showBlip = false,                -- false = no map blip for the dealer
    blip = { sprite = 52, colour = 2, scale = 0.8 },
}
