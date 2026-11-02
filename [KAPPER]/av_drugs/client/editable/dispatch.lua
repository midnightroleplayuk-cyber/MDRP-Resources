-- Triggered everytime player sells drugs, make sure to add some randomize function or any extra check u want
-- If not check is added, it will call cops everytime someone sells a drug...
function dispatchCheck()
    dbug('dispatchCheck()')
    local alert = true -- this needs to be true at start, then when u trigger your check change it to false or not

    -- example using av_gangs, check if player is selling inside his own territory and lower chances for dispatch being triggered
    if GetResourceState('av_gangs') == "started" then
        local myZone = exports['av_gangs']:myZone()
        if myZone then
            local lucky = math.random(1,25)
            if lucky ~= 5 then alert = false end
        else
            local lucky = math.random(1,10)
            if lucky ~= 5 then alert = false end
        end
    else
        local lucky = math.random(1,10)
        if lucky ~= 5 then alert = false end
    end
    if alert then
        sendDispatch()
    end
end

function sendDispatch()
    dbug('sendDispatch...')
    -- Add your dispatch export/event here to alert cops for corner selling

end