debugPrint("^5configs/server.lua: file loaded^7")

--[[
    Server-side handler for the heist alarm. Fires whenever TriggerAlarm is raised
    on a client - when the thief is caught, and when they get into the stolen
    vehicle. Implement your dispatch integration here (ps-dispatch, cd_dispatch,
    a native ESX/QB police alert, ...).

    source = the player who raised the alarm
    @param coords vector3 — where the alarm was raised
    @param plate  string  — license plate of the stolen vehicle (may be nil)
]]
RegisterNetEvent("devhub_carThief:server:triggerAlarm", function(coords, plate)
    local source = source
    debugPrint("^5triggerAlarm (server): source =^7", tostring(source),
        "^5coords =^7", tostring(coords), "^5plate =^7", tostring(plate))

    -- TODO implement your server-side police call logic here
end)
