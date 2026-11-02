function Notify(title, message, type)
    TriggerEvent("av_laptop:notification", title, message, type or "info")
end
