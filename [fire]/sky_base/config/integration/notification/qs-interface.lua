if Sky.Config.notification ~= "qs-interface" then return end

local RESOURCE = "qs-interface"

-- AddNotify accepts an icon instead of a notification type.
local icons = {
    info = "fa-solid fa-circle-info",
    inform = "fa-solid fa-circle-info",
    success = "fa-solid fa-circle-check",
    error = "fa-solid fa-circle-xmark",
    warning = "fa-solid fa-triangle-exclamation",
    warn = "fa-solid fa-triangle-exclamation",
}

function Sky.Functions.ShowNotification(title, message, type, time)
    exports[RESOURCE]:AddNotify(message or "", title or "", time or 5000, icons[type] or icons.info)
end
