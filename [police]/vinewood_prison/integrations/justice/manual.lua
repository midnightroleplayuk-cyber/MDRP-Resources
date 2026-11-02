-- Fallback when no justice script is installed: the prisoner is told their licence terms.
Prison.adapters.justice.manual = {
    fallback = true,
    onRelease = function(prisoner, _, licence)
        if prisoner.source and licence and licence.type == 'licence' and licence.licenceSeconds > 0 then
            Prison.notify(prisoner.source, locale('released_licence', Prison.formatDuration(licence.licenceSeconds)))
        end
    end,
}
