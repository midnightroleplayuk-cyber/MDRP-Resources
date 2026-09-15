--[[
    Apex Gangs — Integrations (OPEN — edit freely)
    ────────────────────────────────────────────────────────────
    Two things live here:
      1) HOOK STUBS — no-op functions you can override to plug
         apex_gangs into the rest of your server (logging, custom
         rewards, anti-cheat, third-party events). Returning the
         documented value changes behaviour; returning nothing keeps
         the default.
      2) PROVIDER BRIDGES — external garage + vehicle-keys adapters,
         auto-detected at runtime. Add your own provider by extending
         the tables below.
]]

Integrations = Integrations or {}

-- ════════════════════════════════════════════════════════════
-- HOOKS (server)
-- ════════════════════════════════════════════════════════════

-- Fired for EVERY logged action. payload = { category, action, gang,
-- actor, target, amount, details }. Use it to mirror logs elsewhere.
function Integrations.OnLog(payload) end

-- Fired after a member's gang/grade changes. payload = { src, identifier, gang, grade, action }.
function Integrations.OnMemberUpdate(payload) end

-- Fired before XP is awarded. Return a number to OVERRIDE the amount,
-- or false to BLOCK it. payload = { gang, reason, amount }.
function Integrations.OnBeforeXP(payload) return payload and payload.amount end

-- Fired when a turf zone changes owner. payload = { id, label, from, to }.
function Integrations.OnTurfCaptured(payload) end

-- Fired when a raid resolves. payload = { attacker, defender, success, loot }.
function Integrations.OnRaidResolved(payload) end

-- Fired when a zone/HQ/garage/safe is saved or removed in the editor.
function Integrations.OnZoneSaved(payload) end
function Integrations.OnZoneRemoved(payload) end

-- ════════════════════════════════════════════════════════════
-- HOOKS (client)
-- ════════════════════════════════════════════════════════════

-- Return true to SUPPRESS the built-in toast (you handled the notify).
function Integrations.Notify(message, kind, title, duration) end

-- Fired when the gang menu opens/closes. payload = { open, gang }.
function Integrations.OnMenuToggle(payload) end

-- ════════════════════════════════════════════════════════════
-- GARAGE BRIDGE (server) — when Config.garage.mode == 'external'
-- Each provider returns true if it handled the spawn/store.
-- ════════════════════════════════════════════════════════════
Integrations.Garage = {
    -- Spawn a stored vehicle at coords. veh = { model, plate, props }.
    Spawn = function(src, veh, coords)
        local p = (Config.providers and Config.providers.garage) or 'auto'
        local function has(n) return GetResourceState(n) == 'started' end
        -- These signatures vary widely between garage scripts; the most
        -- common is a server event the garage listens for. We forward to
        -- the client which then calls the garage's own spawn export.
        TriggerClientEvent('apex_gangs:garage:externalSpawn', src, veh, coords, p)
        return true
    end,
    Store = function(src, plate)
        TriggerClientEvent('apex_gangs:garage:externalStore', src, plate)
        return true
    end,
}

-- ════════════════════════════════════════════════════════════
-- VEHICLE KEYS (server→client) — auto-detected, used on take.
-- ════════════════════════════════════════════════════════════
Integrations.Keys = {
    Give = function(src, plate)
        -- wasabi is server-side; everything else is given client-side.
        if GetResourceState('wasabi_carlock') == 'started' then
            return Framework.CallExport('wasabi_carlock', 'GiveKey', src, plate)
        end
        TriggerClientEvent('apex_gangs:keys:give', src, plate)
        return true
    end,
    Remove = function(src, plate)
        if GetResourceState('wasabi_carlock') == 'started' then
            return Framework.CallExport('wasabi_carlock', 'RemoveKey', src, plate)
        end
        TriggerClientEvent('apex_gangs:keys:remove', src, plate)
        return true
    end,
}

-- ════════════════════════════════════════════════════════════
-- WEBHOOK helper — used by logs.lua. Override to change formatting.
-- ════════════════════════════════════════════════════════════
function Integrations.SendWebhook(url, username, embed)
    if not url or url == '' then return end
    PerformHttpRequest(url, function() end, 'POST',
        json.encode({ username = username or 'Apex Gangs', embeds = { embed } }),
        { ['Content-Type'] = 'application/json' })
end
