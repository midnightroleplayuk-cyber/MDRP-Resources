if not Config.Modules['Ragdoll'] then return end

RegisterKeyMapping("ragdoll", "Ragdoll", "keyboard", "U")

RegisterCommand('ragdoll', function()
    if Main and Main.disableModules then return end
    if IsPedInAnyVehicle(cache.ped, false) then return end
    if LocalPlayer.state.isInAnimation then return end

    if not isRagdolling then
        isRagdolling = true
    else
        isRagdolling = false
    end

    Citizen.CreateThread(function()
        while isRagdolling do
            SetPedToRagdoll(cache.ped, 5000, 5000, 0, 0, 0, 0)

            Citizen.Wait(3000)
        end
    end)
end)
