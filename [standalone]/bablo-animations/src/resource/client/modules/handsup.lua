if not Config.Modules['Handsup'] then return end

local ShouldHold = true -- false = toggle mode; true = hold-to-raise

local Triggered = false

local isUsingOxInventory = false

local IsResourceStartedOrStarting = function(resource)
    local state = GetResourceState(resource)
    return state == "started" or state == "starting"
end

Citizen.CreateThread(function()
    if IsResourceStartedOrStarting('ox_inventory') then
        isUsingOxInventory = true
    end
end)

local function LoadAnimation(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function HandsUpStop()
    local player = cache.ped
    if IsPedInAnyVehicle(player, false) then
        StopAnimTask(player, 'random@mugging3', 'handsup_standing_base', -2.0)
    else
        ClearPedTasks(player)
    end

    if Main.expression then
        Main:playAnimation(player, Main.expression or nil, false, true)
    else
        SetFacialIdleAnimOverride(player, 'pose_normal_1', 0)
    end
end

local function HandsUpStart()
    local player = cache.ped
    LoadAnimation('random@mugging3')
    SetFacialIdleAnimOverride(player, 'mood_stressed_1', 0)

    if isUsingOxInventory and IsPedArmed(player, 7) then
        print('Disarming player for hands up animation')
        TriggerEvent('ox_inventory:disarm', true)
    end

    if not IsPedInAnyVehicle(player, false) then
        SetCurrentPedWeapon(player, `WEAPON_UNARMED`, true)

        TaskPlayAnim(
            player,
            'random@mugging3',
            'handsup_standing_base',
            8.0, -8.0,
            -1,
            49,
            0.0,
            false, false, false
        )
    end
end

local function ToggleHandsUp()
    if Main and Main.disableModules then return end
    if Main.isBusy then return end
    if not Triggered and IsPedReloading(cache.ped) then
        print("Player is reloading")
        return
    end

    Triggered = not Triggered

    if not Triggered then
        HandsUpStop()
        return
    end

    HandsUpStart()
end

CreateThread(function()
    local cmd = 'handsup_banim'

    RegisterCommand('+' .. cmd, function()
        if Main and Main.disableModules then return end
        if ShouldHold then
            if Main.isBusy then return end
            if IsPedReloading(cache.ped) then
                print("Player is reloading")
                return
            end
            if not Triggered then
                Triggered = true
                HandsUpStart()
            end
        else
            ToggleHandsUp()
        end
    end, false)

    RegisterCommand('-' .. cmd, function()
        if Main and Main.disableModules then return end
        if ShouldHold then
            if Main.isBusy then return end
            if Triggered then
                Triggered = false
                HandsUpStop()
            end
        end
    end, false)

    RegisterKeyMapping('+' .. cmd, 'Put your hands up', 'keyboard', 'X')
end)
