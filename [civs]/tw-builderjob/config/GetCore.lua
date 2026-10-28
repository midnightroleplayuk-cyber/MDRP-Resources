-- ============================================================================
-- BASE EXPORTS + GetCore() (shared)
-- ============================================================================
-- Public contract: `_event()`, `GetCore()`, `base.deepCopy()`. Framework object
-- retrieval lives in config/bridges/<fw>.lua; GetCore() resolves the active
-- bridge lazily on first call and caches it.

base = {}
base.resource = GetCurrentResourceName()
base.SQLName = 'tw_builder'

--- @param event string
--- @return string
function _event(event)
    return base.resource .. ':' .. event
end

function GetCore()
    local Framework = Config and Config.Framework
    if not Framework then return nil, nil end

    -- Lazy bridge resolution: the selection waits until Config.Framework is loaded.
    if not (TworstBridge and TworstBridge.active) then
        if TworstBridge and TworstBridge.find then
            TworstBridge.active = TworstBridge.find(Framework)
        end
    end

    if not (TworstBridge and TworstBridge.active and TworstBridge.active.loadCore) then
        print(('^1[tw-builderjob]^7 GetCore() called but no bridge active for Config.Framework=%s — supported: qb, oldqb, qbox, esx, oldesx, vrp, vrp2, tmc, standalone'):format(tostring(Framework)))
        return nil, Framework
    end

    return TworstBridge.active.loadCore(), Framework
end

function base.deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[base.deepCopy(orig_key)] = base.deepCopy(orig_value)
        end
        setmetatable(copy, base.deepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end
