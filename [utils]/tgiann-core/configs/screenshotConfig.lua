configCore.screenshot = {
    ---@see https://docs.tgiann.com/main/how-can-i-use-fivemanage
    ---@see https://refer.fivemanage.com/tgiann
    fivemanage     = {
        active = false, -- Set to true to enable fivemanage
        api = '',       -- Fivemmanage API Key
    },

    ---@see https://nonefivem.com/#cloud
    nonefivem      = {
        active = false,         -- Set to true to enable nonefivem screenshot upload
        scriptName = 'nocloud', -- nocloud script name, change if you are using a custom version of nocloud or if the resource name is different
    },

    -- if favemanage is active this will be ignored
    -- If image webhook urls are set in other tgiann-scripts, this value is not used
    discordWebhook = ""
}
