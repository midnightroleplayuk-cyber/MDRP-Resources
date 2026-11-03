-- Add your Fivemanage API token(s) here:
local photoToken = "" -- used for photos
local videoToken = "" -- used for videos

lib.callback.register("av_cameras:takePhoto", function(_, action)
    dbug("Callback triggered for action: " .. tostring(action))
    if action == "image" then
        return photoToken
    elseif action == "video" then
        return videoToken
    end
    return nil
end)