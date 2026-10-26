local isProne = false
local isCrouched = false
local isCrawling = false
local inAction = false
local proneType = 'onfront'
local lastKeyPress = 0
local forceEndProne = false
local crouchedPed
local crouchLoading = false
local crouchGeneration = 0
local crouchCapsuleTicks = 0
local crouchCapsuleAt
local crouchLastRadius

local function CanPlayerCrouchCrawl(playerPed)
    if not IsPedOnFoot(playerPed) or IsPedJumping(playerPed) or IsPedFalling(playerPed) or IsPedInjured(playerPed) or IsPedInMeleeCombat(playerPed) or IsPedRagdoll(playerPed) then
        return false
    end

    return true
end

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

local function LoadClipSet(clipset)
    RequestClipSet(clipset)
    while not HasClipSetLoaded(clipset) do
        Wait(0)
    end
    Trace("Clipset loaded:", clipset)
end


local function IsPlayerAiming(player)
    return (IsPlayerFreeAiming(player) or IsAimCamActive() or IsAimCamThirdPersonActive()) and
        tonumber(GetSelectedPedWeapon(player)) ~= tonumber(GetHashKey("WEAPON_UNARMED"))
end

local function SetPlayerClipset(clipset)
    LoadClipSet(clipset)
    SetPedMovementClipset(PlayerPedId(), clipset, 0.5)
    RemoveClipSet(clipset)
end

local function IsPedAiming(ped)
    return GetPedConfigFlag(ped, 78, true) == 1 and true or false
end

local function PlayAnimOnce(ped, animDict, animName, blendInSpeed, blendOutSpeed, duration, startTime)
    LoadAnimDict(animDict)
    TaskPlayAnim(ped, animDict, animName, blendInSpeed or 2.0, blendOutSpeed or 2.0, duration or -1, 0, startTime or 0.0,
        false, false, false)
    RemoveAnimDict(animDict)
end

local function ChangeHeadingSmooth(ped, amount, time)
    local times = math.abs(amount)
    local test = amount / times
    local wait = time / times

    for _i = 1, times do
        Wait(wait)
        SetEntityHeading(ped, GetEntityHeading(ped) + test)
    end
end

local function DisableControlUntilReleased(padIndex, control)
    CreateThread(function()
        while IsDisabledControlPressed(padIndex, control) do
            DisableControlAction(padIndex, control, true)
            Wait(0)
        end
    end)
end

local function loadAnimSet(anim)
    RequestAnimSet(anim)
    local started = GetGameTimer()
    while not HasAnimSetLoaded(anim) do
        if GetGameTimer() - started >= 5000 then return false end
        Wait(10)
    end
    return true
end

local function stopCrouch(restoreWalk)
    if Main.clearCrouchClearance then Main:clearCrouchClearance() end
    local ped = crouchedPed
    crouchGeneration = crouchGeneration + 1
    isCrouched = false
    crouchedPed = nil
    if not ped or not DoesEntityExist(ped) then return end

    ResetPedMovementClipset(ped, 1.0)
    ResetPedWeaponMovementClipset(ped)
    ResetPedStrafeClipset(ped)
    SetPedStealthMovement(ped, false, 'DEFAULT_ACTION')
    SetPedCanPlayAmbientAnims(ped, true)
    if restoreWalk ~= false and ped == PlayerPedId() and ped == cache.ped then
        Main:resetClipset()
    end
end

local function canCrouch(ped)
    return Config.Modules['Crouch'] and not Main.disableModules and not Main.climbing
        and not isProne and not inAction and ped == cache.ped and ped == PlayerPedId()
        and DoesEntityExist(ped) and IsPedHuman(ped) and IsPedOnFoot(ped)
        and not IsEntityDead(ped) and not IsPedCuffed(ped)
        and not IsPedInAnyVehicle(ped, false) and not IsPedFalling(ped) and not IsPedJumping(ped)
        and not IsPedSwimming(ped) and not IsPedSwimmingUnderWater(ped)
        and not IsPedRagdoll(ped) and not IsPedClimbing(ped)
end

