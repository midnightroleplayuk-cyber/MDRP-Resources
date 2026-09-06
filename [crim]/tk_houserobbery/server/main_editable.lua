function Notify(src, text, notifyType)
    if Config.NotificationType == 'mythic' then
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = notifyType, text = text})
    elseif Config.NotificationType == 'ox' then
        lib.notify(src, {
            title = 'House Robbery',
            description = text,
            type = notifyType
        })
    else
        ShowNotification(src, text, notifyType)
    end
end

function Webhook(message)
    local webhookLink = '' -- place your webhook link here on this line inside the quotes
    if not webhookLink or webhookLink == '' then return end

    local msg = {{["color"] = Config.WebhookColor, ["title"] = "**".. _U('webhook_title') .."**", ["description"] = message, ["footer"] = { ["text"] = os.date("%d.%m.%y Time: %X")}}}
    PerformHttpRequest(webhookLink, function(err, text, headers) end, 'POST', json.encode({embeds = msg}), { ['Content-Type'] = 'application/json' })
end

---Player entered a house
---@param playerId number
---@param houseIndex number
---@param usedLockpick boolean true if this player was the player who lockpicked the door of the house, false if they just entered the house via open door or if they were a police
function EnteredHouse(playerId, houseIndex, usedLockpick)

end

---Player exited a house
---@param playerId number
---@param houseIndex number
---@param usedLockpick boolean true if this player was the player who lockpicked the door of the house, false if they just entered the house via open door or if they were a police
function ExitedHouse(playerId, houseIndex, usedLockpick)

end