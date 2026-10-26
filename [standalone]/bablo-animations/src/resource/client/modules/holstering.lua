if not Config.Modules['Holstering'] then return end

local introDict, introAnim, outroDict, outroAnim
local firstWait, secondWait
local isPlayerLoaded = false
local hasStartedLoop = false
local isHolstering = false

function loadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(10)
        end
    end
end

function holsterWeapon()
    if Main and Main.disableModules then return end
    if isHolstering or not isPlayerLoaded then return end
    isHolstering = true

    local ped = cache.ped
    if not ped then
        isHolstering = false
        return
    end

    if Framework:isCurrentJob("police") then
        introDict = "weapons@pistol@"
        introAnim = "aim_2_holster"
        firstWait = 0
    else
        introDict = "reaction@intimidation@1h"
        introAnim = "intro"
        firstWait = 1500
    end

    loadAnimDict(introDict)
    TaskPlayAnim(ped, introDict, introAnim, 8.0, -8.0, firstWait, 48, 0, false, false, false)
    Citizen.Wait(firstWait)
    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
    ClearPedTasks(ped)
    isHolstering = false
end

function unholsterWeapon()
    if Main and Main.disableModules then return end
    if isHolstering or not isPlayerLoaded then return end
    isHolstering = true

    local ped = cache.ped
    if not ped then
        isHolstering = false
        return
    end

    if Framework:isCurrentJob("police") then
        outroDict = "rcmjosh4"
        outroAnim = "josh_leadout_cop2"
        secondWait = 350
    else
        outroDict  = "combat@combat_reactions@pistol_1h_gang"
        outroAnim  = "0"
        secondWait = 1200
    end

    loadAnimDict(outroDict)
    TaskPlayAnim(ped, outroDict, outroAnim, 8.0, -8.0, secondWait, 48, 0, false, false, false)
    Citizen.Wait(secondWait)
    ClearPedTasks(ped)
    isHolstering = false
end

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) or not cache.ped do
        Citizen.Wait(1000)
    end
    isPlayerLoaded = true
    Citizen.Wait(5000)

    local holstered = true
    local ped = cache.ped

    while true do
        ped = cache.ped
        if not ped then
            Citizen.Wait(500)
            goto continue
        end

        if Main and Main.disableModules then
            Citizen.Wait(500)
            goto continue
        end

        local weapon = GetSelectedPedWeapon(ped)

        if not hasStartedLoop and weapon ~= GetHashKey("WEAPON_UNARMED") then
            holstered = false
            hasStartedLoop = true
        end

        if weapon == GetHashKey("WEAPON_UNARMED") then
            if not holstered then
                holstered = true
                holsterWeapon()
            end
        else
            if holstered then
                holstered = false
                unholsterWeapon()
            end
        end
        Citizen.Wait(500)

        ::continue::
    end
end)
