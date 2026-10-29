-- ─────────────────────────────────────────────────────────────────────────────
-- bridge/phone (shared) — the companion app's identity, in ONE place
--
-- Every phone bridge registers the same app; only the export names differ. So the
-- metadata that describes it (id, name, icon, which page to load) lives here rather
-- than being copy-pasted into each variant — change the icon or the blurb once and
-- every supported phone picks it up.
--
-- APP_ID is also what the SERVER stamps on notifications, so it has to match on both
-- sides — hence shared, not client-only.
-- ─────────────────────────────────────────────────────────────────────────────

PhoneAppMeta = {
    id          = "pickle_food",
    name        = "Pickle Eats",
    developer   = "Pickle Modifications",
    size        = 48000,
}

-- Absolute URLs into THIS resource. A phone loads the app page in an iframe, so both
-- have to be reachable from the phone's own NUI origin — a relative path would
-- resolve against the phone resource, not ours.
function PhoneAppUI()
    return ("https://cfx-nui-%s/nui/phone.html"):format(GetCurrentResourceName())
end

function PhoneAppIcon()
    return ("https://cfx-nui-%s/nui/phone-icon.png"):format(GetCurrentResourceName())
end

-- The store blurb is the one piece of app metadata a player reads, so it is
-- localized. It is a FUNCTION, not a `PhoneAppMeta` field: this file is a shared
-- script and loads before `locales/locale.lua`, so `_L` does not exist yet at the
-- point the table above is built. Every caller resolves it at registration time.
function PhoneAppDescription()
    return _L("phone_app_description")
end

-- The two registration payload shapes a phone might want, in preference order.
-- Shape A is Quasar's form (label + a nested `iframe.url`); shape B is the flat form
-- the pro forks and most lb-phone-alikes take. Shared because a bridge may have to
-- try both from either side (see bridge/phone/qs-smartphone) — an unknown key is
-- ignored by every registrar we've seen, so B deliberately carries the aliases.
function PhoneAppShapes()
    return {
        {
            id          = PhoneAppMeta.id,
            label       = PhoneAppMeta.name,
            description = PhoneAppDescription(),
            developer   = PhoneAppMeta.developer,
            icon        = PhoneAppIcon(),
            iframe      = { url = PhoneAppUI() },
        },
        {
            id          = PhoneAppMeta.id,
            identifier  = PhoneAppMeta.id,
            name        = PhoneAppMeta.name,
            label       = PhoneAppMeta.name,
            description = PhoneAppDescription(),
            developer   = PhoneAppMeta.developer,
            icon        = PhoneAppIcon(),
            url         = PhoneAppUI(),
            ui          = PhoneAppUI(),
            size        = PhoneAppMeta.size,
            defaultApp  = true,
        },
    }
end

-- ─── claiming the bridge ─────────────────────────────────────────────────────
-- A server runs ONE phone, but several phone resources can sit in the resources
-- folder — an old one left behind and never started still reads as "not missing".
-- Presence is therefore not a CLAIM: a bridge stands down for an earlier claimant
-- only while that claimant's resource isn't sitting stopped. Getting this wrong is
-- silent and total (the running phone simply never gets the app), so it lives here
-- rather than being re-reasoned per bridge.
--
-- The marker differs by side because the two runtimes share no globals: the server
-- sets PhoneBridgeResource, the client sets PhoneApp.resource.
function PhoneBridgeClaim(resource)
    local server = IsDuplicityVersion()
    local held = server and PhoneBridgeResource or (PhoneApp and PhoneApp.resource)
    if held and GetResourceState(held) ~= "stopped" then return false end
    if held then
        print(("[pickle_restaurants] phone bridge: %s is stopped — using %s instead")
            :format(held, resource))
    end
    if server then
        PhoneBridgeResource = resource
    else
        PhoneApp = PhoneApp or {}
        PhoneApp.resource = resource
    end
    return true
end

-- ─── calling an export that might not exist ──────────────────────────────────
-- EVERY probe goes through here. `exports[resource][name]` RAISES ON THE INDEX
-- ("No such export sendCustomAppMessage in resource qb-phone"), not on the call — so
-- `pcall(exports[res][name], ...)` throws before pcall ever runs: the index is an
-- ARGUMENT, evaluated first, and pcall never sees it. That is what broke the qb-phone
-- push probe, and it breaks the whole design of trying candidate names in turn, since
-- a miss has to be catchable.
--
-- The index therefore happens INSIDE the protected function. Returns pcall's own
-- (ok, err-or-result), so callers read exactly as before.
function PhoneCallExport(resource, name, ...)
    local args = table.pack(...)
    return pcall(function()
        return exports[resource][name](nil, table.unpack(args, 1, args.n))
    end)
