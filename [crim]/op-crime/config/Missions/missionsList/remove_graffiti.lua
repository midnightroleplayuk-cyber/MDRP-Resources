local MS = MissionShared

local isSprayRemoveStarted = false
local totalRemoved = 0

function startRemoveGraffitiMission()
    isSprayRemoveStarted = true
    totalRemoved = 0
    lib.alertDialog({
        header = TranslateIt('sprayMission_2_header'),
        content = TranslateIt('sprayMission_2_desc'),
        centered = true,
        cancel = false,
        labels = { confirm = TranslateIt('sprayMission_2_Okay') }
    })
end

function graffitiRemoved()
    totalRemoved = totalRemoved + 1
    if totalRemoved == 5 then
        TriggerServerEvent('op-crime:endMission', "remove_graffiti")
        isSprayRemoveStarted = false
        totalRemoved = 0
    end
end

