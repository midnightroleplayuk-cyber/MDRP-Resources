if not Config.Modules['DisableCombatRoll'] then return end

local function CombatRollThread()
    CreateThread(function()
        while Armed do
            local sleepThread = 0

            SetPedResetFlag(PlayerPedId(), 446, true)
            Wait(sleepThread)
        end
    end)
end

lib.onCache('weapon', function(weapon)
    Wait(0)
    if not weapon then
        Armed = false
        return
    end
    Armed = true
    CombatRollThread()
end)
