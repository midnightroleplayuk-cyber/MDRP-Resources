if Sky.Config.notification ~= "cp_notify" then return end

local RESOURCE = "cp_notify"

-- Provider-specific defaults; Sky's notification signature has no author or sound argument.
local author = ""
local sound = true
local icons = {
    info = "fa-solid fa-circle-info",
    success = "fa-solid fa-circle-check",
    error = "fa-solid fa-circle-xmark",
    warning = "fa-solid fa-triangle-exclamation",
}

function Sky.Functions.ShowNotification(title, message, type, time)
    if type == "warn" then type = "warning" end
    if type == "inform" then type = "info" end
    type = type or "info"
    exports[RESOURCE]:Notify(title or "", message or "", type, author, icons[type] or icons.info, time or 5000, sound)
end
