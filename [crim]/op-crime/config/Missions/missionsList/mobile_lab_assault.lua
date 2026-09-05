local MS = MissionShared

local isMobileLabMission = false
local mobileLabVan = nil
local mobileLabVanNetId = nil
local mobileLabVanPlate = nil
local mobileLabSpawnBlip = nil
local mobileLabDeliverBlip = nil
local mobileLabDeliverMark = nil
local mobileLabEnemyPeds = {}
local mobileLabEscortVehs = {}
local mobileLabAssaultCoordsCurrent = nil
local mobileLabDeliverCoordsCurrent = nil

local mobileLabAssaultCoords = {
    vec4(997.38, -2502.96, 27.30, 68),
    vec4(1222.99, 2708.34, 37.01, 182),
    vec4(-1680.18, -900.37, 8.32, 313),
}

local mobileLabDeliverCoords = {
    vec4(-298.1332, 6303.0474, 30.4901, 224.2017),
    vec4(2681.50, 3460.19, 55.74, 161),
    vec4(1717.50, 4804.11, 40.73, 93),
}

local function clearMobileLabMissionState()
    if mobileLabSpawnBlip then RemoveBlip(mobileLabSpawnBlip) end
    if mobileLabDeliverBlip then RemoveBlip(mobileLabDeliverBlip) end
    if mobileLabDeliverMark then SH.RemoveMarkedCoords(mobileLabDeliverMark) end

    for i = #mobileLabEnemyPeds, 1, -1 do
        local ped = mobileLabEnemyPeds[i]
        if DoesEntityExist(ped) then DeletePed(ped) end
        mobileLabEnemyPeds[i] = nil
    end

    for i = #mobileLabEscortVehs, 1, -1 do
        local veh = mobileLabEscortVehs[i]
        if DoesEntityExist(veh) then Fr.DeleteVehicle(veh) end
        mobileLabEscortVehs[i] = nil
    end

    mobileLabSpawnBlip = nil
    mobileLabDeliverBlip = nil
    mobileLabDeliverMark = nil
    mobileLabVan = nil
    mobileLabVanNetId = nil
    mobileLabVanPlate = nil
    mobileLabAssaultCoordsCurrent = nil
    mobileLabDeliverCoordsCurrent = nil
    isMobileLabMission = false
end

local function startMobileLabPursuitWaves()
    Citizen.CreateThread(function()
        while isMobileLabMission and mobileLabVan and DoesEntityExist(mobileLabVan) do
            Wait(45000)
            if not isMobileLabMission then break end

            local playerPed = PlayerPedId()
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            if not MS.vehicleMatchesMission(playerVeh, mobileLabVan, mobileLabVanNetId, mobileLabVanPlate, "youga3") then
                goto continue
            end

            local playerCoords = GetEntityCoords(playerPed)
            local spawnList = {
                vec3(playerCoords.x + math.random(-80, -55), playerCoords.y + math.random(35, 70), playerCoords.z),
                vec3(playerCoords.x + math.random(55, 80), playerCoords.y + math.random(-70, -35), playerCoords.z),
            }

            for _, spawnPos in ipairs(spawnList) do
                Fr.SpawnVehicle("sultan", spawnPos, math.random(0, 359) + 0.0, true, function(veh)
                    if not DoesEntityExist(veh) then return end
                    table.insert(mobileLabEscortVehs, veh)
                    SetVehicleEngineOn(veh, true, true, false)

                    local driver = CreatePedInsideVehicle(veh, 4, joaat("s_m_y_blackops_01"), -1, true, true)
                    if DoesEntityExist(driver) then
                        MS.setGuardCombatStats(driver)
                        MS.giveGuardWeapon(driver)
                        SetDriverAbility(driver, 1.0)
                        SetDriverAggressiveness(driver, 1.0)
                        MS.taskAggressiveAgainstPlayers(driver, playerPed)
                        table.insert(mobileLabEnemyPeds, driver)
                    end

                    local shooter = CreatePedInsideVehicle(veh, 4, joaat("s_m_y_blackops_02"), 0, true, true)
                    if DoesEntityExist(shooter) then
                        MS.setGuardCombatStats(shooter)
                        MS.giveGuardWeapon(shooter)
                        MS.taskAggressiveAgainstPlayers(shooter, playerPed)
                        table.insert(mobileLabEnemyPeds, shooter)
                    end
                end)
            end
            ::continue::
        end
    end)
end

local function finishMobileLabMission()
    local playerVeh = MS.findNearbyMissionVehicle(PlayerPedId(), mobileLabVan, mobileLabVanNetId, mobileLabVanPlate, "youga3", 20.0)
    if not MS.vehicleMatchesMission(playerVeh, mobileLabVan, mobileLabVanNetId, mobileLabVanPlate, "youga3") then
        sendNotify("You must deliver the correct mobile lab vehicle.", "error", 8)
        return
    end

    Fr.DeleteVehicle(mobileLabVan)
    clearMobileLabMissionState()
    sendNotify("Mobile lab secured. Job complete.", "success", 8)
    TriggerServerEvent('op-crime:endMission', "mobile_lab_assault")
