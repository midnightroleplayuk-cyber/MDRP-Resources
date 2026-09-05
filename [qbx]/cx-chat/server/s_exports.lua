exports('SendCustomMessage', function(data)
    if type(data) ~= "table" then return false end

    local msgData = {
        message   = data.message or "",
        name      = data.name,
        color     = data.color or "#cbd5e1",
        tag       = data.tag,
        tagColor  = data.tagColor,
        channel   = data.channel or Config.DefaultChannel,
        isSystem  = data.isSystem or false,
        playSound = data.playSound or false,
    }

    if data.target and tonumber(data.target) then
        TriggerClientEvent("cx-chat:addMessage", tonumber(data.target), msgData)
    else
        TriggerClientEvent("cx-chat:addMessage", -1, msgData)
    end

    return true
end)

exports('SendRichMessage', function(data)
    if type(data) ~= "table" then return false end

    local message = ""
    if data.title then
        message = "**" .. data.title .. "**"
    end

    if data.description then
        if message ~= "" then message = message .. "\n" end
        message = message .. data.description
    end

    if data.fields and type(data.fields) == "table" then
        for _, field in ipairs(data.fields) do
            if field.name and field.value then
                message = message .. "\n**" .. field.name .. ":** " .. field.value
            end
        end
    end

    local msgData = {
        message   = message,
        color     = data.color or "#cbd5e1",
        tag       = data.tag or "INFO",
        tagColor  = data.color or "#cbd5e1",
        channel   = data.channel or Config.DefaultChannel,
        isSystem  = true,
        playSound = data.playSound or false,
    }

    if data.target and tonumber(data.target) then
        TriggerClientEvent("cx-chat:addMessage", tonumber(data.target), msgData)
    else
        TriggerClientEvent("cx-chat:addMessage", -1, msgData)
    end

    return true
end)

exports('MutePlayer', function(src, duration)
    src      = tonumber(src)
    duration = tonumber(duration) or 300
    if not src then return false end
    MutePlayerInternal(src, duration)
    return true
end)

exports('GetChatHistory', function(channel, limit)
    limit = tonumber(limit) or 50
    local history = GetMessageHistory()
    local result  = {}

    for _, msg in pairs(history) do
        if not channel or msg.channel == channel then
            table.insert(result, msg)
        end
    end

    table.sort(result, function(a, b) return a.timestamp < b.timestamp end)

    if #result > limit then
        local trimmed = {}
        for i = #result - limit + 1, #result do
            table.insert(trimmed, result[i])
        end
        return trimmed
    end

    return result
end)

exports('AddReaction', function(msgId, playerId, emoji)
    if not Config.Reactions.enabled then return false end
    TriggerEvent("cx-chat:server:addReaction", msgId, emoji)
    return true
end)

exports('PinMessage', function(msgData)
    if not Config.Pinning.enabled then return false end
    TriggerEvent("cx-chat:server:pinMessage", msgData)
    return true
end)

exports('UnpinMessage', function(msgId)
    if not Config.Pinning.enabled then return false end
    TriggerEvent("cx-chat:server:unpinMessage", msgId)
    return true
end)