if Config.Modules['Crouch'] then
    Main:registerKey('bstancecrouch', "Crouch", "LCONTROL", function()
        if isCrouched then
            stopCrouch()
            return
        end

        local ped = cache.ped
        if crouchLoading or not canCrouch(ped) or IsPauseMenuActive() or IsNuiFocused()
            or LocalPlayer.state.invOpen or IsPedReloading(ped) then
            return
        end

        crouchLoading = true
        crouchGeneration = crouchGeneration + 1
        local generation = crouchGeneration
        local loaded = loadAnimSet('move_Ped_crouched') and loadAnimSet('move_Ped_crouched_strafing')
        crouchLoading = false
        if not loaded or generation ~= crouchGeneration or not canCrouch(ped)
            or IsPauseMenuActive() or IsNuiFocused() or LocalPlayer.state.invOpen then
            RemoveAnimSet('move_Ped_crouched')
            RemoveAnimSet('move_Ped_crouched_strafing')
            return
        end

        SetPedMovementClipset(ped, 'move_Ped_crouched', 1.0)
        SetPedStrafeClipset(ped, 'move_Ped_crouched_strafing')
        RemoveAnimSet('move_Ped_crouched')
        RemoveAnimSet('move_Ped_crouched_strafing')
        crouchedPed = ped
        isCrouched = true
        crouchCapsuleTicks = 0
        crouchCapsuleAt = nil
        crouchLastRadius = nil

        CreateThread(function()
            while isCrouched and generation == crouchGeneration do
                if not canCrouch(ped) then
                    stopCrouch()
                    break
                end

                if Config.Crouch and Config.Crouch.ObjectClearance then
                    Main:updateCrouchClearance(ped)
                elseif Main.clearCrouchClearance then
                    Main:clearCrouchClearance()
                end
                local radius = Config.Crouch and Config.Crouch.CapsuleRadius
                if radius == nil then radius = 0.0032 end
                if type(radius) == 'number' and radius > 0.0 then
                    SetPedCapsule(ped, radius)
                    crouchCapsuleTicks = crouchCapsuleTicks + 1
                    crouchCapsuleAt = GetGameTimer()
                    crouchLastRadius = radius
                end
                DisableFirstPersonCamThisFrame()
                SetPedCanPlayAmbientAnims(ped, false)
                InvalidateIdleCam()
                DisableControlAction(0, 21, true)
                DisableControlAction(0, 36, true)
                if IsPedUsingActionMode(ped) then
                    SetPedUsingActionMode(ped, false, -1, 'DEFAULT_ACTION')
                end
                Wait(0)
            end
        end)
    end)
end

lib.onCache('ped', function(ped)
    if crouchedPed ~= ped then stopCrouch(false) end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then stopCrouch(false) end
end)

function Main:isStanceActive()
    return isCrouched or isProne or inAction or crouchLoading
end

local function stanceSnapshot(ped)
    local position = GetEntityCoords(ped)
    local head = GetPedBoneCoords(ped, 31086, 0.0, 0.0, 0.0)
    local leftFoot = GetPedBoneCoords(ped, 14201, 0.0, 0.0, 0.0)
    local rightFoot = GetPedBoneCoords(ped, 52301, 0.0, 0.0, 0.0)
    return {
        crouched = isCrouched,
        prone = isProne,
        loading = crouchLoading,
        pedMatches = crouchedPed == ped,
        capsuleTicks = crouchCapsuleTicks,
        capsuleAgeMs = crouchCapsuleAt and GetGameTimer() - crouchCapsuleAt or -1,
        appliedRadius = crouchLastRadius,
        configuredRadius = Config.Crouch and Config.Crouch.CapsuleRadius,
        objectClearance = Main.getCrouchClearanceInfo and Main:getCrouchClearanceInfo() or nil,
        engineCrouchedCapsule = GetPedConfigFlag(ped, 99, true),
        movementClipset = GetPedMovementClipset(ped),
        stealth = GetPedStealthMovement(ped),
        desiredMoveBlend = GetPedDesiredMoveBlendRatio(ped),
        moveInputX = GetControlNormal(0, 30),
        moveInputY = GetControlNormal(0, 31),
        sprintPressed = IsDisabledControlPressed(0, 21),
        speed = GetEntitySpeed(ped),
        heading = GetEntityHeading(ped),
        collided = HasEntityCollidedWithAnything(ped),
        headAboveFeet = head.z - math.min(leftFoot.z, rightFoot.z),
        modulesDisabled = Main.disableModules,
        climbing = Main.climbing,
        onFoot = IsPedOnFoot(ped),
        falling = IsPedFalling(ped),
        vehicle = IsPedInAnyVehicle(ped, false),
        coords = {x = position.x, y = position.y, z = position.z},
    }
