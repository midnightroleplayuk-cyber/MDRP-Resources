RegisterNetEvent('hf1_atms:server:useATM', function(atmCoords)
    local src = source
    local playerPed = GetPlayerPed(src)
    
    if not playerPed or playerPed == 0 then return end

    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - atmCoords)

    -- Enforce server-side distance validation (3.0 units + slight buffer for latency)
    if distance <= 3.5 then
        ExecuteCommand(('atm'):format()) -- Standard Qbox/QB-Banking ATM command format
        -- Alternatively, if your banking script uses a direct event, replace ExecuteCommand with:
        -- TriggerClientEvent('qb-banking:client:openATM', src)
    else
    end
end)