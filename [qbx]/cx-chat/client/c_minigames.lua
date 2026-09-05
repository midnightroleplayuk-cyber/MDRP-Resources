local function PlayAnimation(dict, anim, duration)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end

    local ped = PlayerPedId()
    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, duration or 2000, 0, 0, false, false, false)

    Wait(duration or 2000)
    ClearPedTasks(ped)
end

RegisterNetEvent("cx-chat:playDiceAnimation")
AddEventHandler("cx-chat:playDiceAnimation", function()
    PlayAnimation("anim@mp_player_intcelebrationmale@wank", "wank", 2000)
end)
