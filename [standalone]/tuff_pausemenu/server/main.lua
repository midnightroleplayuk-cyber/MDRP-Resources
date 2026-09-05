local resourceName = GetCurrentResourceName()

RegisterNetEvent(resourceName .. ":server:disconnect", function()
    local src = source
    local reason = (Strings and Strings.Notifications and Strings.Notifications.DisconnectReason) or "Disconnected."

    DropPlayer(src, reason)
end)
