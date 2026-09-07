if not lib then return end

--[[
    Per-type marker / blip appearance for dynamic stashes, crafts and shops.

    A single config row lives in `ox_inventory_appearance` holding three blocks
    (stash / craft / shop), each with its own marker + blip. It's loaded on start
    and pushed to every client; admins edit each type from /oxinventory · Settings
    and the change is broadcast live (props/zones don't rebuild — only the drawn
    marker + blips read the new values). - fuck portuguese
]]

local db = require 'modules.mysql.server'

local CustomAppearance = {}

local ACE_PERMISSION = 'group.admin'
local KINDS = { 'stash', 'craft', 'shop' }

local function isAdmin(source)
    if source == 0 then return true end -- console
    return IsPlayerAceAllowed(source --[[@as string]], ACE_PERMISSION)
end

-- Defaults match the previously hardcoded marker/blip values.
local DEFAULT = {
    marker = {
        type = 21,
        color = { r = 31, g = 94, b = 255 },
        alpha = 180,
        scale = 0.4,
        bob = true,
    },
    blip = {
        sprite = 566,
        color = 31,
        scale = 0.7,
        alpha = 255,
        shortRange = true,
        display = 2,
        name = '',
    },
}

---@type table per-type appearance config currently in effect ({ stash, craft, shop })
local current = nil

-- Normalises one { marker, blip } block, filling missing keys with the defaults.
local function normaliseBlock(data)
    data = type(data) == 'table' and data or {}
    local m = type(data.marker) == 'table' and data.marker or {}
    local mc = type(m.color) == 'table' and m.color or {}
    local b = type(data.blip) == 'table' and data.blip or {}

    return {
        marker = {
            type = tonumber(m.type) or DEFAULT.marker.type,
            color = {
                r = math.max(0, math.min(255, tonumber(mc.r) or DEFAULT.marker.color.r)),
                g = math.max(0, math.min(255, tonumber(mc.g) or DEFAULT.marker.color.g)),
                b = math.max(0, math.min(255, tonumber(mc.b) or DEFAULT.marker.color.b)),
            },
            alpha = math.max(0, math.min(255, tonumber(m.alpha) or DEFAULT.marker.alpha)),
            scale = math.max(0.05, math.min(5.0, tonumber(m.scale) or DEFAULT.marker.scale)),
            bob = m.bob ~= false,
        },
        blip = {
            sprite = tonumber(b.sprite) or DEFAULT.blip.sprite,
            color = tonumber(b.color) or DEFAULT.blip.color,
            scale = math.max(0.1, math.min(2.0, tonumber(b.scale) or DEFAULT.blip.scale)),
            alpha = math.max(0, math.min(255, tonumber(b.alpha) or DEFAULT.blip.alpha)),
            shortRange = b.shortRange ~= false,
            -- 2 = both, 3 = minimap only, 5 = main map only.
            display = tonumber(b.display) or DEFAULT.blip.display,
            name = type(b.name) == 'string' and b.name or '',
        },
    }
end

-- Normalises the whole per-type config. Accepts a legacy flat { marker, blip }
-- config and applies it to all three types (one-time upgrade).
local function normalise(data)
    data = type(data) == 'table' and data or {}

    -- Legacy single-block config → spread across every type.
    if data.marker or data.blip then
        local block = normaliseBlock(data)
        return { stash = block, craft = normaliseBlock(data), shop = normaliseBlock(data) }
    end

    local out = {}
    for i = 1, #KINDS do
        out[KINDS[i]] = normaliseBlock(data[KINDS[i]])
    end
    return out
end

function CustomAppearance.Get()
    return current or normalise(nil)
end

local function syncToClients(target)
    TriggerClientEvent('ox_inventory:setAppearance', target or -1, current)
end

-- Push the active config to a client that just spawned / loaded the UI.
RegisterNetEvent('ox_inventory:requestAppearance', function()
    TriggerClientEvent('ox_inventory:setAppearance', source, CustomAppearance.Get())
end)

-- ── NUI callbacks ──────────────────────────────────────────────

lib.callback.register('ox_inventory:getAppearance', function(source)
    if not isAdmin(source) then return { allowed = false } end
    return { allowed = true, appearance = CustomAppearance.Get() }
end)

lib.callback.register('ox_inventory:saveAppearance', function(source, data)
    if not isAdmin(source) then return { ok = false, error = 'not_allowed' } end

    current = normalise(data)
    db.saveAppearance(current)
    syncToClients()

    return { ok = true, appearance = current }
end)

CreateThread(function()
    Wait(1200)
    current = normalise(db.loadAppearance())
end)

return CustomAppearance
