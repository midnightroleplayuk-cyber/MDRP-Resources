Bridge = Bridge or {}

function Bridge.Notify(message, notifyType)
    lib.notify({ description = message, type = notifyType or 'inform' })
end

function Bridge.ProgressBar(duration, label, position, useWhileDead, canCancel, disableControls)
    return lib.progressBar({
        label = label,
        duration = duration,
        position = position,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        disable = disableControls
    })
end