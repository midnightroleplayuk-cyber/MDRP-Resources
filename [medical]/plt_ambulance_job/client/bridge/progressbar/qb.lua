if Bridge.ProgressBar ~= 'progressbar' then return end

ProgressBar = ProgressBar or {}

function ProgressBar.showProgress(options, onFinish, onCancel)
    exports.progressbar:Progress({
        name         = options.title,
        duration     = options.duration,
        label        = options.title,
        useWhileDead = options.useWhileDead or false,
        canCancel    = options.canCancel == nil and true or options.canCancel,
        animation    = options.animation and {
            animDict = options.animation.dict,
            anim     = options.animation.anim,
            flags    = options.animation.flag or 49,
        } or nil,
        controlDisables = options.disable and {
            disableMovement    = options.disable.move or false,
            disableCarMovement = options.disable.car or false,
            disableMouse       = options.disable.mouse or false,
            disableCombat      = options.disable.combat or false,
        } or nil,
        prop    = options.prop,
        propTwo = options.propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish then onFinish() end
        else
            if onCancel then onCancel() end
        end
    end)
end
