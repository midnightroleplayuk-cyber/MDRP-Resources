local MS = MissionShared

local isRecoverStashMission = false
local recoverStashHasPackage = false
local recoverStashRaidBlip = nil
local recoverStashDeliverBlip = nil
local recoverStashRaidMark = nil
local recoverStashDeliverMark = nil
local recoverStashEnemyPeds = {}
local recoverStashRaidCoordsCurrent = nil
local recoverStashDeliverCoordsCurrent = nil

local recoverStashRaidCoords = {
    vec4(1451.33, -2606.52, 47.44, 40),
    vec4(-1307.64, -1595.66, 3.23, 299),
    vec4(2196.08, 5186.41, 57.97, 189),
}

local recoverStashDeliverCoords = {
    vec4(-42.36, -1748.82, 29.42, 145),
    vec4(1365.51, -1721.53, 65.63, 12),
    vec4(1997.23, 3039.15, 46.03, 149),
}

local function clearRecoverStashMissionState()
    if recoverStashRaidBlip then RemoveBlip(recoverStashRaidBlip) end
    if recoverStashDeliverBlip then RemoveBlip(recoverStashDeliverBlip) end
    if recoverStashRaidMark then SH.RemoveMarkedCoords(recoverStashRaidMark) end
    if recoverStashDeliverMark then SH.RemoveMarkedCoords(recoverStashDeliverMark) end

    for i = #recoverStashEnemyPeds, 1, -1 do
        local ped = recoverStashEnemyPeds[i]
        if DoesEntityExist(ped) then DeletePed(ped) end
        recoverStashEnemyPeds[i] = nil
    end

    recoverStashHasPackage = false
    recoverStashRaidBlip = nil
    recoverStashDeliverBlip = nil
    recoverStashRaidMark = nil
    recoverStashDeliverMark = nil
    recoverStashRaidCoordsCurrent = nil
    recoverStashDeliverCoordsCurrent = nil
    isRecoverStashMission = false
end

local function spawnRecoverStashAmbushAt(coords, count)
    for i = 1, (count or 4) do
        local angle = math.rad((i / (count or 4)) * 360.0)
        local x = coords.x + math.cos(angle) * (10.0 + math.random(2, 6))
        local y = coords.y + math.sin(angle) * (10.0 + math.random(2, 6))
        local z = MS.groundZ(x, y, coords.z)
        local ped = MS.spawnGuardAt("g_m_y_mexgoon_02", x, y, z, math.random(0, 359) + 0.0)
        if ped then
            MS.taskAggressiveAgainstPlayers(ped)
            table.insert(recoverStashEnemyPeds, ped)
        end
    end
end

local function finishRecoverStashMission()
    if not recoverStashHasPackage then
        sendNotify("You have not recovered the stash yet.", "error", 7)
        return
    end

    clearRecoverStashMissionState()
    sendNotify("Stash recovered and secured for your organization.", "success", 8)
    TriggerServerEvent('op-crime:endMission', "recover_stash_raid")
end

local function lootRecoverStash()
    if recoverStashHasPackage then return end

    local success = lib.progressCircle({
        duration = 9000,
        position = 'bottom',
        label = "Recovering seized stash...",
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true }
    })

    if not success then
        sendNotify("You cancelled stash recovery.", "error", 6)
        return
    end

    recoverStashHasPackage = true
    if recoverStashRaidMark then SH.RemoveMarkedCoords(recoverStashRaidMark) end
    if recoverStashRaidBlip then RemoveBlip(recoverStashRaidBlip) end
    recoverStashRaidMark = nil
    recoverStashRaidBlip = nil

    local p = GetEntityCoords(PlayerPedId())
    spawnRecoverStashAmbushAt(vec3(p.x, p.y, p.z), 5)

    recoverStashDeliverBlip = SH.addBlip(recoverStashDeliverCoordsCurrent.xyz, 280, 2, "Stash Delivery")
    SetBlipAsShortRange(recoverStashDeliverBlip, false)
    SetNewWaypoint(recoverStashDeliverCoordsCurrent.x, recoverStashDeliverCoordsCurrent.y)

    local ped = {
        heading = recoverStashDeliverCoordsCurrent.w,
        model = "g_m_m_armboss_01",
        gender = "male",
    }

    recoverStashDeliverMark = SH.MarkNewCoords(recoverStashDeliverCoordsCurrent, {type = 6, size = vec3(Config.Misc.zoneSize, Config.Misc.zoneSize, Config.Misc.zoneSize), color = Config.Misc.zoneColor}, false, ped, function()
    end, function()
        finishRecoverStashMission()
    end, {
        name = "mission_recover_stash_deliver",
        label = "Deliver recovered stash",
        icon = "fa-solid fa-box-archive"
    })

    sendNotify("Stash recovered. Survive the ambush and deliver it.", "warning", 8)
