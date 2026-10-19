--[[
    Apex MDT - Server Exports
    ────────────────────────────────────────────────────────────
    Namespaced under 'apex_mdt'. Use from any resource:

        exports.apex_mdt:CreateCall({ mode='police', type='shots', ... })
        exports.apex_mdt:GetMode(source)
        exports.apex_mdt:IsOnDuty(source)
        exports.apex_mdt:OpenFor(source)
        exports.apex_mdt:GetUnits('police')
]]

-- Mode / duty queries (wrap the internals set at the end of server.lua).
exports('GetMode', function(src)
    if _GET_JOBINFO and _RESOLVE_MODE then
        return _RESOLVE_MODE(select(1, _GET_JOBINFO(src)))
    end
    return nil
end)

exports('IsOnDuty', function(src)
    if not _UNITS then return false end
    local u = _UNITS()[src]
    return u ~= nil and u.duty == true
end)

exports('GetUnits', function(mode)
    if not _UNITS then return {} end
    local out = {}
    for _, u in pairs(_UNITS()) do
        if (not mode) or u.mode == mode then
            out[#out + 1] = { callsign = u.callsign, name = u.name, job = u.job, status = u.status, coords = u.coords }
        end
    end
    return out
end)

-- ─── Dispatch: let other resources raise a CAD call ─────
-- data = { mode, type, code, label, priority, desc, location, coords, postal, caller }
exports('CreateCall', function(data)
    if _CREATE_CALL and type(data) == 'table' then
        return _CREATE_CALL(data, nil)
    end
    return nil
end)

-- ─── UI control ─────────────────────────────────────────
exports('OpenFor',  function(src) TriggerClientEvent('apex_mdt:open',  src) end)
exports('CloseFor', function(src) TriggerClientEvent('apex_mdt:close', src) end)

-- ─── Audit / Discord passthrough for owner scripts ──────
exports('Audit', function(src, action, detail) if _AUDIT then _AUDIT(src, action, detail) end end)
exports('Discord', function(channel, title, desc, color) if _DISCORD then _DISCORD(channel, title, desc, color) end end)
