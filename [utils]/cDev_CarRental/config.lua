--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║                        cDev Car Rental — config                          ║
    ║  Edit values here only. Locales: locales/*.lua  |  Install: install/   ║
    ╚══════════════════════════════════════════════════════════════════════════╝
]]

Config = {}

--============================================================================--
-- 1. CORE                                                                 --
--============================================================================--

--- Framework: player data & money
---@type 'esx'|'qb'|'qbox'
Config.Framework = 'esx'

--- Third-eye / target on rental NPC
---@type 'ox_target'|'qb-target'
Config.TargetSystem = 'ox_target'

--- Inventory for rental papers item
---@type 'ox_inventory'|'qb-inventory'
Config.InventorySystem = 'ox_inventory'

--- UI & console debug
Config.Debug = false

--============================================================================--
-- 2. LOCALIZATION & UI                                                     --
--============================================================================--

--- Language file key (must match a file in locales/, e.g. locales/en.lua)
--- Supported: en, es, de, fr, it, pt, nl, pl, ru, ja, zh-cn, ko, tr, sv, no, da, hi, uk
Config.Locale = 'en'

--- Shown in rental UI for prices
Config.CurrencySymbol = '$'

--============================================================================--
-- 3. RENTAL PRICING & LIMITS                                               --
--============================================================================--

Config.MinRentalHours = 1
Config.MaxRentalHours = 24
Config.DefaultRentalHours = 1

--- Max concurrent rentals per player (server-side)
Config.EnableRentalLimit = true
Config.MaxRentalsPerPlayer = 1

--- Player must complete the signature step in the UI before the vehicle spawns
Config.RequireSignatureBeforeRental = true

--============================================================================--
-- 4. TEST DRIVE                                                            --
--============================================================================--

--- Real-time seconds (default 30)
Config.TestDriveDuration = 30

--- If true, leaving the vehicle ends the test drive immediately (teleport back + delete)
Config.TestDriveEndOnExit = true

--- Teleport player to rental NPC when test drive ends (time or exit)
Config.TestDriveTeleportToPed = true

--============================================================================--
-- 5. VEHICLE KEYS                                                          --
--============================================================================--

--- Give keys when a rental is approved (not used for test drives here)
Config.GiveKeys = true

--- Keys integration. Pick one that matches your server.
---| Option               | Notes                                      |
---|----------------------|--------------------------------------------|
---| 'wasabi_carlock'     | exports.wasabi_carlock:GiveKey(plate)      |
---| 'mrnewbvehiclekeys'  | exports.MrNewbVehicleKeys:GiveKeys(vehicle) |
---| 'qb-vehiclekeys'     | vehiclekeys:client:SetOwner                |
---| 'qs-vehiclekeys'     | qs-vehiclekeys:client:GiveKeys             |
---| 'cd_garage'          | cd_garage:AddKeys                          |
---| 'okokGarage'         | okokGarage:GiveKeys                        |
---| 'jaksam'             | vehicle:keys:store                         |
---| 'mk_vehiclekeys'     | exports['mk_vehiclekeys']:AddKey           |
---| 'vehicles_keys'      | vehicles_keys:selfGiveVehicleKeys          |
---| 'F_RealCarKeysSystem'| server give key event                      |
---| 'none'               | No keys given                              |
---@type string
Config.KeysScript = 'wasabi_carlock'

--============================================================================--
-- 6. RENTAL PAPERS (ITEM)                                                  --
--============================================================================--

Config.GiveRentalPapers = true
Config.RentalPapersItem = 'rental_papers'

--============================================================================--
-- 7. NOTIFICATIONS                                                         --
--============================================================================--

---@type 'ox'|'framework'
Config.NotifyStyle = 'framework'

--============================================================================--
-- 8. TARGET                                                                --
--============================================================================--

Config.TargetIcon = 'fas fa-car'
Config.TargetDistance = 2.5

--============================================================================--
-- 9. RETURN BLIP (when player has an active rental)                        --
--============================================================================--

Config.ReturnBlip = {
    enabled = true,
    sprite = 225,
    color = 3,
    scale = 0.8,
    label = 'Return Rental Vehicle',
}

--============================================================================--
-- 10. LOCATIONS                                                            --
--[[
    Per location:
      name     — Display name
      ped      — model, coords vector4, scenario, freeze, invincible, blockevents
      spawn    — vector4 for vehicle spawn
      blip     — enabled, sprite, color, scale, label
      vehicles — optional list; if omitted, uses Config.Vehicles
]]
--============================================================================--

Config.Locations = {
    {
        name = 'Downtown Rental',
        ped = {
            model = 'a_m_m_business_01',
            coords = vector4(196.6697, -846.5725, 30.8335, 14.6555),
            scenario = 'WORLD_HUMAN_STAND_MOBILE',
            freeze = true,
            invincible = true,
            blockevents = true,
        },
        spawn = vector4(198.7124, -844.4866, 30.6566, 248.7071),
        blip = {
            enabled = true,
            sprite = 225,
            color = 5,
            scale = 0.8,
            label = 'Downtown Car Rental',
        },
    },
    {
        name = 'Airport Rental',
        ped = {
            model = 'a_m_m_business_01',
            coords = vector4(-1037.0, -2738.0, 20.17, 240.0),
            scenario = 'WORLD_HUMAN_CLIPBOARD',
            freeze = true,
            invincible = true,
            blockevents = true,
        },
        spawn = vector4(-1030.0, -2730.0, 20.0, 150.0),
        blip = {
            enabled = true,
            sprite = 225,
            color = 5,
            scale = 0.8,
            label = 'Airport Car Rental',
        },
    },
}

--============================================================================--
-- 11. VEHICLE CATALOG (default for all locations without .vehicles)      --
--[[
    name, model, downpayment, pricePerHour, category
    Total = downpayment + (pricePerHour * hours)
]]
--============================================================================--

Config.Vehicles = {
    {
        name = 'Sultan RS+',
        model = 'sultan2',
        downpayment = 1500,
        pricePerHour = 50,
        category = 'sports',
    },
    {
        name = 'Landstalker XL',
        model = 'landstalker2',
        downpayment = 1500,
        pricePerHour = 50,
        category = 'SUVS',
    },
    {
        name = 'Electric Bicycle',
        model = 'inductor',
        downpayment = 50,
        pricePerHour = 25,
        category = 'bicycle',
    },
    {
        name = 'BMX',
        model = 'bmx',
        downpayment = 25,
        pricePerHour = 10,
        category = 'bicycle',
    },
}
