-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/phone/lb-phone (server) — server-side push + number lookup.
-- ─────────────────────────────────────────────────────────────────────────────
if GetResourceState("lb-phone") == "missing" then return end   -- presence, not readiness

PhoneBridgeResource = "lb-phone"   -- which phone this server's bridge claimed

-- Guarded so a phone-less player never errors the callback that's notifying them.
function PhoneAppNotify(src, title, content, thumbnail)
    pcall(function()
        exports["lb-phone"]:SendNotification(src, {
            app       = PhoneAppMeta.id,
            title     = title,
            content   = content,
            thumbnail = thumbnail,
        })
    end)
end

-- Server-side fallback for the number the client normally supplies with an order.
-- Unused on lb-phone in practice (its client bridge answers first), but it keeps the
-- server contract identical across phones — Quasar can ONLY answer from here.
function PhoneAppNumber(src)
    local ok, num = pcall(function() return exports["lb-phone"]:GetEquippedPhoneNumber(src) end)
    return ok and num or nil
end
