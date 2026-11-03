-- Make sure to follow the laptop installation steps before using this or any other laptop app:
-- Make sure to follow the laptop installation steps before using this or any other laptop app:
-- https://docs.av-scripts.com/laptop-pack/av-laptop/installation

Config = {}
Config.Debug = false
Config.App = {
    name = "cupcake",
    label = "Cupcake Swap",
    isEnabled = function(serial)
        return true
    end
}

function dbug(...)
    if Config.Debug then print ('^3[DEBUG]^7', ...) end
end

Config.AvailableCryptos = {
    {
        name = "cosmo",          -- How your account is named in your framework
        label = "CSMO",          -- How the player will see the account in app, max 4 characters
        buy = 20,                -- Price 1x crypto = 20 of buyAccount money
        sell = 15,               -- Price 1x crypto = 15 of buyAccount money
        canBuy = true,           -- Can players buy it from cupcake app?
        canTransfer = true,      -- Can players transfer it using cupcake app?
        canSell = true,          -- Can players sell it using cupcake app?
        buyAccount = "bank",     -- Account used to buy crypto
        buyAccountLabel = "USD", -- The account label
        sellAccount = "bank",    -- Account used to receive your funds after selling this crypto
        sellAccountLabel = "USD" -- The account label
    },
    -- This is just an example for a different crypto
    -- {
    --     name = "gne",           -- How your account is named in your framework
    --     label = "GNE",             -- How the player will see the account in app, max 4 characters
    --     buy = 20,                  -- Price 1x crypto = 20 of buyAccount money
    --     sell = 15,                 -- Price 1x crypto = 15 of buyAccount money
    --     canBuy = false,            -- Can players buy it from cupcake app?
    --     canTransfer = true,        -- Can players transfer it using cupcake app?
    --     canSell = true,            -- Can players sell it using cupcake app?
    --     buyAccount = "cosmo",      -- Account used to buy crypto
    --     buyAccountLabel = "CSMO", -- The account label
    --     sellAccount = "cosmo",      -- Account used to receive your funds after selling this crypto
    --     sellAccountLabel = "CSMO"   -- The account label
    -- },
}
