-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/phone/qs-smartphone (server) — notifications + number lookup.
--
-- Registration is CLIENT-only on current Quasar (see docs "Custom app (iframe)").
-- This half only owns the server contract: PhoneAppNotify / PhoneAppNumber.
-- ─────────────────────────────────────────────────────────────────────────────
local QS_RESOURCES = { "qs-smartphone", "qs-smartphone-pro" }

local RESOURCE
for _, res in ipairs(QS_RESOURCES) do
    if GetResourceState(res) ~= "missing" then RESOURCE = res break end
end
if not RESOURCE then return end
if not PhoneBridgeClaim(RESOURCE) then return end

QSPhoneResource = RESOURCE

function PhoneAppNotify(src, title, content, thumbnail)
    -- Prefer the scoped API from current docs; fall back to the older (src, data) form.
    local data = {
        appId = PhoneAppMeta.id,
        title = title,
        text  = content,
        image = thumbnail,
    }
    local ok = pcall(function()
        local scopeId = exports[RESOURCE]:getPhoneScopeIdentifier(src)
        if scopeId then
            exports[RESOURCE]:sendPhoneNotificationToScope(scopeId, data)
            return
        end
        error("no scope")
    end)
    if not ok then
        pcall(function() exports[RESOURCE]:sendPhoneNotification(src, data) end)
    end
end

function PhoneAppNumber(src)
    local ok, num = pcall(function() return exports[RESOURCE]:GetCurrentPhoneNumber(src) end)
    if ok and num then return num end
    return nil
end
