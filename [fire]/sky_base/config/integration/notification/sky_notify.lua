if Sky.Config.notification ~= "sky_notify" then return end

local RESOURCE = "sky_notify"

function Sky.Functions.ShowNotification(title, message, type, time)
    exports[RESOURCE]:show(title, message, type, time)
end
