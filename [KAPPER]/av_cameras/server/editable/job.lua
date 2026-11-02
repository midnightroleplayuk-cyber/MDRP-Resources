-- Retrieve player permission to access Business cameras
function getCameraPermission(playerId)
    local permission = false
    if GetResourceState("av_business") == "started" then
        local permissions = exports['av_business']:getPermissions(playerId)
        permission = permissions and permissions['cameras'] or false
    end
    dbug("getCameraPermission(permission?)", permission)
    return permission
end