CreateThread(function()
    for _, emitter in ipairs(Config.GTAEmitters) do
        SetStaticEmitterEnabled(emitter, false)
    end
end)