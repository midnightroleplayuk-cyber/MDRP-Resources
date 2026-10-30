-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/phone/gksphone (server) — server-side notification + number lookup.
--
-- Registration and the live app push are CLIENT-side on GKSPhone (see the client half
-- of this bridge), so all that's left here is the server contract shared by every
-- phone: PhoneAppNotify (server-initiated notifications) and PhoneAppNumber (the number
-- the order flow falls back to when the client hands back nil). On GKSPhone BOTH are
-- server exports, so the client half returns nil for the number and no-ops its notify.
-- ─────────────────────────────────────────────────────────────────────────────
if GetResourceState("gksphone") == "missing" then return end   -- presence, not readiness

PhoneBridgeResource = "gksphone"   -- which phone this server's bridge claimed

-- Guarded so a phone-less player never errors the callback that's notifying them.
-- GKSPhone's NotifData carries the body as `message` (lb-phone calls it `content`) and
-- takes an `icon` URL — we pass the order thumbnail when present, else the app icon.
function PhoneAppNotify(src, title, content, thumbnail)
    pcall(function()
        exports["gksphone"]:sendNotification(src, {
            title        = title,
            message      = content,
            icon         = thumbnail or PhoneAppIcon(),
            duration     = 5000,
            type         = "info",
            buttonactive = false,
        })
    end)
end

-- Server-side resolution of the equipped phone's number (GetPhoneBySource). This is the
-- authoritative path on GKSPhone: the client bridge returns nil, and modules/sales
-- falls back here when the order arrives without a number.
function PhoneAppNumber(src)
    local ok, num = pcall(function() return exports["gksphone"]:GetPhoneBySource(src) end)
    if ok and num then return num end
    return nil
end
