-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/phone/yseries (server) — server-side push + number lookup.
--
-- Registration and the live app push are CLIENT-side on YSeries (see the client half),
-- so all that's left here is the server contract shared by every phone:
-- PhoneAppNotify and PhoneAppNumber.
-- ─────────────────────────────────────────────────────────────────────────────
local RESOURCE = "yseries"

if GetResourceState(RESOURCE) == "missing" then return end   -- presence, not readiness
if not PhoneBridgeClaim(RESOURCE) then return end

-- Guarded so a phone-less player never errors the callback that's notifying them.
-- YSeries takes (notification, toType, to) — body field is `text`, not `content`.
function PhoneAppNotify(src, title, content, thumbnail)
    local icon = thumbnail or ("nui://%s/nui/phone-icon.png"):format(GetCurrentResourceName())
    pcall(function()
        exports[RESOURCE]:SendNotification({
            app     = PhoneAppMeta.id,
            title   = title,
            text    = content,
            timeout = 5000,
            icon    = icon,
        }, "source", src)
    end)
end

-- Server-side resolution of the equipped phone's number. Authoritative on YSeries:
-- the client bridge returns nil, and modules/sales falls back here.
function PhoneAppNumber(src)
    local ok, num = pcall(function() return exports[RESOURCE]:GetPhoneNumberBySourceId(src) end)
    if ok and num then return tostring(num) end
    return nil
end
