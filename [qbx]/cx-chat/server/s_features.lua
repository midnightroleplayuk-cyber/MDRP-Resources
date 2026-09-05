local messageReactions = {}
local pinnedMessages   = {}
local rpsGames         = {}
local messageHistory   = {}
local mutedPlayers     = {}
local messageIdCounter = 0

local function genMsgId()
    messageIdCounter = messageIdCounter + 1
    return "msg_" .. messageIdCounter
end

function IsMuted(src)
    return mutedPlayers[src] ~= nil
end

function MutePlayerInternal(src, duration)
    mutedPlayers[src] = true
    TriggerClientEvent("cx-chat:addMessage", src, {
        message  = "You have been muted for " .. duration .. " seconds.",
        color    = "#ef4444",
        isSystem = true,
    })
    SetTimeout(duration * 1000, function()
        mutedPlayers[src] = nil
        if GetPlayerName(src) then
            TriggerClientEvent("cx-chat:addMessage", src, {
                message  = "You have been unmuted.",
                color    = "#3dd68c",
                isSystem = true,
            })
        end
    end)
end

function GetMessageHistory()
    return messageHistory
end

RegisterNetEvent("cx-chat:server:addReaction")
AddEventHandler("cx-chat:server:addReaction", function(msgId, emoji)
    if not Config.Reactions.enabled then return end

    local src = source
    if not messageReactions[msgId] then
        messageReactions[msgId] = {}
    end

    if not messageReactions[msgId][emoji] then
        messageReactions[msgId][emoji] = {}
    end

    local reactions      = messageReactions[msgId][emoji]
    local alreadyReacted = false

    for i, playerId in ipairs(reactions) do
        if playerId == src then
            alreadyReacted = true
            table.remove(reactions, i)
            break
        end
    end

    if not alreadyReacted and #reactions < Config.Reactions.maxPerMessage then
        table.insert(reactions, src)
    end

    TriggerClientEvent("cx-chat:updateReactions", -1, msgId, messageReactions[msgId])
end)

RegisterNetEvent("cx-chat:server:pinMessage")
AddEventHandler("cx-chat:server:pinMessage", function(msgData)
    if not Config.Pinning.enabled then return end

    local src = source
    if not IsPlayerAceAllowed(src, Config.Pinning.permission) then
        TriggerClientEvent("cx-chat:addMessage", src, {
            message  = "You don't have permission to pin messages.",
            color    = "#ef4444",
            isSystem = true,
        })
        return
    end

    if #pinnedMessages >= Config.Pinning.maxPinned then
        table.remove(pinnedMessages, 1)
    end

    table.insert(pinnedMessages, msgData)
    TriggerClientEvent("cx-chat:updatePinned", -1, pinnedMessages)
end)

RegisterNetEvent("cx-chat:server:unpinMessage")
AddEventHandler("cx-chat:server:unpinMessage", function(msgId)
    if not Config.Pinning.enabled then return end

    local src = source
    if not IsPlayerAceAllowed(src, Config.Pinning.permission) then return end

    for i, msg in ipairs(pinnedMessages) do
        if msg.id == msgId then
            table.remove(pinnedMessages, i)
            break
        end
    end

    TriggerClientEvent("cx-chat:updatePinned", -1, pinnedMessages)
end)

RegisterNetEvent("cx-chat:server:typing")
AddEventHandler("cx-chat:server:typing", function(targetId)
    if not Config.TypingIndicators.enabled then return end

    local src = source
    if targetId then
        TriggerClientEvent("cx-chat:showTyping", targetId, src)
    end
end)

RegisterNetEvent("cx-chat:server:editMessage")
AddEventHandler("cx-chat:server:editMessage", function(msgId, newText)
    if not Config.MessageEditing.enabled then return end

    local src = source
    local msg = messageHistory[msgId]

    if not msg then return end

    if msg.author ~= src then
        TriggerClientEvent("cx-chat:addMessage", src, {
            message  = "You can only edit your own messages.",
            color    = "#ef4444",
            isSystem = true,
        })
        return
    end

    local timeSince = GetGameTimer() - msg.timestamp
    if timeSince > (Config.MessageEditing.timeLimit * 1000) then
        TriggerClientEvent("cx-chat:addMessage", src, {
            message  = "You can only edit messages within " .. Config.MessageEditing.timeLimit .. " seconds.",
            color    = "#ef4444",
            isSystem = true,
        })
        return
    end

    local clean, blocked = FilterText(src, newText)
    if blocked then return end

    msg.message = clean
    msg.edited  = true

    TriggerClientEvent("cx-chat:messageEdited", -1, msgId, clean)
end)

