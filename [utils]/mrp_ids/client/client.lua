local Config = {}
Config.Duration = 7000 -- Display duration in milliseconds (7 seconds)

local displayUntil = 0

-- Register the command and keybind together
RegisterCommand('toggleServerId', function()
    displayUntil = GetGameTimer() + Config.Duration
end, false)

RegisterKeyMapping('toggleServerId', 'Toggle Server ID Display', 'keyboard', 'F11')

-- Main loop to draw text when timer is active
Citizen.CreateThread(function()
    while true do
        local currentTime = GetGameTimer()

        if currentTime < displayUntil then
            -- Run every frame while the 7-second timer is active
            for _, player in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(player)
                if DoesEntityExist(ped) then
                    local pedCoords = GetEntityCoords(ped)
                    local serverId = GetPlayerServerId(player)

                    DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, '~p~' .. serverId)
                end
            end
            Citizen.Wait(0)
        else
            -- Idle wait when inactive to save performance
            Citizen.Wait(500)
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(1.0, 0.3)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(0, 0, 255, 255)
        SetTextOutline()

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end