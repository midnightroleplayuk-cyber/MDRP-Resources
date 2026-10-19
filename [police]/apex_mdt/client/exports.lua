--[[
    Apex MDT - Client Exports
    ────────────────────────────────────────────────────────────
        exports.apex_mdt:OpenMDT()
        exports.apex_mdt:CloseMDT()
        if exports.apex_mdt:IsOpen() then ... end
        if exports.apex_mdt:IsOnDuty() then ... end
        exports.apex_mdt:ToggleDuty()
        exports.apex_mdt:Panic()
]]

exports('OpenMDT',   function() if UI then UI.OpenPanel() end end)
exports('CloseMDT',  function() if UI then UI.ClosePanel() end end)
exports('IsOpen',    function() return UI and UI.IsOpen() or false end)
exports('IsOnDuty',  function() return Duty and Duty.IsOn() or false end)
exports('ToggleDuty', function() if Duty then Duty.Toggle() end end)
exports('Panic',     function() if Dispatch then Dispatch.Panic() end end)

-- ox_inventory usable-item hook (optional; see installation/items.md).
exports('useTablet', function() if UI then UI.OpenPanel() end end)

-- Server-triggered UI control.
RegisterNetEvent('apex_mdt:openPanel',  function() if UI then UI.OpenPanel() end end)
RegisterNetEvent('apex_mdt:closePanel', function() if UI then UI.ClosePanel() end end)
