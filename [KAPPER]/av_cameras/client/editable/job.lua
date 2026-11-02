function canUseJob() -- can add camera to job group
    return exports['av_laptop']:isBoss()
end

function canDelete() -- delete job camera
    return exports['av_laptop']:isBoss()
end