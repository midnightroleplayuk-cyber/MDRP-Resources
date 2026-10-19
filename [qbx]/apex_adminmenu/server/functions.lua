

AdminPerms = function(source)
    local authorized = false
    if Config.AdminPerms.UserGroups.enabled then
        for i=1, #Config.AdminPerms.UserGroups.Groups do
            if HasPermission(source, Config.AdminPerms.UserGroups.Groups[i]) then
                authorized = true
                break
            end
        end
    end
    if Config.AdminPerms.AcePerms.enabled then
        if IsPlayerAceAllowed(source, Config.AdminPerms.AcePerms.AcePerm) then
            authorized = true
        end
    end
    return authorized
end

-- Check if a player has permission for a specific action
HasActionPermission = function(source, action)
    if not Config.PermissionLevels[action] then
        return AdminPerms(source) -- Fallback to general admin permission
    end

    local playerGroup = GetPlayerGroup(source)

    -- No UserGroups match. This is the normal state for a server using
    -- ACE permissions only (the setup documented in configs/config.lua:
    -- `add_ace group.admin 'apex.adminmenu.allow'`), because
    -- GetPlayerGroup only ever consults Config.AdminPerms.UserGroups.
    --
    -- Returning false here denied a full ACE admin every gated action —
    -- kick, ban, give money, give items — while the F6 panel handed the
    -- same person everything. The two permission systems failed in
    -- opposite directions. Defer to the general admin check instead.
    if not playerGroup then
        return AdminPerms(source) == true
    end

    for _, allowedGroup in ipairs(Config.PermissionLevels[action]) do
        if playerGroup == allowedGroup then
            return true
        end
    end

    return false
end

-- Get player's admin group
GetPlayerGroup = function(source)
    if Config.AdminPerms.UserGroups.enabled then
        for i=1, #Config.AdminPerms.UserGroups.Groups do
            if HasPermission(source, Config.AdminPerms.UserGroups.Groups[i]) then
                return Config.AdminPerms.UserGroups.Groups[i]
            end
        end
    end
    return nil
end

-- Add fallback GetPlayer function if it's not defined in the bridge
if not GetPlayer then
    GetPlayer = function(source)
        if Framework == 'esx' then
            if ESX then
                return ESX.GetPlayerFromId(source)
            else
                -- Try to get ESX if it's not already defined
                local ESX = nil
                TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
                if ESX then
                    return ESX.GetPlayerFromId(source)
                end
            end
        end
        
        -- Fallback for when framework is not detected
        print("^1[apex_adminmenu] Framework not properly initialized. Using fallback GetPlayer function.^0")
        return {source = source}
    end
end

-- Discord webhook logging (quick-menu / command side).
--
-- Routing: the F6 panel's per-category webhooks take priority when they
-- are configured, so a server that set everything up in the panel does
-- NOT also have to fill in config.lua. Config.Webhooks.url is the
-- fallback for servers that never open the panel settings.
--
-- @param adminSrc optional explicit admin server id. `source` is a magic
--        global that is only meaningful inside an event handler, so
--        relying on it here (as this used to) produced "Console" or
--        "Unknown" for most actions. Callers that know the admin should
--        pass it.
SendDiscordLog = function(title, description, fields, logType, color, adminSrc)
    if not Config.Webhooks or not Config.Webhooks.enabled then return end

    -- Per-type mute switch from config.lua.
    if logType and Config.Webhooks.logs then
        if Config.Webhooks.logs[logType] == false then return end
    end

    local webhookColor = tonumber(color)
        or tonumber(Config.Webhooks.color)
        or 3447003 -- default blue

    -- Resolve the admin name. `source` is captured defensively: it is
    -- valid when we are called from inside an event/command handler and
    -- nil otherwise, which is fine — we just fall back to Console.
    local src = tonumber(adminSrc) or tonumber(source)
    local adminName = 'Console'
    if src and src > 0 then
        adminName = GetPlayerName(src) or ('Disconnected (' .. src .. ')')
    end

    local embed = {
        color       = webhookColor,
        title       = title or 'Admin Action',
        description = description,
        fields      = fields,
        timestamp   = os.date('!%Y-%m-%dT%H:%M:%SZ'),
        footer      = { text = 'Admin: ' .. adminName }
    }

    -- 1) Prefer the panel route for this log type, when one is set up.
    local PANEL_CATEGORY = {
        playerActions  = 'player',
        vehicleActions = 'vehicle',
        moneyActions   = 'economy',
        utilityActions = 'staff',
        adminActivity  = 'staff'
    }
    if PanelDiscordSend and logType and PANEL_CATEGORY[logType] then
        if PanelDiscordSend(PANEL_CATEGORY[logType], embed) then return end
        -- No panel route for this category — fall through to config.lua
        -- so servers that only ever edited config.lua keep working.
    end

    -- 2) Fall back to the single config.lua webhook.
    --    NOTE: the old code tested `if Config.Webhooks.url then`. An empty
    --    string is TRUTHY in Lua, so an unconfigured server POSTed to ""
    --    on every single admin action and swallowed the error. Validation
    --    now lives in ApexDiscord.ValidateUrl.
    ApexDiscord.SendEmbed(Config.Webhooks.url, embed, {
        username   = Config.Webhooks.botName,
        avatar_url = Config.Webhooks.botAvatar
    })
end
