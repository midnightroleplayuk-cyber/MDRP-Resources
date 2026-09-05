local MS = MissionShared

local weedDeliveryMarked = nil
local weedDeliveryCoords = vec4(1698.8948, 6438.6714, 31.7840, 284.9956)
local weedBlip = nil

local function backWithDrugs()
    Fr.TriggerServerCallback('op-crime:sellDrugs', function(res)
        if res then
            if weedBlip then RemoveBlip(weedBlip) end
            weedBlip = nil
            if weedDeliveryMarked then SH.RemoveMarkedCoords(weedDeliveryMarked) end
            weedDeliveryMarked = nil
            sendNotify(TranslateIt('drugDeliver_notify_success'), "success", 5)
            TriggerServerEvent('op-crime:endMission', "drug_sell_npc")
        else
            sendNotify(TranslateIt('drugDeliver_notify_error'), "error", 5)
        end
    end)
end

function startWeedDelivey()
    local ped = {
        heading = weedDeliveryCoords.w,
        model = "g_m_y_pologoon_01",
        gender = "male",
    }

    lib.alertDialog({
        header = TranslateIt('drugDeliver_dialog_header'),
        content = TranslateIt('drugDeliver_dialog_desc'),
        centered = true,
        cancel = false,
        labels = { confirm = TranslateIt('drugDeliver_dialog_Okay') }
    })

    weedBlip = SH.addBlip(weedDeliveryCoords.xyz, 140, 2, TranslateIt('drugDeliver_dialog_blip'))
    SetBlipAsShortRange(weedBlip, false)

    weedDeliveryMarked = SH.MarkNewCoords(weedDeliveryCoords, {type = 6, size = vec3(Config.Misc.zoneSize, Config.Misc.zoneSize, Config.Misc.zoneSize), color = Config.Misc.zoneColor}, false, ped, function()
    end, function()
        backWithDrugs()
    end, {
        name = "mission_selldrugs_safe",
        label = TranslateIt('drugDeliver_dialog_target'),
        icon = TranslateIt('drugDeliver_dialog_icon')
    })
end

RegisterNetEvent('op-crime:cancelMissionClient')
AddEventHandler('op-crime:cancelMissionClient', function(missionIndex)
    if missionIndex and missionIndex ~= 'drug_sell_npc' and missionIndex ~= 'all' then return end
    if weedBlip then RemoveBlip(weedBlip) end
    weedBlip = nil
    if weedDeliveryMarked then SH.RemoveMarkedCoords(weedDeliveryMarked) end
    weedDeliveryMarked = nil
end)

