if Sky.Config.medical ~= "custom" then return end

-- Supplement the medical owner's completed revive with your external injury-buffer reset.
-- This must not revive, teleport, change permissions or acknowledge a consumer's respawn.
function Sky.Functions.ResetMedicalState()
    error("Custom medical integration: ResetMedicalState is not implemented", 2)
end
