if Config.Prison ~= "rcore_prison" then return end

function isPlayerPrisoner()
    return lib.callback.await('op-multicharacter:isPrisoner', false) == true
end

local function softHoldPed()
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return end

    if type(freezePlayer) == "function" then
        freezePlayer(true)
    end
    FreezeEntityPosition(ped, true)
    SetEntityCollision(ped, false, false)
    SetEntityVisible(ped, false, false)
    SetEntityInvincible(ped, true)
end

local function releasePedSafely()
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return end

    local c = GetEntityCoords(ped)
    RequestCollisionAtCoord(c.x, c.y, c.z)

    local interior = GetInteriorFromEntity(ped)
    if interior == 0 then
        local found, groundZ = GetGroundZFor_3dCoord(c.x + 0.0, c.y + 0.0, c.z + 80.0, false)
        if found and groundZ and groundZ > -50.0 and math.abs(c.z - groundZ) > 2.0 then
            SetEntityCoordsNoOffset(ped, c.x, c.y, groundZ + 0.05, false, false, false)
            c = GetEntityCoords(ped)
        end
    end

    local colDeadline = GetGameTimer() + 5000
    while not HasCollisionLoadedAroundEntity(ped) and GetGameTimer() < colDeadline do
        c = GetEntityCoords(ped)
        RequestCollisionAtCoord(c.x, c.y, c.z)
        Wait(0)
        ped = PlayerPedId()
    end

    SetEntityCollision(ped, true, true)
    SetEntityVisible(ped, true, false)
    SetEntityInvincible(ped, false)
    FreezeEntityPosition(ped, false)
    if type(freezePlayer) == "function" then
        freezePlayer(false)
    end
    SetPlayerControl(PlayerId(), true, 0)
end

function finishPrisonerMultichar()
    setBlackScreenEnabled(true)
    if type(Config.SwitchHud) == "function" then
        Config.SwitchHud(false)
    end
    if type(ClearLocalEnv) == "function" then
        ClearLocalEnv()
    end

    softHoldPed()

    SH.deletePeds()
    SH.deleteProps()
    SH.deleteVehicles()

    local cam = GetActiveScriptCam and GetActiveScriptCam() or nil
    if cam then
        DestroyCamSafe(cam)
    end
    RenderScriptCams(false, false, 0, true, true)

    Wait(200)

    isInsideMultichar = false
    shouldOpenOnTheEnd = false
    if type(OPMC) == "table" and type(OPMC.endCharMenuSession) == "function" then
        OPMC.endCharMenuSession()
    end
    TriggerServerEvent('op-multicharacter:allDone', false)

    local startCoords = GetEntityCoords(PlayerPedId())

    Fr.OnPlayerLoadEvents()

    local moved = false
    local deadline = GetGameTimer() + 10000
    while GetGameTimer() < deadline do
        softHoldPed()
        local ped = PlayerPedId()
        if DoesEntityExist(ped) then
            local c = GetEntityCoords(ped)
            if #(c - startCoords) > 8.0 then
                moved = true
                break
            end
        end
        Wait(100)
    end

    if not moved then
        debugPrint("^3[op-multicharacter]^0 Prisoner handoff: no teleport detected within timeout — settling at current coords")
    else
        debugPrint("^2[op-multicharacter]^0 Prisoner handoff: prison teleport detected")
        Wait(400)
        softHoldPed()
    end

    releasePedSafely()

    if type(Fr.CharacterSpawned) == "function" then
        Fr.CharacterSpawned()
    end

    Wait(250)
    setBlackScreenEnabled(false)
end