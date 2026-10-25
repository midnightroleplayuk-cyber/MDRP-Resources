Citizen.CreateThread(function()
    if not Config.Modules['DisableLeaning'] then return end

    Citizen.Wait(2000)

    SetPlayerCanUseCover(PlayerId(), false)
end)