
if IsDuplicityVersion and not IsDuplicityVersion() then return end
if _G.__twEventGateInstalled then return end
_G.__twEventGateInstalled = true

local _tce  = TriggerClientEvent
local _tlce = TriggerLatentClientEvent

local dropped, lastReport = 0, 0

local function targetOk(target, event)
    if target == -1 then return true end
    if type(target) == 'table' then return true end

    local n = tonumber(target)
    if n and n > 0 then return true end

    dropped = dropped + 1
    if Config and Config.Debug then
        local now = GetGameTimer and GetGameTimer() or 0
        if now - lastReport > 2000 then
            lastReport = now
            print(('^3[event_gate]^7 dropped %s — target is %s (player gone?), %d total')
                :format(tostring(event), tostring(target), dropped))
        end
    end
    return false
end

function TriggerClientEvent(event, target, ...)
    if not targetOk(target, event) then return end
    return _tce(event, target, ...)
end

function TriggerLatentClientEvent(event, target, bps, ...)
    if not targetOk(target, event) then return end
    return _tlce(event, target, bps, ...)
end
