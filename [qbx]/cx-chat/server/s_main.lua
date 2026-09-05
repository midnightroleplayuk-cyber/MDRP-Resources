local function getThemeId(src)
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:match("^license:") then return id end
    end
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:match("^fivem:") or id:match("^steam:") or id:match("^discord:") then return id end
    end
    return nil
end

local function themeKey(src)
    local id = getThemeId(src)
    if not id then return nil end
    return "cx_chat_theme:" .. id
end

RegisterNetEvent("cx-chat:server:saveTheme", function(theme)
    local src = source
    theme = tostring(theme or "")
    if theme == "" or #theme > 32 or not theme:match("^[%w_-]+$") then return end

    local key = themeKey(src)
    if key then SetResourceKvp(key, theme) end
end)

RegisterNetEvent("cx-chat:server:requestTheme", function()
    local src   = source
    local key   = themeKey(src)
    local theme = key and GetResourceKvpString(key) or nil
    if theme and theme ~= "" then
        TriggerClientEvent("cx-chat:applySavedTheme", src, theme)
    end
end)

RegisterNetEvent("cx-chat:sendMessage")
AddEventHandler("cx-chat:sendMessage", function(message, channel)
    local src = source
    if not message or message == "" then return end
    if Config.DisableChatMessages then
        return
    end
    if IsSpamming(src) then return end
    if IsMuted(src) then
        TriggerClientEvent("cx-chat:addMessage", src, {
            message  = "You are currently muted.",
            color    = "#ef4444",
            isSystem = true,
        })
        return
    end

    local clean, blocked = FilterText(src, message)
    if blocked then return end

    local name     = Config.GetCharacterName(src)
    local tag      = nil
    local tagColor = nil

    if IsPlayerAceAllowed(src, "group.admin") then
        tag      = "ADMIN"
        tagColor = "#ef4444"
    elseif IsPlayerAceAllowed(src, "group.mod") then
        tag      = "MOD"
        tagColor = "#f59e0b"
    elseif IsPlayerAceAllowed(src, "group.staff") then
        tag      = "STAFF"
        tagColor = "#8b5cf6"
    end

    if Config.StaffBadge and Config.StaffBadge.enabled and IsPlayerAceAllowed(src, Config.StaffBadge.permission) then
        tag      = Config.StaffBadge.label or "STAFF"
        tagColor = Config.StaffBadge.color or "#e879a0"
    elseif channel ~= Config.DefaultChannel then
        for _, ch in ipairs(Config.Channels) do
            if ch.name == channel then
                tag      = ch.label:upper()
                tagColor = ch.color
                break
            end
        end
    end

    local msgId = StoreMessage(src, { message = clean, channel = channel })

    local mentions = {}
    if Config.Mentions.enabled then
        for match in clean:gmatch("@(%w+)") do
            for _, player in ipairs(GetPlayers()) do
                local playerId = tonumber(player)
                local charName = Config.GetCharacterName(playerId)
                if charName then
                    local firstName = charName:match("^(%S+)")
                    if firstName and firstName:lower():find(match:lower(), 1, true) then
                        table.insert(mentions, playerId)
                        break
                    end
                end
            end
        end
    end

    TriggerClientEvent("cx-chat:addMessage", -1, {
        id       = msgId,
        message  = clean,
        name     = name,
        channel  = channel,
        tag      = tag,
        tagColor = tagColor,
        isSystem = false,
        authorId = src,
    })

    for _, mentionedId in ipairs(mentions) do
        TriggerClientEvent("cx-chat:mentioned", mentionedId, name)
    end
end)

RegisterNetEvent("cx-chat:uiSubmitReport")
AddEventHandler("cx-chat:uiSubmitReport", function(message, targetId, reportType)
    local src    = source
    local coords = GetEntityCoords(GetPlayerPed(src))
    local name   = GetPlayerName(src)
    local lic, disc = "N/A", "N/A"

    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if id:match("^license:") then lic  = id end
        if id:match("^discord:")  then disc = id end
    end

    local targetStr = (targetId and targetId ~= "") and ("ID: " .. targetId) or "None"

    CXLog("report", {
        description = "New report from " .. name,
        metadata    = { message = message, type = reportType, reporter = name },
        embed = {
            title  = "📋 New Report: " .. (reportType or "General"),
            color  = 16711680,
            fields = {
                { name = "Category",     value = reportType or "N/A",   inline = true },
                { name = "Target",       value = targetStr,              inline = true },
                { name = "Reporter",     value = Config.GetCharacterName(src) .. " (" .. name .. ")", inline = true },
                { name = "Ping",         value = GetPlayerPing(src) .. "ms", inline = true },
                { name = "Location",     value = string.format("X: %.2f, Y: %.2f, Z: %.2f", coords.x, coords.y, coords.z), inline = false },
                { name = "Message",      value = "```" .. message .. "```", inline = false },
                { name = "Reporter IDs", value = "**Lic:** `" .. lic .. "`\n**Disc:** `" .. disc .. "`", inline = false },
            }
        }
    })
end)

if Config.JoinLeave.enabled then
    AddEventHandler("playerConnecting", function(name)
        SetTimeout(Config.JoinLeave.joinDelay or 3000, function()
            TriggerClientEvent("cx-chat:addMessage", -1, {
                message  = name .. " joined the server.",
                color    = Config.JoinLeave.joinColor,
                tag      = "JOIN",
                tagColor = Config.JoinLeave.joinColor,
                isSystem = true,
            })
        end)
    end)

    AddEventHandler("playerDropped", function(reason)
        local src  = source
        local name = GetPlayerName(src) or "Unknown"
        TriggerClientEvent("cx-chat:addMessage", -1, {
            message  = name .. " left the server.",
            color    = Config.JoinLeave.leaveColor,
            tag      = "LEAVE",
            tagColor = Config.JoinLeave.leaveColor,
            isSystem = true,
        })
    end)
end

local function CheckVersion()
    local url          = "https://raw.githubusercontent.com/JustCxsper/cx-chat/refs/heads/main/version.txt"
    local resourceName = GetCurrentResourceName()

    PerformHttpRequest(url, function(code, result)
        if code ~= 200 or not result then
            print("^1[CX Scripts] Could not reach update server (error " .. code .. ")^7")
            return
        end

        local latest  = result:gsub("%s+", "")
        local current = Config.Version

        if latest ~= current then
            print("^1[CX Scripts] " .. resourceName .. " is outdated!^7")
            print("^1[CX Scripts] Current: " .. current .. " | Latest: " .. latest .. "^7")
            print("^3[CX Scripts] Download at: https://github.com/JustCxsper/cx-chat^7")
            print("^3[CX Scripts] Join our Discord for support: https://discord.gg/XatzNXHeU3^7")
        else
            print("^2[CX Scripts] " .. resourceName .. " is up to date (v" .. current .. ")^7")
        end
    end, "GET")
end

CreateThread(function()
    Wait(5000)
    CheckVersion()
end)
