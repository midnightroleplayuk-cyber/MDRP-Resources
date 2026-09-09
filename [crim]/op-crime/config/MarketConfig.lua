-- ──────────────────────────────────────────────────────────────────────────────
-- 🧩 CRIME TABLET - MARKET CONFIGURATION
-- ──────────────────────────────────────────────────────────────────────────────
-- Description:
-- This config controls the Market tab inside the Crime Tablet.
-- Players can list and purchase illegal items such as weapons, drugs,
-- and special equipment through a marketplace system.
-- ──────────────────────────────────────────────────────────────────────────────

-- ⚙️ GENERAL MARKET SETTINGS
Config.MarketMisc = {
    enable = true, -- Enable / Disable the Market tab
    requiredGangLevel = 0, -- Minimum gang level required to access the Market
    useDirtyMoney = false, -- If true, transactions use dirty money instead of regular cash
    advertiseFee = 5000, -- Cost to create a new market listing

    -- Set this to your inventory url to save memory!
    -- Example for ox_inventory:
    -- nui://ox_inventory/web/images/
    -- only .png supported!

    itemImagesUrl = "nui://op-crime/web/build/items/",
}

-- 📦 ALLOWED MARKET ITEMS
-- Only items listed here can be sold through the Market

-- 🎨 ITEM CLASSES (itemclass)
-- blue   -> common items
-- purple -> uncommon 
-- red    -> illegal 
-- gold   -> rare 

-- THOSE ITEMS ARE EXAMPLES!
-- To display images properly place them inside: `web/build/items` with the same name as item and in .png extension.

Config.MarketItems = {
    ['spy_binoculars'] = {
        label = "Tactical Binoculars",
        itemclass = "purple",
    },
    ['spy_gps'] = {
        label = "GPS Tracker",
        itemclass = "purple",
    },
    ['spy_cam'] = {
        label = "Hidden Camera",
        itemclass = "red",
    },
    ['spy_motionsensor'] = {
        label = "Motion Sensor",
        itemclass = "blue",
    },
    ['spy_cam_terminal'] = {
        label = "Camera Terminal",
        itemclass = "red",
    },
    ['spy_detector'] = {
        label = "Signal Detector",
        itemclass = "purple",
    },
    ['WEAPON_VINTAGEPISTOL'] = {
        label = "Vintage Pistol",
        itemclass = "red",
    },
    ['WEAPON_SNSPISTOL_MK2'] = {
        label = "SNS Pistol MK2",
        itemclass = "red",
    },
    ['cocaine'] = {
        label = "Cocaine",
        itemclass = "purple",
    },
    ['meth'] = {
        label = "Meth",
        itemclass = "purple",
    },
    ['weed'] = {
        label = "Weed",
        itemclass = "purple",
    },
    ['rope'] = {
        label = "Rope",
        itemclass = "red",
    },
    ['spray_can'] = {
        label = "Spray Can",
        itemclass = "blue",
    },
    ['spray_remover'] = {
        label = "Spray Remover",
        itemclass = "purple",
    },

    ['ammo-9'] = {
        label = "AMMO 9MM",
        itemclass = "purple",
    },
}