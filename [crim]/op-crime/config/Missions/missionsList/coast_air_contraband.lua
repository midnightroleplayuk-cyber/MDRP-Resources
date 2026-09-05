local MS = MissionShared

local isContrabandMission = false
local contrabandHasPackage = false
local contrabandPickupBlip = nil
local contrabandDeliverBlip = nil
local contrabandPickupMark = nil
local contrabandDeliverMark = nil

local contrabandPickupCoords = {
    vec4(-1844.0974, -1239.3287, 12.0172, 332.6830),
    vec4(-1605.89, -1038.33, 12.10, 318),
    vector4(3809.29, 4461.04, 3.28, 90),
}

local contrabandDeliverCoords = {
    vec4(1127.92, -3144.51, 5.90, 178),
    vec4(1536.87, 1702.52, 108.67, 87),
    vec4(-298.4570, 2816.2266, 58.4916, 204.2251),
}

local function clearContrabandState()
    if contrabandPickupBlip then RemoveBlip(contrabandPickupBlip) end
    if contrabandDeliverBlip then RemoveBlip(contrabandDeliverBlip) end
    if contrabandPickupMark then SH.RemoveMarkedCoords(contrabandPickupMark) end
    if contrabandDeliverMark then SH.RemoveMarkedCoords(contrabandDeliverMark) end
    contrabandPickupBlip = nil
    contrabandDeliverBlip = nil
    contrabandPickupMark = nil
    contrabandDeliverMark = nil
    contrabandHasPackage = false
    isContrabandMission = false
end

local function deliverContrabandPackage()
    if not contrabandHasPackage then
        sendNotify(TranslateIt('mission_contraband_no_package'), "error", 6)
        return
    end

    if GetPlayerWantedLevel(PlayerId()) > 0 then
        sendNotify(TranslateIt('mission_contraband_wanted_level'), "error", 8)
        return
    end

    clearContrabandState()
    sendNotify(TranslateIt('mission_contraband_delivered_success'), "success", 8)
    TriggerServerEvent('op-crime:endMission', "coast_air_contraband")
end

local function pickupContrabandPackage()
    if contrabandHasPackage then return end

    local success = lib.progressCircle({
        duration = 6500,
        position = 'bottom',
        label = TranslateIt('mission_contraband_pickup_progress'),
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = false, combat = true }
    })

    if not success then
        sendNotify(TranslateIt('mission_contraband_pickup_cancelled'), "error", 6)
        return
    end

    contrabandHasPackage = true
    if contrabandPickupMark then SH.RemoveMarkedCoords(contrabandPickupMark) end
    if contrabandPickupBlip then RemoveBlip(contrabandPickupBlip) end
    contrabandPickupMark = nil
    contrabandPickupBlip = nil

    local deliverCoords = contrabandDeliverCoords[math.random(1, #contrabandDeliverCoords)]
    contrabandDeliverBlip = SH.addBlip(deliverCoords.xyz, 280, 2, TranslateIt('mission_contraband_deliver_blip'))
    SetBlipAsShortRange(contrabandDeliverBlip, false)
    SetNewWaypoint(deliverCoords.x, deliverCoords.y)

    local ped = {
        heading = deliverCoords.w,
        model = "g_m_m_chigoon_01",
        gender = "male",
    }

    contrabandDeliverMark = SH.MarkNewCoords(deliverCoords, {type = 6, size = vec3(Config.Misc.zoneSize, Config.Misc.zoneSize, Config.Misc.zoneSize), color = Config.Misc.zoneColor}, false, ped, function()
    end, function()
        deliverContrabandPackage()
    end, {
        name = "mission_contraband_deliver",
        label = TranslateIt('mission_contraband_deliver_label'),
        icon = "fa-solid fa-box-open"
    })

    sendNotify(TranslateIt('mission_contraband_pickup_success'), "info", 8)
end

function startCoastAirContrabandMission()
    if isContrabandMission then return end
    lib.alertDialog({
        header = TranslateIt('mission_contraband_alert_header'),
        content = TranslateIt('mission_contraband_alert_desc'),
        centered = true,
        cancel = false,
        labels = { confirm = TranslateIt('mission_generic_understood') }
    })

    isContrabandMission = true
    contrabandHasPackage = false

    local pickup = contrabandPickupCoords[math.random(1, #contrabandPickupCoords)]
    contrabandPickupBlip = SH.addBlip(pickup.xyz, 501, 3, TranslateIt('mission_contraband_pickup_blip'))
    SetBlipAsShortRange(contrabandPickupBlip, false)
    SetNewWaypoint(pickup.x, pickup.y)

    local ped = {
        heading = pickup.w,
        model = "g_m_y_mexgoon_03",
        gender = "male",
    }

    contrabandPickupMark = SH.MarkNewCoords(pickup, {type = 6, size = vec3(Config.Misc.zoneSize, Config.Misc.zoneSize, Config.Misc.zoneSize), color = Config.Misc.zoneColor}, false, ped, function()
    end, function()
        pickupContrabandPackage()
    end, {
        name = "mission_contraband_pickup",
        label = TranslateIt('mission_contraband_pickup_label'),
        icon = "fa-solid fa-water"
    })
end

