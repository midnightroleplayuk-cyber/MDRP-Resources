-- U can add your own check for table placement, return true/false
function canPlace()
    dbug('canPlace()')
    
    return true
end

RegisterNUICallback('setGPS', function(data,cb)
    if data and (data['x'] and data['y']) then
        SetNewWaypoint(data['x'], data['y'])
        TriggerEvent('av_laptop:notificationUI', Lang['app_title'], Lang['waypoint_set'], 'success')
    end
    cb('ok')
end)

RegisterNetEvent('av_drugs:startCooking', function(data)
    dbug('av_drugs:startCooking')
    if data and (data['identifier'] and data['itemName']) then
        if LocalPlayer.state.busy then return end
        LocalPlayer.state.busy = true
        dbug("canCook check...")
        local canCook = lib.callback.await('av_drugs:canCook', math.random(50,500), data['identifier'], data['itemName'])
        if not canCook then
            dbug("canCook returned false, this table can't be used atm")
            lib.timer(500, function()
                LocalPlayer.state.busy = false
            end, true)
            return
        end
        dbug('av_drugs:getInput', data['itemName'])
        local input = lib.callback.await('av_drugs:getInput', false, data['itemName'])
        if input then
            local res = showInputs(input)
            if res then
                dbug('input received, start animation')
                local animation = progressBar(Config.Animation['dict'], Config.Animation['animation'], Config.Animation['duration'])
                if animation then
                    dbug("trigger startTable server side...")
                    TriggerServerEvent('av_drugs:startTable', data['identifier'], data['itemName'], data['owner'], res)
                else
                    dbug("Player stopped animation, cooking cancelled.")
                end
            else
                dbug("Player cancelled cooking, no input received.")
            end
        else
            print("^3[WARNING]^7 Table type ^1"..data['itemName'].."^7 doesn't have any input values check your server config, this is NOT a script problem.")
            print("^3[WARNING]^7 Table type ^1"..data['itemName'].."^7 doesn't have any input values check your server config, this is NOT a script problem.")
            print("^3[WARNING]^7 Table type ^1"..data['itemName'].."^7 doesn't have any input values check your server config, this is NOT a script problem.")
        end
        CreateThread(function()
            Wait(2000)
            LocalPlayer.state.busy = false
        end)
    end
end)