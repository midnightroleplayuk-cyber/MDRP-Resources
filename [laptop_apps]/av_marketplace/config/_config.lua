-- Add your webhook in server/editable/_webhook.lua for discord logs
Config = {}
Config.Debug = false
Config.AdminLevel = {"group.admin", "group.god"} -- ACE Permission needed for admin panel
Config.AdminCommand = "admin:marketplace" -- Command used to open the admin panel
Config.MaxListingsPerPlayer = 10 -- Max listings a player can have at once or false for unlimited
Config.ExpirationDays = 15 -- Days until a listing expires and is automatically removed
Config.App = {
    name = "marketplace",
    label = "Marketplace", -- You can rename the app by editing this field
    isEnabled = function(serial)
        return true
    end
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end