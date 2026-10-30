-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/phone/17mov_Phone (server) — server-side push + number lookup.
--
-- Registration and the app itself are CLIENT-side on this phone (see the client
-- half), so all that's left here is the server contract every phone shares:
-- PhoneAppNotify and PhoneAppNumber.
-- ─────────────────────────────────────────────────────────────────────────────
local RESOURCE = "17mov_Phone"

if GetResourceState(RESOURCE) == "missing" then return end   -- presence, not readiness
if not PhoneBridgeClaim(RESOURCE) then return end

-- 17mov's notification API (`CreateNotification`) is CLIENT-ONLY. Rather than
-- guess at a server export that isn't documented, the push hops to our own client
-- bridge, which calls the real one. One extra event, and it cannot silently fail
-- the way a wrong export name would.
function PhoneAppNotify(src, title, content, _thumbnail)
    TriggerClientEvent("pickle_restaurants:17mov:notify", src, title, content)
end

-- Authoritative here: the client bridge returns nil and modules/sales falls back
-- to this. `GetNumberFromPlayer(src)` answers with the player's ACTIVE number,
-- which is the one an order should be called back on.
function PhoneAppNumber(src)
    local ok, num = pcall(function() return exports[RESOURCE]:GetNumberFromPlayer(src) end)
    if ok and num then return tostring(num) end
    return nil
end
