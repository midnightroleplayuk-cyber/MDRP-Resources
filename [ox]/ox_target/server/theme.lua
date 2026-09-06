--[[
    Volt Circuit theme — server side. Persists the forced (server-wide) theme
    and exposes it via GlobalState so every client (including new joiners)
    receives it automatically.

    Permission: ace 'ox_target.themeadmin' (ex.: add_ace group.admin ox_target.themeadmin allow)
    ou qualquer admin de framework (ESX/QBCore/QBox) / ace 'command'.
]]

---@type table?
local forcedTheme

do
    local stored = GetResourceKvpString('ox_target:forcedTheme')

    if stored then
        local ok, decoded = pcall(json.decode, stored)
        forcedTheme = ok and decoded or nil
    end

    GlobalState['ox_target:forcedTheme'] = forcedTheme or false
end

local ADMIN_ACES = {
    'ox_target.themeadmin',
    'command',
    'group.admin',
    'group.superadmin',
    'group.god',
    'qbcore.god',
    'qbcore.admin',
    'txadmin.everything',
}

local ESX_ADMIN_GROUPS = { admin = true, superadmin = true, god = true, owner = true }

---Framework-agnostic admin check (aces first, then runtime lookups, all
---pcall-guarded so a missing core API can never break the theme system).
local function isThemeAdmin(source)
    for i = 1, #ADMIN_ACES do
        if IsPlayerAceAllowed(source --[[@as string]], ADMIN_ACES[i]) then return true end
    end

    if GetResourceState('qbx_core') == 'started' then
        local ok, result = pcall(function()
            return exports.qbx_core:HasPermission(source, { 'admin', 'god' })
        end)
        if ok and result then return true end
    end

    if GetResourceState('qb-core') == 'started' then
        local ok, result = pcall(function()
            local QBCore = exports['qb-core']:GetCoreObject()
            return QBCore.Functions.HasPermission(source, 'god') or QBCore.Functions.HasPermission(source, 'admin')
        end)
        if ok and result then return true end
    end

    if GetResourceState('es_extended') == 'started' then
        local ok, result = pcall(function()
            local xPlayer = exports.es_extended:getSharedObject().GetPlayerFromId(source)
            return xPlayer and ESX_ADMIN_GROUPS[xPlayer.getGroup()] or false
        end)
        if ok and result then return true end
    end

    return false
end

lib.callback.register('ox_target:themeIsAdmin', function(source)
    return isThemeAdmin(source)
end)

local colorKeys = { brand = true, bg = true, text = true }
local numberKeys = {
    alpha = { 0.3, 1 },
    radius = { 0, 12 },
    notch = { 0, 14 },
    scale = { 0.5, 1.8 },
    speed = { 0.4, 2.2 },
    offsetX = { 8, 70 },
}
local enumKeys = {
    reticle = { ticks = true, dot = true, ring = true, square = true, eye = true },
    anim = { cascade = true, sweep = true, scale = true, fade = true, none = true },
}
local boolKeys = { monoLabels = true, showIndex = true }

---Only known keys with sane value shapes make it into the broadcast theme.
---@param settings table
---@return table?
local function sanitizeTheme(settings)
    local clean = {}

    for key in pairs(colorKeys) do
        local value = settings[key]
        if type(value) == 'string' and value:match('^#%x%x%x%x%x%x$') then
            clean[key] = value
        end
    end

    for key, range in pairs(numberKeys) do
        local value = tonumber(settings[key])
        if value then
            clean[key] = math.min(math.max(value, range[1]), range[2])
        end
    end

    for key, allowed in pairs(enumKeys) do
        local value = settings[key]
        if type(value) == 'string' and allowed[value] then
            clean[key] = value
        end
    end

    for key in pairs(boolKeys) do
        if type(settings[key]) == 'boolean' then
            clean[key] = settings[key]
        end
    end

    return next(clean) and clean or nil
end

RegisterNetEvent('ox_target:setForcedTheme', function(settings)
    local source = source

    if not isThemeAdmin(source) then return end

    if type(settings) == 'table' then
        forcedTheme = sanitizeTheme(settings)
    else
        forcedTheme = nil
    end

    if forcedTheme then
        SetResourceKvp('ox_target:forcedTheme', json.encode(forcedTheme))
    else
        DeleteResourceKvp('ox_target:forcedTheme')
    end

    GlobalState['ox_target:forcedTheme'] = forcedTheme or false

    print(('ox_target: forced theme %s by %s (%s)'):format(
        forcedTheme and 'set' or 'cleared',
        GetPlayerName(source) or 'unknown',
        source
    ))
end)
