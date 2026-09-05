local lastMsg = {}

function IsSpamming(src)
    if not src or src == 0 then return false end

    local now      = GetGameTimer()
    local cooldown = Config.MessageCooldown or 1000

    if lastMsg[src] and (now - lastMsg[src]) < cooldown then
        local wait = math.ceil((cooldown - (now - lastMsg[src])) / 1000)
        TriggerClientEvent("cx-chat:addMessage", src, {
            message  = "Slow down! Wait " .. wait .. " more second(s).",
            color    = "#ef4444",
            isSystem = true,
        })
        return true
    end

    lastMsg[src] = now
    return false
end

AddEventHandler("playerDropped", function()
    lastMsg[source] = nil
end)
