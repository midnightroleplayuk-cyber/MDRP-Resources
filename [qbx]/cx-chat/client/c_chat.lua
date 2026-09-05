local chatOpen = false
local currentChannel = Config.DefaultChannel
local currentTab = 1

local suggestions = {}
local serverCmds  = {}

local function addCmd(list, seen, cmd)
    if not cmd or not cmd.command or cmd.command == "" or seen[cmd.command] then return end

    seen[cmd.command] = true
    local meta = suggestions[cmd.command] or {}

    table.insert(list, {
        command = cmd.command,
        help    = meta.help or cmd.help or "",
        params  = meta.params or cmd.params or {},
        own     = cmd.own == true,
    })
end

local function mergeAndSend()
    local seen   = {}
    local merged = {}

    for _, cmd in ipairs(Config.Commands or {}) do
        addCmd(merged, seen, {
            command = cmd.command,
            help    = cmd.help or "",
            params  = cmd.params or {},
            own     = true,
        })
    end

    for _, cmd in ipairs(serverCmds) do
        addCmd(merged, seen, cmd)
    end

    if GetRegisteredCommands then
        for _, cmd in ipairs(GetRegisteredCommands()) do
            local name = cmd.name
            local skip = name:sub(1,1) == '+' or name:sub(1,1) == '-' or #name <= 1 or
                         name:sub(1,4) == 'cfx_' or name:sub(1,4) == 'net_' or
                         name:sub(1,3) == 'cl_'  or name:sub(1,3) == 'sv_' or
                         name:sub(1,2) == 'r_'   or name:sub(1,4) == 'con_'
            if not skip then
                local meta = suggestions[name] or {}
                addCmd(merged, seen, {
                    command = name,
                    help    = meta.help or "",
                    params  = meta.params or {},
                })
            end
        end
    end

    table.sort(merged, function(a, b) return a.command < b.command end)
    SendNUIMessage({ type = "setCommands", commands = merged })
end

local function GetChannelColor(channel)
    for _, ch in ipairs(Config.Channels) do
        if ch.name == channel then return ch.color end
    end
    return "#8a6eff"
end

function OpenChat()
    if chatOpen then return end
    chatOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type         = "open",
        channel      = currentChannel:upper(),
        channelColor = GetChannelColor(currentChannel),
    })
end

function CloseChat()
    if not chatOpen then return end
    chatOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "close" })
end

RegisterKeyMapping("openChat", "Open CX Chat", "keyboard", Config.OpenKey or "T")
RegisterCommand("openChat", function()
    if not chatOpen and not IsPauseMenuActive() then
        OpenChat()
    end
end, false)

RegisterNUICallback("chatResult", function(data, cb)
    CloseChat()
    if data and data.message and data.message ~= "" then
        if data.message:sub(1, 1) == "/" then
            ExecuteCommand(data.message:sub(2))
        elseif Config.DisableChatMessages then
            return
        else
            TriggerServerEvent("cx-chat:sendMessage", data.message, currentChannel)
        end
    end
    cb("ok")
end)

RegisterNUICallback("closeChat", function(data, cb)
    CloseChat()
    cb("ok")
end)

RegisterNUICallback("switchChannel", function(data, cb)
    if data and data.channel then
        currentChannel = data.channel
    end
    cb("ok")
end)

RegisterNUICallback("cycleChatTabs", function(data, cb)
    currentTab = currentTab + 1
    if currentTab > #Config.TabChannels then currentTab = 1 end

    currentChannel = Config.TabChannels[currentTab]

    local label = currentChannel
    local color = "#8a6eff"
    for _, ch in ipairs(Config.Channels) do
        if ch.name == currentChannel then
            label = ch.label
            color = ch.color
            break
        end
    end

    SendNUIMessage({
        type         = "open",
        channel      = label,
        channelColor = color,
    })

    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    cb("ok")
end)

