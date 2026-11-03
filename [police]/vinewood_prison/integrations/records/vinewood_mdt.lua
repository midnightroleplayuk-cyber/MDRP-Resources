-- Pushes custody status to Vinewood MDT:
--   exports.vinewood_mdt:SetCustodyStatus(identifier, status, data)
-- status = 'in_custody' | 'released' ; data = { prisonNo, prison, cell, releaseEstimate }
Prison.adapters.records.vinewood_mdt = {
    resource = 'vinewood_mdt',
    setCustodyStatus = function(identifier, status, data)
        local ok, err = pcall(function()
            exports.vinewood_mdt:SetCustodyStatus(identifier, status, data)
        end)
        if not ok then Prison.warn('vinewood_mdt SetCustodyStatus failed: %s', err) end
    end,
}
