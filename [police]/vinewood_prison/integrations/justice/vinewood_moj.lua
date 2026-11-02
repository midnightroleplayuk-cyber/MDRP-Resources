-- Vinewood MoJ owns the court decision and probation. The MoJ script calls
-- exports.vinewood_prison:Imprison(...); at discharge the prison calls back:
--   exports.vinewood_moj:OnCustodyReleased(identifier, caseRef, licence)
-- licence = { type = 'licence' | 'unconditional' | 'remand_release', licenceSeconds, prisonNo, reason }
Prison.adapters.justice.vinewood_moj = {
    resource = 'vinewood_moj',
    onRelease = function(prisoner, sentence, licence)
        local ok, err = pcall(function()
            exports.vinewood_moj:OnCustodyReleased(prisoner.identifier, sentence and sentence.external_ref, licence)
        end)
        if not ok then Prison.warn('vinewood_moj OnCustodyReleased failed: %s', err) end
    end,
}
