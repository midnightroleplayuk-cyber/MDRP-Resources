MissionShared = {}

-- Shared helpers used by mission modules.
-- Note: this file must not depend on mission-specific state.

local GUARDS_GROUP = nil

local function loadModel(model)
    if type(model) == "string" then model = joaat(model) end
    if not IsModelInCdimage(model) then return false end
    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) do
        if GetGameTimer() > timeout then return false end
        Wait(0)
    end
    return true
end

local function unloadModel(model)
    if type(model) == "string" then model = joaat(model) end
    SetModelAsNoLongerNeeded(model)
end

MissionShared.loadModel = loadModel
MissionShared.unloadModel = unloadModel

local function createRelationshipGroup()
    if not GUARDS_GROUP then
        local _, group = AddRelationshipGroup("OP_DELIVER_GUARDS")
        GUARDS_GROUP = group
        SetRelationshipBetweenGroups(1, GUARDS_GROUP, GUARDS_GROUP)
        local PLAYER_GROUP = GetHashKey("PLAYER")
        SetRelationshipBetweenGroups(5, GUARDS_GROUP, PLAYER_GROUP)
        SetRelationshipBetweenGroups(5, PLAYER_GROUP, GUARDS_GROUP)
    end
end

MissionShared.createRelationshipGroup = createRelationshipGroup

local function setGuardCombatStats(ped)
    SetPedRelationshipGroupHash(ped, GUARDS_GROUP)
    SetPedAsEnemy(ped, true)
    SetEntityInvincible(ped, false)
    SetEntityCanBeDamaged(ped, true)
    SetPedCanRagdoll(ped, true)
    SetPedDiesWhenInjured(ped, true)
    SetPedSuffersCriticalHits(ped, true)
    SetPedCanSwitchWeapon(ped, true)
    SetPedDropsWeaponsWhenDead(ped, false)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 46, true)
    SetPedCombatAttributes(ped, 5, true)
    SetPedCombatAttributes(ped, 0, true)
    SetPedCombatMovement(ped, 2)
    SetPedCombatRange(ped, 2)
    SetPedCombatAbility(ped, 2)
    SetPedAlertness(ped, 3)
    SetPedAccuracy(ped, 35)
    SetPedHearingRange(ped, 60.0)
    SetPedSeeingRange(ped, 90.0)
    SetPedArmour(ped, 25)
    SetEntityAsMissionEntity(ped, true, true)
end

MissionShared.setGuardCombatStats = setGuardCombatStats

