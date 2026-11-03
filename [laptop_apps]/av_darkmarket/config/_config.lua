-- READ THE DOCS BEFORE USING THIS SCRIPT: https://docs.av-scripts.com/
-- READ THE DOCS BEFORE USING THIS SCRIPT: https://docs.av-scripts.com/
-- READ THE DOCS BEFORE USING THIS SCRIPT: https://docs.av-scripts.com/

Config = {}
Config.Debug = false
-- dark market stash slots and weight
Config.Stash = {
    slots = 50,
    weight = 100000, -- 100kg
}
Config.App = {
    name = "darkmarket",
    label = "Dark Market", -- You can rename the app by editing this field
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