-- ownerId:number Server ID of the player that owns the camera
-- identifier:string Camera identifier
-- label:string Camera label
-- playerId:number Server ID of the player that triggered the activity
-- activityType:string Type of activity that triggered the alert (e.g., "motion")

function sendAlert(ownerId, identifier, label, playerId, activityType)
    dbug("Sending alert for camera "..label.." owned by ("..ownerId..") for activity type "..activityType.." triggered by player with server id ("..playerId..")")
    local text = string.format(Lang['motion_detected'], label)
    TriggerClientEvent("av_laptop:notification", ownerId, Lang['app_title'], text, "warning")
end