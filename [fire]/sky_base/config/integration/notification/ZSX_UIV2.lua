local provider = Sky.Config.notification
if provider ~= "ZSX_UIV2" and provider ~= "ZSX_UIV2_default" then return end

local RESOURCE = "ZSX_UIV2"

local icons = {
    info = "fas fa-info-circle",
    inform = "fas fa-info-circle",
    success = "fas fa-check-circle",
    error = "fas fa-times-circle",
    warning = "fas fa-exclamation-triangle",
    warn = "fas fa-exclamation-triangle",
}
local active = {}

function Sky.Functions.ShowNotification(title, message, type, time)
    title, message, time = title or "", message or "", time or 5000
    local icon = icons[type] or icons.info
    if provider == "ZSX_UIV2" then
        return exports[RESOURCE]:Notification(title, message, icon, time)
    end
    -- DefaultNotification has no duration argument. Own its documented persistent
    -- serial so Sky's duration can expire this notification independently.
    local serial = exports[RESOURCE]:DefaultNotification({
        header = { text = title, icon = icon }, text = message, persistent = true,
    })
    active[serial] = true
    if time ~= -1 then
        SetTimeout(time, function()
            if active[serial] then
                active[serial] = nil
                exports[RESOURCE]:DefaultNotification_Remove(serial)
            end
        end)
    end
    return serial
end

if provider == "ZSX_UIV2_default" then
    AddEventHandler("onResourceStop", function(resource)
        if resource ~= GetCurrentResourceName() then return end
        for serial in pairs(active) do
            active[serial] = nil
            exports[RESOURCE]:DefaultNotification_Remove(serial)
        end
    end)
end