end

RegisterCommand('bstanceinfo', function()
    if not Config.Debug or not DoesEntityExist(cache.ped) then return end
    print('[bablo-stance] ' .. json.encode(stanceSnapshot(cache.ped)))
end, false)

local function ShouldPlayerDiveToCrawl(playerPed)
    if IsPedRunning(playerPed) or IsPedSprinting(playerPed) then
        return true
    end

    return false
end

local function stopPlayerProne(force)
    isProne = false
    forceEndProne = force
end

local function PlayIdleCrawlAnim(playerPed, heading, blendInSpeed)
    local playerCoords = GetEntityCoords(playerPed)
    TaskPlayAnimAdvanced(playerPed, 'move_crawl', proneType .. '_fwd', playerCoords.x, playerCoords.y, playerCoords.z,
        0.0, 0.0, heading or GetEntityHeading(playerPed), blendInSpeed or 2.0, 2.0, -1, 2, 1.0, false, false)
end

local function PlayExitCrawlAnims(forceEnd)
    if not forceEnd then
        inAction = true
        local playerPed = PlayerPedId()

        if proneType == 'onfront' then
            PlayAnimOnce(playerPed, 'get_up@directional@transition@prone_to_knees@crawl', 'front', nil, nil, 780)

            if not isCrouched then
                Wait(780)
                PlayAnimOnce(playerPed, 'get_up@directional@movement@from_knees@standard', 'getup_l_0', nil, nil, 1300)
            end
        else
            PlayAnimOnce(playerPed, 'get_up@directional@transition@prone_to_seated@crawl', 'back', 16.0, nil, 950)

            if not isCrouched then
                Wait(950)
                PlayAnimOnce(playerPed, 'get_up@directional@movement@from_seated@standard', 'get_up_l_0', nil, nil, 1300)
            end
        end
    end
end

local function Crawl(playerPed, type, direction)
    isCrawling = true

    TaskPlayAnim(playerPed, 'move_crawl', type .. '_' .. direction, 8.0, -8.0, -1, 2, 0.0, false, false, false)

    local time = {
        ['onfront'] = {
            ['fwd'] = 820,
            ['bwd'] = 990
        },
        ['onback'] = {
            ['fwd'] = 1200,
            ['bwd'] = 1200
        }
    }

    SetTimeout(time[type][direction], function()
        isCrawling = false
    end)
end

local function CrawlFlip(playerPed)
    inAction = true
    local heading = GetEntityHeading(playerPed)

    if proneType == 'onfront' then
        proneType = 'onback'

        PlayAnimOnce(playerPed, 'get_up@directional_sweep@combat@pistol@front', 'front_to_prone', 2.0)
        ChangeHeadingSmooth(playerPed, -18.0, 3600)
    else
        proneType = 'onfront'

        PlayAnimOnce(playerPed, 'move_crawlprone2crawlfront', 'back', 2.0, nil, -1)
        ChangeHeadingSmooth(playerPed, 12.0, 1700)
    end

    PlayIdleCrawlAnim(playerPed, heading + 180.0)
    Wait(400)
    inAction = false
end

