Config = {}
Config.Debug = false -- Enable debug mode
Config.AdminGroups = {"group.admin", "group.god"} -- List of admin groups
Config.AdminCommand = "admin:mail" -- Command to open the admin mail menu
Config.MaxAccountsPerPlayer = 5 -- Maximum number of accounts per player
Config.DefaultDomain = "avscripts.com" -- Free domain available to everyone on signup
Config.PaymentAccount = "bank" -- Account used to pay for custom domains
Config.DomainPrice = 50000 -- Fixed price for any custom domain
Config.AllowPlayerDomains = true -- Allow players to buy custom domains, player still needs to be whitelisted for this to work
Config.MaxAttachments = 5 -- Max attachments per email
Config.MaxRecipients = 5 -- Max recipients per email
Config.MaxSubjectLength = 120 -- Max characters for a subject
Config.MaxBodyLength = 2000 -- Max characters for a body (server truncates; UI enforces + shows counter)
Config.MessageLifetimeDays = 7 -- Days an email lives before it is auto-deleted on script start (0 = never delete)

-- Inline body images and profile photos are only allowed from these hosts for security reasons.
-- I highly recommend you use https://fivemanage.com/
Config.MaxBodyImages = 5 -- Max inline images allowed per email body
Config.Hostings = {
    "fivemanage", "i.fmfile.com",
}

-- Username rules for signup (local part before @)
Config.UsernamePattern = "^[a-z0-9%._%-]+$" -- allowed chars (already lowercased)
Config.MinUsernameLength = 3
Config.MaxUsernameLength = 24
Config.MaxDisplayNameLength = 24
Config.MinPasswordLength = 4

Config.App = {
    name = "mail",
    label = "Mail", -- You can rename the app by editing this field
    isEnabled = function(serial)
        return true
    end
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end

function warn(...)
    print ('^1[WARNING]^7', ...)
end
