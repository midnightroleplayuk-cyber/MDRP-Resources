if Sky.Config.notification ~= "okokNotify" then return end

local RESOURCE = "okokNotify"

function Sky.Functions.ShowNotification(title, message, type, time)
    if type == "warn" then type = "warning" end
    exports[RESOURCE]:Alert(title or "", message or "", time or 5000, type or "info")
end
