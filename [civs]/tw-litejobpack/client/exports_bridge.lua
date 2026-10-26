-- Public client exports for the notification + interaction system.
-- Other resources can call:
--   exports['tw-litejobpack']:SendNotification(text, type)
--   exports['tw-litejobpack']:SendPaymentNotification(text, type)
--   exports['tw-litejobpack']:StartInteraction()
--   exports['tw-litejobpack']:EndInteraction()
--   exports['tw-litejobpack']:DrawText3D(x, y, z, text)
--
-- Wrappers (not direct refs) so globals resolve at call time, not load time.

exports('SendNotification', function(text, notifType)
    if SendNotification then
        return SendNotification(text, notifType)
    end
end)

exports('SendPaymentNotification', function(text, notifType)
    if SendPaymentNotification then
        return SendPaymentNotification(text, notifType)
    end
end)

exports('StartInteraction', function()
    if StartInteraction then
        return StartInteraction()
    end
end)

exports('EndInteraction', function()
    if EndInteraction then
        return EndInteraction()
    end
end)

exports('DrawText3D', function(x, y, z, text)
    if DrawText3D then
        return DrawText3D(x, y, z, text)
    end
end)

exports('SetWeaponsLocked', function(locked)
    if SetWeaponsLocked then
        return SetWeaponsLocked(locked)
    end
end)

exports('IsWeaponsLocked', function()
    if IsWeaponsLocked then
        return IsWeaponsLocked()
    end
end)
