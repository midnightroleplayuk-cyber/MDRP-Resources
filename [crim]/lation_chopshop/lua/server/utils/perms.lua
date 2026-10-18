--- Permission helpers (escrow ignored — customize admin access here).

--- @param source number
--- @return boolean
function IsAdmin(source)
    return IsPlayerAceAllowed(source, 'lation_chopshop.admin')
end