RegisterNetEvent("cx-chat:addMessage")
AddEventHandler("cx-chat:addMessage", function(data)
    if not CxChatSpawned then return end
    if data.playSound then
        PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", 1)
    end
    SendNUIMessage({ type = "addMessage", data = data })
end)

RegisterNetEvent("cx-chat:commandList")
AddEventHandler("cx-chat:commandList", function(list)
    serverCmds = list or {}
    mergeAndSend()
end)

RegisterNetEvent("chat:addSuggestion")
AddEventHandler("chat:addSuggestion", function(command, help, params)
    local name = command:gsub("^/", "")
    if name == "" then return end

    local paramList = {}
    if type(params) == "table" then
        for _, p in ipairs(params) do
            table.insert(paramList, { name = p.name or "", help = p.help or "" })
        end
    end

    suggestions[name] = { help = help or "", params = paramList }
    mergeAndSend()
end)

RegisterNetEvent("chat:addSuggestions")
AddEventHandler("chat:addSuggestions", function(suggs)
    if type(suggs) ~= "table" then return end
    for _, s in ipairs(suggs) do
        if s.name then
            local name = s.name:gsub("^/", "")
            local paramList = {}
            if type(s.params) == "table" then
                for _, p in ipairs(s.params) do
                    table.insert(paramList, { name = p.name or "", help = p.help or "" })
                end
            end
            suggestions[name] = { help = s.help or "", params = paramList }
        end
    end
    mergeAndSend()
end)

AddEventHandler("onClientResourceStart", function(resourceName)
    Wait(500)
    mergeAndSend()

    if resourceName == GetCurrentResourceName() then
        TriggerServerEvent("cx-chat:server:requestTheme")
    else
        TriggerServerEvent("cx-chat:getCommands")
    end
end)

AddEventHandler("onClientResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then return end
    Wait(500)
    mergeAndSend()
end)

RegisterNetEvent("cx-chat:externalSuggestion")
AddEventHandler("cx-chat:externalSuggestion", function(command, help, params)
    TriggerEvent("chat:addSuggestion", command, help, params)
end)

RegisterNUICallback("submitReport", function(data, cb)
    if data and data.message then
        TriggerServerEvent("cx-chat:uiSubmitReport", data.message, data.target, data.type)
    end
    cb("ok")
end)

RegisterNUICallback("mutePlayer", function(data, cb)
    if data and data.playerId then
        TriggerServerEvent("cx-chat:server:mutePlayer", data.playerId, data.duration)
    end
    cb("ok")
end)

RegisterNUICallback("getNearbyPlayers", function(data, cb)
    local players  = {}
    local myCoords = GetEntityCoords(PlayerPedId())

    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local ped    = GetPlayerPed(player)
            local coords = GetEntityCoords(ped)
            if #(myCoords - coords) < 50.0 then
                table.insert(players, {
                    id   = GetPlayerServerId(player),
                    name = GetPlayerName(player),
                })
            end
        end
    end

    cb(players)
end)

RegisterNUICallback("setTheme", function(data, cb)
    if data and data.theme then
        SetResourceKvp("cx_chat_theme", data.theme)
        TriggerServerEvent("cx-chat:server:saveTheme", data.theme)
    end
    cb("ok")
end)

RegisterNUICallback("getSavedTheme", function(data, cb)
    local saved = GetResourceKvpString("cx_chat_theme")
    TriggerServerEvent("cx-chat:server:requestTheme")
    cb({ theme = saved or "" })
end)

RegisterNUICallback("savePosition", function(data, cb)
    if data and data.x ~= nil then
        SetResourceKvp("cx_chat_pos", json.encode({ x = data.x, y = data.y, scale = data.scale or 1.0 }))
    end
    cb("ok")
end)

RegisterNUICallback("getSavedPosition", function(data, cb)
    local saved = GetResourceKvpString("cx_chat_pos")
    if saved and saved ~= "" then
        local ok, parsed = pcall(json.decode, saved)
        if ok and type(parsed) == "table" then
            cb(parsed)
            return
        end
    end
    cb({})
end)

