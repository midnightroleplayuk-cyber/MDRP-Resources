-- ─────────────────────────────────────────────────────────────────────────────
-- modules/locale (client) — hands the active language table to the front end.
--
-- `locales/translations/*.lua` is the ONE place user-facing copy is authored, for the
-- Lua side and the NUI alike. The React app used to bundle its own duplicate table;
-- now it asks for this one at boot (web/src/lib/locale.ts) and localizes against it.
--
-- Reachable from BOTH front ends: the fullscreen NUI and the phone app's iframe both
-- POST to this resource, so one callback serves both. The locales are shared_scripts,
-- so the table is already on the client and this needs no server round trip.
-- ─────────────────────────────────────────────────────────────────────────────

RegisterNUICallback("getLocale", function(_, cb)
    cb({ ok = true, lang = Config.Language, strings = LocaleTable() })
end)