local function CrawlLoop()
    Wait(400)

    while isProne do
        local playerPed = PlayerPedId()

        if not CanPlayerCrouchCrawl(playerPed) or IsEntityInWater(playerPed) then
            ClearPedTasks(playerPed)
            stopPlayerProne(true)
            break
        end

        local forward, backwards = IsControlPressed(0, 32), IsControlPressed(0, 33)
        if not isCrawling then
            if forward then
                Crawl(playerPed, proneType, 'fwd')
            elseif backwards then
                Crawl(playerPed, proneType, 'bwd')
            end
        end

        if IsControlPressed(0, 34) then
            if isCrawling then
                local headingDiff = forward and 1.0 or -1.0
                SetEntityHeading(playerPed, GetEntityHeading(playerPed) + headingDiff)
            else
                inAction = true
                if proneType == 'onfront' then
                    local playerCoords = GetEntityCoords(playerPed)
                    TaskPlayAnimAdvanced(playerPed, 'move_crawlprone2crawlfront', 'left', playerCoords.x, playerCoords.y,
                        playerCoords.z, 0.0, 0.0, GetEntityHeading(playerPed), 2.0, 2.0, -1, 2, 0.1, false, false)
                    ChangeHeadingSmooth(playerPed, -10.0, 300)
                    Wait(700)
                else
                    PlayAnimOnce(playerPed, 'get_up@directional_sweep@combat@pistol@left', 'left_to_prone')
                    ChangeHeadingSmooth(playerPed, 25.0, 400)
                    PlayIdleCrawlAnim(playerPed)
                    Wait(600)
                end
                inAction = false
            end
        elseif IsControlPressed(0, 35) then
            if isCrawling then
                local headingDiff = backwards and 1.0 or -1.0
                SetEntityHeading(playerPed, GetEntityHeading(playerPed) + headingDiff)
            else
                inAction = true
                if proneType == 'onfront' then
                    local playerCoords = GetEntityCoords(playerPed)
                    TaskPlayAnimAdvanced(playerPed, 'move_crawlprone2crawlfront', 'right', playerCoords.x, playerCoords
                        .y, playerCoords.z, 0.0, 0.0, GetEntityHeading(playerPed), 2.0, 2.0, -1, 2, 0.1, false, false)
                    ChangeHeadingSmooth(playerPed, 10.0, 300)
                    Wait(700)
                else
                    PlayAnimOnce(playerPed, 'get_up@directional_sweep@combat@pistol@right', 'right_to_prone')
                    ChangeHeadingSmooth(playerPed, -25.0, 400)
                    PlayIdleCrawlAnim(playerPed)
                    Wait(600)
                end
                inAction = false
            end
        end

        if not isCrawling then
            if IsControlPressed(0, 22) then
                CrawlFlip(playerPed)
            end
        end

        Wait(0)
    end

    PlayExitCrawlAnims(forceEndProne)

    isCrawling = false
    inAction = false
    forceEndProne = false
    proneType = 'onfront'
    SetPedConfigFlag(PlayerPedId(), 48, false)

    RemoveAnimDict('move_crawl')
    RemoveAnimDict('move_crawlprone2crawlfront')
end

local function CrawlKeyPressed()
    if Main and Main.disableModules then return end
    if Main.climbing or crouchLoading or IsPedClimbing(cache.ped) then return end
    if inAction then
        return
    end

    if IsPauseMenuActive() or IsNuiFocused() then
        return
    end

    if isProne then
        isProne = false
        return
    end

    local playerPed = PlayerPedId()

    if not CanPlayerCrouchCrawl(playerPed) or IsEntityInWater(playerPed) or not IsPedHuman(playerPed) then
        return
    end
    inAction = true
    local wasCrouched = isCrouched
    if wasCrouched then stopCrouch() end

    if Pointing then
        Pointing = false
    end

    isProne = true
    SetPedConfigFlag(playerPed, 48, true)

    if GetPedStealthMovement(playerPed) == 1 then
        SetPedStealthMovement(playerPed, false, 'DEFAULT_ACTION')
        Wait(100)
    end

    LoadAnimDict('move_crawl')
    LoadAnimDict('move_crawlprone2crawlfront')

    if ShouldPlayerDiveToCrawl(playerPed) then
        PlayAnimOnce(playerPed, 'explosions', 'react_blown_forwards', nil, 3.0)
        Wait(1100)
    elseif wasCrouched then
        PlayAnimOnce(playerPed, 'amb@world_human_sunbathe@male@front@enter', 'enter', nil, nil, -1, 0.3)
        Wait(1500)
    else
        PlayAnimOnce(playerPed, 'amb@world_human_sunbathe@male@front@enter', 'enter')
        Wait(3000)
    end

    if CanPlayerCrouchCrawl(playerPed) and not IsEntityInWater(playerPed) then
        PlayIdleCrawlAnim(playerPed, nil, 3.0)
    end

    inAction = false
    CreateThread(CrawlLoop)
end

if Config.Modules['Crawl'] then
    RegisterKeyMapping('+stancecrawl', "Crawl", 'keyboard', "RCONTROL")
    RegisterCommand('+stancecrawl', function() CrawlKeyPressed() end, false)
    RegisterCommand('-stancecrawl', function() end, false)
end

exports('isProne', function()
    return isProne
end)

exports('isCrouched', function()
    return isCrouched
end)