end

function startRecoverStashAfterRaidMission()
    if isRecoverStashMission then return end

    lib.alertDialog({
        header = "Recover Stash After Raid",
        content = "Locate seized stash, recover it and deliver to a safe point.",
        centered = true,
        cancel = false,
        labels = { confirm = "Understood" }
    })

    isRecoverStashMission = true
    recoverStashHasPackage = false
    MS.createRelationshipGroup()

    recoverStashRaidCoordsCurrent = recoverStashRaidCoords[math.random(1, #recoverStashRaidCoords)]
    recoverStashDeliverCoordsCurrent = recoverStashDeliverCoords[math.random(1, #recoverStashDeliverCoords)]

    recoverStashRaidBlip = SH.addBlip(recoverStashRaidCoordsCurrent.xyz, 478, 1, "Stash after raid")
    SetBlipAsShortRange(recoverStashRaidBlip, false)
    SetNewWaypoint(recoverStashRaidCoordsCurrent.x, recoverStashRaidCoordsCurrent.y)

    Citizen.CreateThread(function()
        while isRecoverStashMission do
            local playerCoords = GetEntityCoords(PlayerPedId())
            if #(playerCoords - recoverStashRaidCoordsCurrent.xyz) < 130.0 then
                break
            end
            Wait(350)
        end
        if not isRecoverStashMission then return end

        local positions = {
            vec3(recoverStashRaidCoordsCurrent.x + 8.0, recoverStashRaidCoordsCurrent.y + 1.0, recoverStashRaidCoordsCurrent.z),
            vec3(recoverStashRaidCoordsCurrent.x - 7.0, recoverStashRaidCoordsCurrent.y - 4.0, recoverStashRaidCoordsCurrent.z),
            vec3(recoverStashRaidCoordsCurrent.x + 2.0, recoverStashRaidCoordsCurrent.y + 10.0, recoverStashRaidCoordsCurrent.z),
            vec3(recoverStashRaidCoordsCurrent.x - 4.0, recoverStashRaidCoordsCurrent.y + 8.0, recoverStashRaidCoordsCurrent.z),
        }

        for _, p in ipairs(positions) do
            local ped = MS.spawnGuardAt("g_m_y_mexgoon_01", p.x, p.y, p.z, math.random(0, 359) + 0.0)
            if ped then table.insert(recoverStashEnemyPeds, ped) end
        end
        MS.taskGuards(recoverStashEnemyPeds)

        local ped = {
            heading = recoverStashRaidCoordsCurrent.w,
            model = "s_m_m_security_01",
            gender = "male",
        }

        recoverStashRaidMark = SH.MarkNewCoords(recoverStashRaidCoordsCurrent, {type = 6, size = vec3(Config.Misc.zoneSize, Config.Misc.zoneSize, Config.Misc.zoneSize), color = Config.Misc.zoneColor}, false, ped, function()
        end, function()
            lootRecoverStash()
        end, {
            name = "mission_recover_stash_loot",
            label = "Recover seized stash",
            icon = "fa-solid fa-unlock"
        })
    end)
end