end

-- ─── runtime app registration ────────────────────────────────────────────────
-- The phones that publish no stable custom-app API (Quasar, qb-phone and their forks)
-- have moved registration between export names AND payload shapes across builds, and
-- some builds expose it on the other side entirely. A single guessed call that
-- silently does nothing is exactly the failure mode this exists to avoid: try the
-- whole matrix, report which cell won, and let the caller print the manual route when
-- none do. There is no way to ASK whether an export exists, so calling it (through
-- PhoneCallExport, which catches the missing-export raise) is the only real test.
--
-- Add a name here if your build calls it something else; that is the only edit needed.
PHONE_REGISTER_EXPORTS = {
    "addCustomApp", "AddCustomApp",
    "addApp", "AddApp",
    "registerCustomApp", "RegisterCustomApp",
    "createCustomApp",
}

function PhoneTryRegister(resource)
    local lastErr
    for _, name in ipairs(PHONE_REGISTER_EXPORTS) do
        for shape, payload in ipairs(PhoneAppShapes()) do
            local ok, err = PhoneCallExport(resource, name, payload)
            if ok then return name, shape end
            lastErr = err
        end
    end
    return nil, nil, lastErr
end

-- Everything a phone needs to know about this app, as console lines. A phone whose
-- runtime registration API we can't reach (or that has none — several expect apps to
-- be listed in their own config file) can still be set up BY HAND, and this is the
-- exact set of values to paste in. Printed when registration fails, and on demand via
-- the `pickle_phoneapp` console command, so "the app never showed up" always has an
-- answer sitting in the server log rather than needing the URLs reverse-engineered.
-- `notes` is an optional list of extra lines for the phone in question (qb-phone, for
-- one, needs more than a config entry — see its bridge).
function PrintPhoneAppInstall(reason, notes)
    -- built with inserts, not a literal: a nil in the middle of a table literal ends
    -- ipairs early, so an absent `reason` would swallow every line after it
    local lines = {
        "",
        "  ┌─ pickle_restaurants — companion app (\"" .. PhoneAppMeta.name .. "\") ─────────",
    }
    if reason then
        lines[#lines + 1] = "  │  " .. reason
        lines[#lines + 1] = "  │"
    end
    for _, l in ipairs({
        "  │  Add it to your phone by hand with these values:",
        "  │    id / identifier : " .. PhoneAppMeta.id,
        "  │    name / label    : " .. PhoneAppMeta.name,
        "  │    developer       : " .. PhoneAppMeta.developer,
        "  │    page (iframe)   : " .. PhoneAppUI(),
        "  │    icon            : " .. PhoneAppIcon(),
        "  │",
        "  │  Most phones take these in their own app config file. The page is a plain",
        "  │  iframe URL — it talks back to pickle_restaurants directly, so it works",
        "  │  whichever phone hosts it.",
    }) do lines[#lines + 1] = l end
    if notes and #notes > 0 then
        lines[#lines + 1] = "  │"
        for _, l in ipairs(notes) do lines[#lines + 1] = "  │  " .. l end
    end
    lines[#lines + 1] = "  └──────────────────────────────────────────────────────────────────────"
    lines[#lines + 1] = ""
    for _, l in ipairs(lines) do print(l) end
end

-- ─── closing the phone ────────────────────────────────────────────────────────
-- `PhoneApp.Close()` (each client bridge defines it) puts the phone away. The
-- doorstep hand-off is the caller: serving a delivery from the app means the phone is
-- open and IN THE PED'S HAND as the knock starts, and its hold/put-away animation
-- fights ours (modules/doorstep/client.lua).
--
-- Only lb-phone publishes an unambiguous close (`ToggleOpen(false)`), so the other
-- bridges hand this helper the plausible export names and the first that doesn't raise
-- wins, resolved once — the same treatment the Quasar push path gets. The attempt goes
-- through PhoneCallExport, which is what makes a missing export catchable.
--
-- Events are the LAST resort and are fired every time rather than resolved: TriggerEvent
-- succeeds whether or not anything is listening, so there is nothing to learn from it.
-- Never list a TOGGLE here — on an already-closed phone a toggle would open it.
local closeExport = {}   -- resource → export name, or false once every candidate failed

function PhoneCloseVia(resource, candidates, events)
    local resolved = closeExport[resource]
    if resolved then
        PhoneCallExport(resource, resolved)
        return true
    end
    if resolved == nil then
        for _, name in ipairs(candidates or {}) do
            if PhoneCallExport(resource, name) then
                closeExport[resource] = name
                return true
            end
        end
        closeExport[resource] = false
    end
    for _, ev in ipairs(events or {}) do TriggerEvent(ev) end
    return false
end
