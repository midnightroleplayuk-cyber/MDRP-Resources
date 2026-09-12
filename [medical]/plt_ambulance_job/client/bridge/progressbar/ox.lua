if Bridge.ProgressBar ~= 'ox_lib' then return end

ProgressBar = ProgressBar or {}

function ProgressBar.showProgress(options, onFinish, onCancel)
    local success = exports['ox_lib']:progressBar({
        duration     = options.duration,
        label        = options.title,
        useWhileDead = options.useWhileDead or false,
        canCancel    = options.canCancel == nil and true or options.canCancel,
        anim         = options.animation and {
            dict  = options.animation.dict,
            clip  = options.animation.anim,
            flags = options.animation.flag,
        } or nil,
        disable = options.disable or {},
        prop    = options.prop,
    })

    if success then
        if onFinish then onFinish() end
    else
        if onCancel then onCancel() end
    end
end
