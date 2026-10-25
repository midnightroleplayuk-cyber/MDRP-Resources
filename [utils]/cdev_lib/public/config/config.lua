PublicSharedConfig = {
    -- ⚡ Framework. Can be: esx, qbcore, custom, or "auto" to detect from running resources (qb-core, qbx_core, es_extended)
    Framework = "auto",

    -- 🗣️ Specify the language you're using. For more information on available languages visit our docs in https://docs.cdev.shop/fivem-resources/locales
    Language = "en",

    -- 👀 Target (third eye). Can be: qbcore, qtarget, ox, renewed, custom, or "auto" to detect (qb-target, ox_target, qtarget)
    Target = "ox",

    -- 🎒 Inventory. Can be: qbcore, ox, custom, or "auto" to detect (qb-inventory, ox_inventory)
    Inventory = "ox",

    -- 🗝️ Specify the vehicle key resource you're using. Can be the following: qbcore, codesign, quasar, loaf, wasabi, jaksam, custom
    VehicleKey = "qbcore",

    -- 💬 Set this to true if you want to use your own notification UI instead of the cDev one. (Implement in public/client/api.lua)
    UseCustomNotifications = false,

    -- 📦 Set this to false if you use a custom database system. (Implement in public/server/api.lua, also remove the dependency in fxmanifest.lua)
    UseMySQL = true,

    -- 📄 Enable discord logs (webhook URL in public/server/api.lua)
    DiscordLogs = false,

    -- ⚙️ Enable debug mode (prints in console)
    Debug = true,

    -- 📄 Change the DrawText font (you can check all the available fonts at the end of this link: https://wiki.rage.mp/index.php?title=Fonts_and_Colors)
    DrawTextConfig = {
        OverrideDrawtextFont = false,
        OverrideDrawtextFontId = 1
    },

    -- 💎 Enable Discord VIP System: https://docs.cdev.shop/fivem/cdev-library/vip-integration
    UseVIPSystem = false,

    -- 💎 Discord roles that will have access to VIP features when available
    VIPRoleIds = {
        "00000000000000000",
    },
}
