debugPrint("^5configs/client.lua: file loaded^7")

--[[
    TriggerAlarm — raised whenever the heist should alert the police:
      - when the thief is caught
      - when the thief gets into the stolen vehicle

    @param coords vector3 — where the alarm was raised
    @param plate  string  — license plate of the stolen vehicle (may be nil)
]]
function TriggerAlarm(coords, plate)
    debugPrint("^5TriggerAlarm: function entered, coords =^7", tostring(coords),
        "^5plate =^7", tostring(plate))

    -- TODO implement your police call logic here (client side) or go to
    -- configs/server.lua to implement it server side

    -- bridge the alarm to the server so it can also be handled server-side
    TriggerServerEvent("devhub_carThief:server:triggerAlarm", coords, plate)
end

-- Lets the server raise the alarm on this client (used when the thief is caught).
RegisterNetEvent("devhub_carThief:client:triggerAlarm", function(coords, plate)
    debugPrint("^5client:triggerAlarm: event received^7")
    TriggerAlarm(coords, plate)
end)