local function giveGuardWeapon(ped)
    local pool = {
        `weapon_SNSPISTOL`,
        `WEAPON_SNSPISTOL_MK2`,
        `WEAPON_VINTAGEPISTOL`,
        `WEAPON_PISTOL`
    }
    local choice = pool[math.random(#pool)]
    GiveWeaponToPed(ped, choice, 200, false, true)
    SetCurrentPedWeapon(ped, choice, true)
end

MissionShared.giveGuardWeapon = giveGuardWeapon

local function groundZ(x, y, zHint)
    local found, z = GetGroundZFor_3dCoord(x + 0.0, y + 0.0, (zHint or 50.0), true)
    return found and z or (zHint or 50.0)
end

MissionShared.groundZ = groundZ

local function normalizePlate(plate)
    if not plate then return nil end
    return string.upper((plate:gsub("%s+", "")))
end

MissionShared.normalizePlate = normalizePlate

local function vehicleMatchesMission(playerVehicle, missionEntity, missionNetId, missionPlate, expectedModel)
    if not playerVehicle or playerVehicle == 0 then return false end

    local sameEntity = missionEntity and playerVehicle == missionEntity
    local sameNet = missionNetId and VehToNet(playerVehicle) == missionNetId
    local samePlate = missionPlate and normalizePlate(GetVehicleNumberPlateText(playerVehicle)) == missionPlate

    local validModel = true
    if expectedModel then
        local modelHash = type(expectedModel) == "string" and joaat(expectedModel) or expectedModel
        validModel = GetEntityModel(playerVehicle) == modelHash
    end

    return sameEntity or sameNet or (samePlate and validModel)
end

MissionShared.vehicleMatchesMission = vehicleMatchesMission

local function isPlayerInDeathAnimState(ped)
    if not (ped and ped ~= 0 and DoesEntityExist(ped)) then return false end
    return IsEntityPlayingAnim(ped, "dead", "dead_a", 3)
end

local function isAlivePlayerPed(ped)
    if not (ped and ped ~= 0 and DoesEntityExist(ped)) then return false end
    if IsPedDeadOrDying(ped, true) or IsPedFatallyInjured(ped) then return false end
    if GetEntityHealth(ped) <= 101 then return false end
    if isPlayerInDeathAnimState(ped) then return false end
    return true
end

local function getClosestAlivePlayerPed(fromCoords, maxDistance)
    local closestPed = nil
    local closestDistance = maxDistance or 280.0

    for _, playerId in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(playerId)
        if isAlivePlayerPed(targetPed) then
            local targetCoords = GetEntityCoords(targetPed)
            local dist = #(fromCoords - targetCoords)
            if dist <= closestDistance then
                closestDistance = dist
                closestPed = targetPed
            end
        end
    end

    return closestPed
end

local function taskAggressiveAgainstPlayers(ped, preferredTarget)
    if not (ped and ped ~= 0 and DoesEntityExist(ped)) then return false end
    if IsPedDeadOrDying(ped, true) then return false end

    local target = preferredTarget
    if not isAlivePlayerPed(target) then
        local pedCoords = GetEntityCoords(ped)
        target = getClosestAlivePlayerPed(pedCoords, 320.0)
    end
    if not isAlivePlayerPed(target) then
        ClearPedTasks(ped)
        return false
    end

    SetPedAlertness(ped, 3)
    SetPedSeeingRange(ped, 220.0)
    SetPedHearingRange(ped, 140.0)
    SetPedKeepTask(ped, true)

    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
            TaskVehicleChase(ped, target)
        else
            TaskVehicleShootAtPed(ped, target, 90.0)
        end
    else
        TaskCombatPed(ped, target, 0, 16)
    end

    return true
end

MissionShared.taskAggressiveAgainstPlayers = taskAggressiveAgainstPlayers

local function findNearbyMissionVehicle(playerPed, missionEntity, missionNetId, missionPlate, expectedModel, radius)
    local inVehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicleMatchesMission(inVehicle, missionEntity, missionNetId, missionPlate, expectedModel) then
        return inVehicle
    end

    local playerCoords = GetEntityCoords(playerPed)
    local searchRadius = radius or 20.0
    for vehicle in SH.EnumerateVehicles() do
        if DoesEntityExist(vehicle) then
            local vehCoords = GetEntityCoords(vehicle)
            if #(playerCoords - vehCoords) <= searchRadius then
                if vehicleMatchesMission(vehicle, missionEntity, missionNetId, missionPlate, expectedModel) then
                    return vehicle
                end
            end
        end
    end

    return 0
end

MissionShared.findNearbyMissionVehicle = findNearbyMissionVehicle

local function generateMissionPlate()
    math.randomseed(GetGameTimer())
    local charSet = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0"}
    local plate = ""
    for i = 1, 8 do
        plate = plate .. charSet[math.random(#charSet)]
    end
    return plate
end

function MissionShared.prepareMissionVehicle(vehicle, model)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return nil end

    SetVehicleEngineOn(vehicle, true, true, false)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehicleDoorsLocked(vehicle, 0)

    local plate = GetVehicleNumberPlateText(vehicle)
    if Fr.GetVehicleProperties then
        local props = Fr.GetVehicleProperties(vehicle)
        if props and props.plate then
            plate = props.plate
        end
    end

    if not plate or plate:gsub("%s+", "") == "" then
        plate = generateMissionPlate()
        SetVehicleNumberPlateText(vehicle, plate)
    end

    plate = normalizePlate(plate)
    if giveKeys then
        giveKeys(vehicle, model, plate)
    end

    return plate
end

function MissionShared.createMissionVehicleState(vehicle, model)
    local plate = MissionShared.prepareMissionVehicle(vehicle, model)
    return {
        entity = vehicle,
        netId = VehToNet(vehicle),
        plate = plate,
        model = model,
    }
end

function MissionShared.refreshMissionVehicleState(state, vehicle)
    if not state or not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return end
    state.entity = vehicle
    state.netId = VehToNet(vehicle)
    state.plate = normalizePlate(GetVehicleNumberPlateText(vehicle))
end

function MissionShared.isPlayerInMissionVehicle(state, model)
    if not state then return false, 0 end

    local playerPed = PlayerPedId()
    local playerVeh = GetVehiclePedIsUsing(playerPed)
    if not playerVeh or playerVeh == 0 then
        playerVeh = GetVehiclePedIsIn(playerPed, false)
    end
    if not playerVeh or playerVeh == 0 then return false, 0 end

    local expectedModel = model or state.model
    if vehicleMatchesMission(playerVeh, state.entity, state.netId, state.plate, expectedModel) then
        MissionShared.refreshMissionVehicleState(state, playerVeh)
        return true, playerVeh
    end

    return false, playerVeh
end

function MissionShared.waitForMissionVehicleEntry(state, opts, onEnter)
    opts = opts or {}
    local highlightDist = opts.highlightDistance or 15.0
    local highlightCoords = opts.highlightCoords
    local isActive = opts.isActive or function() return true end

    CreateThread(function()
        while isActive() do
            local sleep = 500
            local entered, veh = MissionShared.isPlayerInMissionVehicle(state, state.model)

            if entered then
                if state.entity and DoesEntityExist(state.entity) then
                    SetEntityDrawOutline(state.entity, false)
                end
                MissionShared.prepareMissionVehicle(veh or state.entity, state.model)
                if onEnter then onEnter(veh or state.entity, state) end
                break
            end

            if state.entity and DoesEntityExist(state.entity) and highlightCoords then
                local playerCoords = GetEntityCoords(PlayerPedId())
                local ref = highlightCoords
                if ref.x and ref.y and ref.z then
                    ref = vec3(ref.x, ref.y, ref.z)
                end
                if #(playerCoords - ref) < highlightDist then
                    sleep = 0
                    SetEntityDrawOutlineColor(255, 255, 255, 255)
                    SetEntityDrawOutline(state.entity, true)
                else
                    SetEntityDrawOutline(state.entity, false)
                end
            end

            Wait(sleep)
        end
    end)
end

local function spawnGuardAt(model, x, y, z, heading)
    if not loadModel(model) then return nil end
    z = groundZ(x, y, z)
    local ped = CreatePed(4, joaat(model), x, y, z, heading or 0.0, true, true)
    if not DoesEntityExist(ped) then return nil end
    setGuardCombatStats(ped)
    giveGuardWeapon(ped)
    SetPedKeepTask(ped, true)
    return ped
end

MissionShared.spawnGuardAt = spawnGuardAt

local function getCirclePosAroundEntity(ent, count, minR, maxR)
    local positions = {}
    local base = GetEntityCoords(ent)
    local heading = GetEntityHeading(ent)
    for i = 1, count do
        local angle = math.rad((i / count) * 360.0 + math.random(-10,10))
        local r = minR + (maxR - minR) * math.random()
        local x = base.x + math.cos(angle) * r
        local y = base.y + math.sin(angle) * r
        local z = base.z + 0.5
        positions[#positions+1] = {x=x, y=y, z=z, h=heading + math.deg(angle)}
    end
    return positions
end

MissionShared.getCirclePosAroundEntity = getCirclePosAroundEntity

local function taskGuards(peds)
    for _, ped in ipairs(peds) do
        if DoesEntityExist(ped) then
            taskAggressiveAgainstPlayers(ped)
        end
    end

    Citizen.CreateThread(function()
        local noAliveTicks = 0
        while noAliveTicks < 10 do
            local aliveCount = 0
            for _, ped in ipairs(peds) do
                if DoesEntityExist(ped) and not IsPedDeadOrDying(ped, true) then
                    aliveCount = aliveCount + 1
                    taskAggressiveAgainstPlayers(ped)
                end
            end

            if aliveCount == 0 then
                noAliveTicks = noAliveTicks + 1
            else
                noAliveTicks = 0
            end

            Wait(1200)
        end
    end)
end

MissionShared.taskGuards = taskGuards