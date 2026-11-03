function canUseSpray(gang)
    dbug('canUseSpray(gang)', gang)
    local canUse = true
    -- Here you can add a check that prevents the player from using the spray
    -- This is just an EXAMPLE. We're only going to allow the player to place the spray if they are close to another graffiti owned by the same gang
    --[[
    local graffitis = lib.callback.await('av_gangs:getGraffitis', false, gang)
    if graffitis and next(graffitis) then
        dbug("The gang have some graffitis...")
        canUse = false
        local myCoords = GetEntityCoords(cache.ped)
        for _, v in pairs(graffitis) do
            local gCoords = v['coords']
            local distance = #(myCoords - vector3(gCoords['x'], gCoords['y'], gCoords['z']))
            dbug('distance?', distance)
            if distance <= (50.0) then
                canUse = true
                break
            end
        end
    end
    dbug("canUse?", canUse)
    if not canUse then
        TriggerEvent('av_laptop:notification', Lang['app_title'], "You need to be close to another graffiti to use this.", 'error')
    end
    ]]--
    return canUse
end

function applySpray() -- Apply Spray
    dbug('applySpray()')
    lib.requestAnimDict("anim@scripted@freemode@postertag@graffiti_spray@male@")
    lib.requestModel(`prop_cs_spray_can`, 10000)
    local prop = CreateObject(`prop_cs_spray_can`, GetEntityCoords(cache.ped), true, true, true)
    AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, 28422), 0.0, 0.0, 0.0700, 0.0017365, 0.0, 0.0, true, true, false, false, 1, true)
    sendDispatch('apply')
    dbug("progress1...")
    local progress1 = progressBar("anim@scripted@freemode@postertag@graffiti_spray@male@", "shake_can_male", 15000)
    dbug("progress1 result", progress1)
    if progress1 then
        lib.requestAnimDict("anim@scripted@freemode@postertag@graffiti_spray@male@")
        Wait(300)
        ClearPedTasks(cache.ped)
        Wait(500)
        dbug("Trigger progress2..")
        local progress2 = progressBar("anim@scripted@freemode@postertag@graffiti_spray@male@", "spray_can_var_01_male", Config.PlaceSprayTime * 1000)
        dbug('progress2 result', progress2)
        ClearPedTasks(cache.ped)
        DeleteObject(prop)
        SetModelAsNoLongerNeeded(`prop_cs_spray_can`)
        return progress2
    else
        warn("applySpray: progress1 (shake_can) returned false/canceled, spray canceled and nothing will be saved")
        ClearPedTasks(cache.ped)
        DeleteObject(prop)
        SetModelAsNoLongerNeeded(`prop_cs_spray_can`)
        return false
    end
end

function removeSpray(gang, identifier) -- Remover function
    dbug("removeSpray(gang, identifier)", gang, identifier)
    if PlayerGang then
        local gangOnline = lib.callback.await('av_gangs:getOnline', false, gang, "removeSpray")
        if gangOnline >= Config.MinMembersForRemover then
            TriggerServerEvent("av_gangs:deleteRemover")
            sendDispatch('removing')
            return progressBar("amb@world_human_maid_clean@", "base", Config.RemoveSprayTime * 1000)
        else
            TriggerEvent('av_laptop:notification',Lang['app_title'],Lang['not_enough_enemies'],"error")
        end
    else
        TriggerEvent('av_laptop:notification',Lang['app_title'],Lang['not_gang_remover'],"error")
    end
end

function progressBar(dict, anim, duration, label)
    local completed = false
    local data = {
        label = label,
        duration = duration,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
        },
        anim = {
            dict = dict,
            clip = anim,
            flag = 1,
        },
    }
    if Config.ProgressType == "progressBar" then
        completed = exports['av_laptop']:progressBar(data)
    else
        completed = exports['av_laptop']:progressCircle(data)
    end
    if exports['av_laptop']:isDead() then
        dbug("Player is dead, returning false")
        return false
    end
    return completed
end

function addSprayInteraction(object, identifier, distance)
    local options = {
        {
            name = identifier,
            num = 1,
            type = "client",
            onSelect = function() -- ox_target
                dbug("Inspecting spray...")
                local progress = progressBar("misscarsteal4@aliens", "rehearsal_base_idle_director", math.random(3000,5000), Lang['inspecting'])
                if progress then
                    TriggerServerEvent('av_gangs:inspected', identifier)
                    removeSprayInteraction(object,identifier)
                end
            end,
            action = function() -- qb-target
                dbug("Inspecting spray...")
                local progress = progressBar("misscarsteal4@aliens", "rehearsal_base_idle_director", math.random(3000,5000), Lang['inspecting'])
                if progress then
                    TriggerServerEvent('av_gangs:inspected', identifier)
                    removeSprayInteraction(object, identifier)
                end
            end,
            canInteract = function()
                return PlayerGang
            end,
            icon = "fa-solid fa-spray-can",
            label = Lang['inspect_spray'],
            distance = distance or Config.RemoveDistance
        }
    }
    if Config.Target == "ox_target" then
        exports[Config.Target]:addLocalEntity(object, options)
    else
        exports[Config.Target]:AddTargetEntity(object, {
            options = options,
            distance = Config.RemoveDistance
        })
    end
end

function removeSprayInteraction(object,name)
    if Config.Target == "ox_target" then
        exports.ox_target:removeLocalEntity(object, name)
    else
        exports[Config.Target]:RemoveZone(name)
    end
end