end

function startMobileLabAssaultMission()
    if isMobileLabMission then return end

    lib.alertDialog({
        header = "Mobile Lab Assault",
        content = "Locate the mobile lab, neutralize escort units and deliver it safely.",
        centered = true,
        cancel = false,
        labels = { confirm = "Understood" }
    })

    isMobileLabMission = true
    MS.createRelationshipGroup()

    mobileLabAssaultCoordsCurrent = mobileLabAssaultCoords[math.random(1, #mobileLabAssaultCoords)]
    mobileLabDeliverCoordsCurrent = mobileLabDeliverCoords[math.random(1, #mobileLabDeliverCoords)]

    mobileLabSpawnBlip = SH.addBlip(mobileLabAssaultCoordsCurrent.xyz, 67, 1, "Intercept mobile lab")
    SetBlipAsShortRange(mobileLabSpawnBlip, false)
    SetNewWaypoint(mobileLabAssaultCoordsCurrent.x, mobileLabAssaultCoordsCurrent.y)

    Citizen.CreateThread(function()
        while isMobileLabMission do
            local playerCoords = GetEntityCoords(PlayerPedId())
            if #(playerCoords - mobileLabAssaultCoordsCurrent.xyz) < 180.0 then break end
            Wait(400)
        end
        if not isMobileLabMission then return end

        Fr.SpawnVehicle("youga3", mobileLabAssaultCoordsCurrent.xyz, mobileLabAssaultCoordsCurrent.w, true, function(vehicle)
            if not isMobileLabMission then
                if DoesEntityExist(vehicle) then Fr.DeleteVehicle(vehicle) end
                return
            end

            if not DoesEntityExist(vehicle) then
                sendNotify("Failed to spawn mobile lab vehicle.", "error", 8)
                clearMobileLabMissionState()
                return
            end

            mobileLabVan = vehicle
            local missionState = MS.createMissionVehicleState(vehicle, "youga3")
            mobileLabVanNetId = missionState.netId
            mobileLabVanPlate = missionState.plate

            local guards = MS.getCirclePosAroundEntity(vehicle, 7, 7.0, 15.0)
            for _, pos in ipairs(guards) do
                local ped = MS.spawnGuardAt("s_m_y_blackops_01", pos.x, pos.y, pos.z, pos.h)
                if ped then table.insert(mobileLabEnemyPeds, ped) end
            end
            MS.taskGuards(mobileLabEnemyPeds)

            MS.waitForMissionVehicleEntry(missionState, {
                highlightCoords = mobileLabAssaultCoordsCurrent,
                isActive = function() return isMobileLabMission end,
            }, function()
                if mobileLabSpawnBlip then RemoveBlip(mobileLabSpawnBlip) end
                mobileLabSpawnBlip = nil

                mobileLabDeliverBlip = SH.addBlip(mobileLabDeliverCoordsCurrent.xyz, 280, 2, "Deliver mobile lab")
                SetBlipAsShortRange(mobileLabDeliverBlip, false)
                SetBlipRoute(mobileLabDeliverBlip, true)
                SetNewWaypoint(mobileLabDeliverCoordsCurrent.x, mobileLabDeliverCoordsCurrent.y)

                local ped = {
                    heading = mobileLabDeliverCoordsCurrent.w,
                    model = "g_m_m_armboss_01",
                    gender = "male",
                }

                mobileLabDeliverMark = SH.MarkNewCoords(mobileLabDeliverCoordsCurrent, {type = 6, size = vec3(Config.Misc.zoneSize, Config.Misc.zoneSize, Config.Misc.zoneSize), color = Config.Misc.zoneColor}, false, ped, function()
                end, function()
                    finishMobileLabMission()
                end, {
                    name = "mission_mobile_lab_deliver",
                    label = "Deliver mobile lab",
                    icon = "fa-solid fa-flask-vial"
                })

                startMobileLabPursuitWaves()
                sendNotify("Lab captured. Expect pursuit until delivery.", "info", 8)
            end)
        end)
    end)
end

RegisterNetEvent('op-crime:cancelMissionClient')
AddEventHandler('op-crime:cancelMissionClient', function(missionIndex)
    if missionIndex and missionIndex ~= 'mobile_lab_assault' and missionIndex ~= 'all' then return end
    if mobileLabVan and DoesEntityExist(mobileLabVan) then
        Fr.DeleteVehicle(mobileLabVan)
    end
    clearMobileLabMissionState()
end)