RegisterNetEvent("cx-chat:server:deleteMessage")
AddEventHandler("cx-chat:server:deleteMessage", function(msgId)
    if not Config.MessageEditing.enabled then return end

    local src = source
    local msg = messageHistory[msgId]

    if not msg then return end

    local canDelete = IsPlayerAceAllowed(src, Config.MessageEditing.deletePermission)
    if not canDelete then
        TriggerClientEvent("cx-chat:addMessage", src, {
            message  = "You don't have permission to delete messages.",
            color    = "#ef4444",
            isSystem = true,
        })
        return
    end

    messageHistory[msgId] = nil
    TriggerClientEvent("cx-chat:messageDeleted", -1, msgId)

    CXLog("message_delete", {
        description = "Message deleted by " .. Config.GetCharacterName(src),
        metadata    = { msgId = msgId, deletedBy = src, originalAuthor = msg.author },
    })
end)

AddEventHandler("cx-chat:rpsChallenge", function(challenger, target, choice)
    local challengerName = Config.GetCharacterName(challenger)
    local targetName     = Config.GetCharacterName(target)

    local gameId = "rps_" .. challenger .. "_" .. target .. "_" .. GetGameTimer()
    rpsGames[gameId] = {
        challenger       = challenger,
        target           = target,
        challengerChoice = choice,
        targetChoice     = nil,
        created          = GetGameTimer(),
    }

    TriggerClientEvent("cx-chat:addMessage", target, {
        message   = string.format("**%s** challenged you to Rock, Paper, Scissors! Reply with /rps %d [choice]", challengerName, challenger),
        color     = "#60aaff",
        tag       = "RPS CHALLENGE",
        tagColor  = "#60aaff",
        isSystem  = true,
        playSound = true,
    })

    TriggerClientEvent("cx-chat:addMessage", challenger, {
        message  = string.format("Challenge sent to **%s**. Waiting for their response...", targetName),
        color    = "#60aaff",
        isSystem = true,
    })

    SetTimeout(Config.Minigames.rps.timeout, function()
        if rpsGames[gameId] and not rpsGames[gameId].targetChoice then
            rpsGames[gameId] = nil
            TriggerClientEvent("cx-chat:addMessage", challenger, {
                message  = "RPS challenge expired.",
                color    = "#ef4444",
                isSystem = true,
            })
        end
    end)
end)

RegisterNetEvent("cx-chat:server:mutePlayer")
AddEventHandler("cx-chat:server:mutePlayer", function(targetId, duration)
    local src = source
    if not IsPlayerAceAllowed(src, Config.MessageEditing.mutePermission or "cx-chat.mute") then
        TriggerClientEvent("cx-chat:addMessage", src, {
            message  = "You don't have permission to mute players.",
            color    = "#ef4444",
            isSystem = true,
        })
        return
    end

    local target = tonumber(targetId)
    if not target or not GetPlayerName(target) then
        TriggerClientEvent("cx-chat:addMessage", src, {
            message  = "Player not found.",
            color    = "#ef4444",
            isSystem = true,
        })
        return
    end

    duration = math.min(tonumber(duration) or 300, 86400)
    MutePlayerInternal(target, duration)

    TriggerClientEvent("cx-chat:addMessage", src, {
        message  = string.format("Player [%d] has been muted for %d seconds.", target, duration),
        color    = "#3dd68c",
        isSystem = true,
    })
end)

function StoreMessage(src, msgData)
    local msgId = genMsgId()
    messageHistory[msgId] = {
        id        = msgId,
        author    = src,
        message   = msgData.message,
        channel   = msgData.channel,
        timestamp = GetGameTimer(),
        edited    = false,
    }
    return msgId
end

AddEventHandler("playerDropped", function()
    local src = source
    mutedPlayers[src] = nil
end)

CreateThread(function()
    while true do
        Wait(60000)

        local now = GetGameTimer()

        for gameId, game in pairs(rpsGames) do
            if now - game.created > Config.Minigames.rps.timeout then
                rpsGames[gameId] = nil
            end
        end

        for msgId, msg in pairs(messageHistory) do
            if now - msg.timestamp > 600000 then
                messageHistory[msgId] = nil
            end
        end
    end
end)
