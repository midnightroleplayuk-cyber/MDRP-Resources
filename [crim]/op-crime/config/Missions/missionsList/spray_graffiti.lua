local MS = MissionShared

local isSprayStarted = false
local totalSprayed = 0

function startSprayGraffitiMission()
    isSprayStarted = true
    totalSprayed = 0
    lib.alertDialog({
        header = TranslateIt('sprayMission_header'),
        content = TranslateIt('sprayMission_desc'),
        centered = true,
        cancel = false,
        labels = { confirm = TranslateIt('sprayMission_Okay') }
    })
end

function graffitiPainted()
    totalSprayed = totalSprayed + 1
    if totalSprayed == 3 then
        TriggerServerEvent('op-crime:endMission', "spray_graffiti")
        isSprayStarted = false
        totalSprayed = 0
    end
end

