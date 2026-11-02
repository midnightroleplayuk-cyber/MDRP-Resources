
-- Message handler for camera assignment requests
lib.callback.register("av_cameras:requestCameraAssignment", function()
    local result = lib.alertDialog({
        header = Lang['app_title'],
        content = Lang['camera_assignment_request'],
        centered = true,
        cancel = true
    })
    return result == "confirm" and true or false
end)

-- Sharing group request
lib.callback.register("av_cameras:requestGroupShare", function(shareType)
    local text = shareType == "group" and Lang['group_share_request'] or Lang['camera_share_request']
    local result = lib.alertDialog({
        header = Lang['app_title'],
        content = text,
        centered = true,
        cancel = true
    })
    return result == "confirm" and true or false
end)