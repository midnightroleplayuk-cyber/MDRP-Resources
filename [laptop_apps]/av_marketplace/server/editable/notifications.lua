function notification(playerId, message)
    dbug("Sending notification to", playerId, "with message:", message)
    TriggerClientEvent("av_laptop:notification", playerId, Lang['app_title'], Lang['new_offer'], "inform")
end