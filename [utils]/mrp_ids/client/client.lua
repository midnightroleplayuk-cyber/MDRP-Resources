local Config = {}
Config.ToggleKey = 344 -- Key code for F11

local showServerId = false
local displayTimer = 0

RegisterKeyMapping('toggleServerId', 'Toggle Server ID Display', 'keyboard', 'F11')

-- Command handler registered via Key Mapping
RegisterCommand('toggleServerId', function()
    showServerId = true
    displayTimer = GetGameTimer() + 7000 -- Set timer to 7 seconds (7000 ms) from now
end, false)

-- Loop to handle drawing text while timer is active
Citizen.CreateThread(function()
    while true do
        local sleep = 1000

        if showServerId then
            if GetGameTimer() < displayTimer then
                sleep = 0 -- Run frame-by-frame while active to avoid flickering

                for _, player in ipairs(GetActivePlayers()) do
                    local ped = GetPlayerPed(player)
                    local pedCoords = GetEntityCoords(ped)
                    local serverId = GetPlayerServerId(player)

                    local x, y, z = table.unpack(pedCoords)
                    z = z + 1.0  -- Height above player's head

                    DrawText3D(x, y, z, '~p~' .. serverId)
                end
            else
                showServerId = false -- Reset state after 7 seconds
            end
        end

        Citizen.Wait(sleep)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(1.0, 0.5)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(0, 0, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()

        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local width = EndTextCommandGetWidth(0)
        local height = 0.02

        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x - width / 2, _y - height / 2)
    end
end