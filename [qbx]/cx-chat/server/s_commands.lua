local function GetPlayerJob(src)
    if Config.Framework == "qbcore" or Config.Framework == "qbox" then
        local Player = exports["qb-core"]:GetCoreObject().Functions.GetPlayer(src)
        return Player and Player.PlayerData.job.name or "unemployed"
    elseif Config.Framework == "esx" then
        local xPlayer = exports["es_extended"]:getSharedObject().GetPlayerFromId(src)
        return xPlayer and xPlayer.job.name or "unemployed"
    end
    return "unemployed"
end

for _, cmd in ipairs(Config.Commands) do
    if cmd.type == "server" then
        RegisterCommand(cmd.command, function(src, args)
            if IsSpamming(src) then return end

            local filtered = {}
            for i, arg in ipairs(args) do
                local clean = FilterText(src, arg)
                if not clean then return end
                filtered[i] = clean
            end

            cmd.callback(src, filtered)
        end, false)
    end
end

RegisterNetEvent("cx-chat:server:jobAnnounce")
AddEventHandler("cx-chat:server:jobAnnounce", function(targetSrc, msg, ignoreSpam)
    local src = targetSrc or source

    if not ignoreSpam and IsSpamming(src) then return end

    local clean, blocked = FilterText(src, msg)
    if blocked then
        TriggerClientEvent("cx-chat:addMessage", src, {
            message  = "Announcement blocked: message contains prohibited language.",
            color    = "#ef4444",
            isSystem = true,
        })
        return
    end

    local jobName = GetPlayerJob(src)
    local jobData = Config.AnnouncementJobs[jobName]

    if jobData then
        TriggerClientEvent("cx-chat:addMessage", -1, {
            message   = clean,
            color     = "#ffffff",
            tag       = jobData.label,
            tagColor  = jobData.color,
            channel   = "global",
            isSystem  = false,
            playSound = true,
        })
    end
end)

local suggestions = {}

local function skipCmd(name)
    if name:sub(1, 1) == '+' or name:sub(1, 1) == '-' then return true end
    if #name <= 1 then return true end
    if name:sub(1, 4) == 'cfx_' or name:sub(1, 4) == 'net_' then return true end
    if name:sub(1, 3) == 'cl_'  or name:sub(1, 3) == 'sv_'  then return true end
    if name:sub(1, 2) == 'r_'   or name:sub(1, 4) == 'con_' then return true end

    local ignore = { quit = true, exit = true, invoke = true, invokeNative = true, openConsole = true, toggleChat = true, reloadgame = true }
    return ignore[name] == true
end

local function addCmd(list, seen, name, help, params, own)
    name = tostring(name or ""):gsub("^/", "")
    if name == "" or skipCmd(name) or seen[name] then return end

    seen[name] = true
    local meta = suggestions[name] or {}

    table.insert(list, {
        command = name,
        help    = meta.help or help or "",
        params  = meta.params or params or {},
        own     = own == true,
    })
end

local function getCmds(src)
    local list = {}
    local seen = {}

    for _, cmd in ipairs(Config.Commands or {}) do
        addCmd(list, seen, cmd.command, cmd.help, cmd.params, true)
    end

    if GetRegisteredCommands then
        for _, cmd in ipairs(GetRegisteredCommands()) do
            if not skipCmd(cmd.name) then
                local restricted = cmd.restricted == true
                local allowed    = (not restricted) or IsPlayerAceAllowed(src, "command." .. cmd.name)
                if allowed then
                    addCmd(list, seen, cmd.name, "", {}, false)
                end
            end
        end
    end

    return list
end

RegisterNetEvent("cx-chat:getCommands")
AddEventHandler("cx-chat:getCommands", function()
    local src  = source
    local list = getCmds(src)
    TriggerClientEvent("cx-chat:commandList", src, list)
end)

AddEventHandler("onServerResourceStart", function(resourceName)
    Wait(500)
    for _, src in ipairs(GetPlayers()) do
        local list = getCmds(tonumber(src))
        TriggerClientEvent("cx-chat:commandList", tonumber(src), list)
    end
end)

local function handleSuggestion(command, help, params)
    local name = tostring(command):gsub("^/", "")
    if name == "" then return end

    local paramList = {}
    if type(params) == "table" then
        for _, p in ipairs(params) do
            table.insert(paramList, { name = p.name or "", help = p.help or "" })
        end
    end

    suggestions[name] = { help = help or "", params = paramList }
    TriggerClientEvent("cx-chat:externalSuggestion", -1, command, help, params)
end

AddEventHandler("chat:addSuggestion", handleSuggestion)
RegisterNetEvent("chat:addSuggestion")
AddEventHandler("chat:addSuggestion", handleSuggestion)

AddEventHandler("chat:addSuggestions", function(suggs)
    if type(suggs) ~= "table" then return end
    for _, s in ipairs(suggs) do
        if s.name then
            local name = tostring(s.name):gsub("^/", "")
            local paramList = {}
            if type(s.params) == "table" then
                for _, p in ipairs(s.params) do
                    table.insert(paramList, { name = p.name or "", help = p.help or "" })
                end
            end
            suggestions[name] = { help = s.help or "", params = paramList }
        end
    end

    TriggerClientEvent("chat:addSuggestions", -1, suggs)
end)
