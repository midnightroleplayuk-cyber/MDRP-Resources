function canSetLab()
    local status = true
    dbug('canSetLab()')
    -- Add your own check here to allow or block the player from placing the lab entrance
    -- Set status = true or status = false based on your own check
    -- if you are gonna return false make sure to trigger a notification to the player, let him know why he can't place the lab
    
    if not status then
        TriggerEvent("av_laptop:notification", Lang['app_title'], "You can't install the lab here", "error")
    end
    return status
end

RegisterNetEvent('av_drugs:cook', function(data) -- Triggered after pressing E
    dbug('av_drugs:cook')
    if LocalPlayer.state.busy then return end
    LocalPlayer.state.busy = true
    if not data or not data['identifier'] then
        print("av_drugs:cook received null instead of identifier (?)")
        LocalPlayer.state.busy = false
        return
    end
    dbug('startCooking...')
    local startCooking = lib.callback.await('av_drugs:canLabCook', math.random(1, 1000), data['identifier'])
    dbug('startCooking?', startCooking)
    if startCooking and type(startCooking) ~= "string" then
        local canCook = true
        local ingredients = data and data['ingredients'] or false
        if ingredients then
            for k, v in pairs(ingredients) do
                dbug("hasItem?", v['name'], v['amount'])
                canCook = exports['av_laptop']:hasItem(v['name'], v['amount'])
                if not canCook then
                    break
                end
            end
        end
        if not canCook then
            TriggerEvent('av_laptop:notification', Lang['app_title'], Lang['missing_ingredients'], "error")
            LocalPlayer.state.busy = false
            return
        end
        dbug("player have all ingredients, trigger inputs")
        local formula = showInputs(startCooking)
        if formula then
            data['input'] = formula
            local animData = data and data['animation'] or false
            if animData then
                local duration = animData['duration']
                if not duration and animData['dict'] and animData['anim'] then
                    duration = GetAnimDuration(animData['dict'], animData['anim'])
                    if duration and duration ~= 0 then
                        duration *= 1000
                    else
                        duration = false
                    end
                end
                duration = duration or 60000
                dbug("duration", duration)
                local animation = progressBar(animData['dict'] or false, animData['anim'] or false, duration)
                if animation then
                    TriggerServerEvent('av_drugs:finishCooking', data)
                else
                    dbug("Player cancelled animation.")
                end
            else
                print("^3[WARNING] ^7 This cooking station doesn't have animations please check your server config for this lab type")
                print("^3[WARNING] ^7 This cooking station doesn't have animations please check your server config for this lab type")
                print("^3[WARNING] ^7 This cooking station doesn't have animations please check your server config for this lab type")
            end
        else
            dbug("Player cancelled cooking, no input received.")
        end
        LocalPlayer.state.busy = false
    else
        if startCooking then
            TriggerEvent('av_laptop:notification', Lang['app_title'], Lang[startCooking] or startCooking, "error")
        end
    end
    lib.timer(2000, function()
        LocalPlayer.state.busy = false
    end, true)
end)

RegisterNetEvent('av_drugs:interaction', function(data) -- used in any other interaction zone inside a lab
    dbug('av_drugs:interaction')
    if LocalPlayer.state.busy then return end
    LocalPlayer.state.busy = true
    local animData = data and data['animation'] or {}
    local ingredients = data and data['ingredients'] or false
    local canWork = true
    if ingredients and next(ingredients) then
        for k, v in pairs(ingredients) do
            canWork = exports['av_laptop']:hasItem(v['name'], v['amount'])
            if not canWork then break end
        end
    end
    if not canWork then
        TriggerEvent('av_laptop:notification', Lang['app_title'], Lang['missing_ingredients'], "error")
        LocalPlayer.state.busy = false
        return
    end
    local animation = progressBar(animData['dict'] or false, animData['anim'] or false, animData['duration'] or 30000)
    if animation then
        TriggerServerEvent('av_drugs:finishInteraction', data)
    else
        dbug("Player cancelled animation.")
    end
    lib.timer(2000, function()
        LocalPlayer.state.busy = false
    end, true)
end)