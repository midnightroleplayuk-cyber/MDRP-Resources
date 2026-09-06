--[[
    Volt Circuit theme manager — personal theme (KVP) + forced server-wide
    theme (GlobalState, set by admins via /oxtarget Target Studio).
]]

local uiReady = false

---@type table?
local personalTheme

do
    local stored = GetResourceKvpString('ox_target:ui_theme')

    if stored then
        local ok, decoded = pcall(json.decode, stored)
        personalTheme = ok and decoded or nil
    end
end

local function getForcedTheme()
    local forced = GlobalState['ox_target:forcedTheme']
    if type(forced) == 'table' and next(forced) then return forced end
end

local function currentTheme()
    return getForcedTheme() or personalTheme
end

local function pushTheme()
    if not uiReady then return end

    SendNuiMessage(json.encode({
        event = 'setTheme',
        settings = currentTheme() or false
    }))
end

RegisterNUICallback('themeReady', function(_, cb)
    cb(1)
    uiReady = true
    pushTheme()
end)

AddStateBagChangeHandler('ox_target:forcedTheme', 'global', function()
    Wait(0)
    pushTheme()
end)

RegisterCommand('oxtarget', function()
    local isAdmin = lib.callback.await('ox_target:themeIsAdmin', 500) or false

    SetNuiFocus(true, true)

    SendNuiMessage(json.encode({
        event = 'openStudio',
        settings = currentTheme(),
        isAdmin = isAdmin,
        forcedActive = getForcedTheme() ~= nil
    }))
end)

RegisterNUICallback('themeStudio:save', function(data, cb)
    cb(1)
    SetNuiFocus(false, false)

    if type(data) ~= 'table' or type(data.settings) ~= 'table' then return end

    personalTheme = data.settings
    SetResourceKvp('ox_target:ui_theme', json.encode(data.settings))

    if data.admin then
        TriggerServerEvent('ox_target:setForcedTheme', data.settings)
    elseif data.clearForced then
        TriggerServerEvent('ox_target:setForcedTheme', false)
    end

    pushTheme()
end)

RegisterNUICallback('themeStudio:close', function(_, cb)
    cb(1)
    SetNuiFocus(false, false)
    pushTheme()
end)

TriggerEvent('chat:addSuggestion', '/oxtarget', 'Customize the ox_target UI (reticle, colors, animations)')