RegisterNUICallback("clearSavedPosition", function(data, cb)
    DeleteResourceKvp("cx_chat_pos")
    cb("ok")
end)

RegisterNetEvent("cx-chat:applySavedTheme", function(theme)
    if not theme or theme == "" then return end
    SetResourceKvp("cx_chat_theme", theme)
    SendNUIMessage({ type = "applyTheme", theme = theme })
end)

RegisterNetEvent("cx-chat:mentioned", function(name)
    if Config.Mentions.enabled and Config.Mentions.sound then
        PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", 1)
    end
    SendNUIMessage({ type = "mentioned", name = name })
end)

RegisterNetEvent("cx-chat:updateReactions", function(msgId, reactions)
    SendNUIMessage({ type = "updateReactions", msgId = msgId, reactions = reactions })
end)

RegisterNetEvent("cx-chat:updatePinned", function(pinned)
    SendNUIMessage({ type = "updatePinned", pinned = pinned })
end)

RegisterNetEvent("cx-chat:showTyping", function(playerId)
    SendNUIMessage({ type = "showTyping", playerId = playerId })
end)

RegisterNetEvent("cx-chat:messageEdited", function(msgId, newText)
    SendNUIMessage({ type = "messageEdited", msgId = msgId, newText = newText })
end)

RegisterNetEvent("cx-chat:messageDeleted", function(msgId)
    SendNUIMessage({ type = "messageDeleted", msgId = msgId })
end)

RegisterNUICallback("addReaction", function(data, cb)
    TriggerServerEvent("cx-chat:server:addReaction", data.msgId, data.emoji)
    cb("ok")
end)

RegisterNUICallback("pinMessage", function(data, cb)
    TriggerServerEvent("cx-chat:server:pinMessage", data.msgData)
    cb("ok")
end)

RegisterNUICallback("unpinMessage", function(data, cb)
    TriggerServerEvent("cx-chat:server:unpinMessage", data.msgId)
    cb("ok")
end)

RegisterNUICallback("typing", function(data, cb)
    TriggerServerEvent("cx-chat:server:typing", data.targetId)
    cb("ok")
end)

RegisterNUICallback("editMessage", function(data, cb)
    TriggerServerEvent("cx-chat:server:editMessage", data.msgId, data.newText)
    cb("ok")
end)

RegisterNUICallback("deleteMessage", function(data, cb)
    TriggerServerEvent("cx-chat:server:deleteMessage", data.msgId)
    cb("ok")
end)

AddEventHandler("chat:addMessage", function(message)
    if not CxChatSpawned then return end
    if type(message) == "table" then
        SendNUIMessage({
            type = "addMessage",
            data = {
                message  = message.args and type(message.args) == "table" and table.concat(message.args, " ") or message.message or "",
                color    = message.color or "#cbd5e1",
                tag      = message.tag,
                tagColor = message.tagColor,
                isSystem = true,
            }
        })
    end
end)

AddEventHandler("chat:clear", function()
    SendNUIMessage({ type = "clearMessages" })
end)

AddEventHandler("chatMessage", function() CancelEvent() end)

exports("openChat", OpenChat)
exports("closeChat", CloseChat)

exports("addMessage", function(author, message)
    if not CxChatSpawned then return end
    SendNUIMessage({
        type = "addMessage",
        data = {
            message  = message or author,
            name     = message and author or nil,
            color    = "#cbd5e1",
            isSystem = not message,
        }
    })
end)

exports("addSuggestion", function(command, help, params)
    TriggerEvent("chat:addSuggestion", command, help, params)
end)

exports("addSuggestions", function(suggs)
    TriggerEvent("chat:addSuggestions", suggs)
end)

exports("removeSuggestion", function(command)
    local name = command:gsub("^/", "")
    if suggestions[name] then
        suggestions[name] = nil
        mergeAndSend()
    end
end)

exports("clearSuggestions", function()
    suggestions = {}
    mergeAndSend()
end)
