if Sky.Config.medical ~= "visn_are" then return end

local RESOURCE = "visn_are"

function Sky.Functions.ResetMedicalState()
    local state = GetResourceState(RESOURCE)
    if state ~= "started" then
        error("Medical integration '" .. RESOURCE .. "' is unavailable; resource state=" .. state, 2)
    end
    -- Vendor-documented supplement to a framework/native revive; no guessed shared-function namespace.
    TriggerEvent("visn_are:resetHealthBuffer")
end
