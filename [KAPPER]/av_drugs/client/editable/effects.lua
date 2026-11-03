local drugEffect = false

RegisterNetEvent('av_drugs:useDrug', function(options,metadata)
    dbug("av_drugs:useDrug", options and json.encode(options, {indent = true}), metadata and json.encode(metadata, {indent = true}))
    if drugEffect then
        dbug("Player is busy...")
        return 
    end
    if not options or not metadata then
        print("Drug is missing options or metadata, check previous print....")
        return
    end
    drugEffect = true
    LocalPlayer.state:set("inDrugs", true, true)
    local purity = metadata and metadata['purity'] or 1
    purity = removeSymbol(purity)
    local effect = options and options['effect'] or false
    local benefits = options and options['benefits'] or false
    local animData = options and options['animation'] or false
    local effectDuration = getDuration(effect['duration'], purity)
    dbug('effectDuration', effectDuration)
    if animData then
        local duration = animData['duration']
        if not duration and animData['dict'] and animData['anim'] then
            duration = GetAnimDuration(animData['dict'], animData['anim'])
            if duration then
                duration *= 1000
            end
        end
        duration = duration or 5000
        dbug("duration", duration)
        local pos = GetEntityCoords(cache.ped)
        drugEffect = progressBar(animData['dict'], animData['anim'], duration, animData['prop'], animData['flag'], animData['blendIn'], animData['blendOut'], animData['disableWalk'])
        if not drugEffect then
            dbug("player cancelled drug use")
            LocalPlayer.state:set("inDrugs", false, true)
            return
        end
        dbug('setClipset')
        if effect then
            lib.requestAnimSet(effect['clipSet'] or "MOVE_M@DRUNK@VERYDRUNK")
            SetPedMovementClipset(cache.ped, effect['clipSet'] or "MOVE_M@DRUNK@VERYDRUNK", true)
            SetPedIsDrunk(cache.ped, true)
        end
        if effect and effect['timeCycle'] then
            if GetResourceState("av_weather") == "started" then
                exports['av_weather']:useTimecycles(false)
            end
            SetTimecycleModifier(effect['timeCycle'])
            SetTimecycleModifierStrength(1.0)
        end
        if benefits and benefits['health'] then
            local toAdd = purity or 1
            dbug("Added "..toAdd.." health to player")
            SetEntityHealth(cache.ped, GetEntityHealth(cache.ped) + toAdd)
        end
        if benefits and benefits['health'] then
            local toAdd = purity or 1
            dbug("Added "..toAdd.." armour to player")
            SetPedArmour(cache.ped, GetPedArmour(cache.ped) + toAdd)
        end
        if effect and effect['cameraShake'] then
            ShakeGameplayCam("DRUNK_SHAKE", effect['cameraShake'])
        end
        if effect and effect['motionBlur'] then
            SetPedMotionBlur(cache.ped, false)
        end
        dbug("start drugEffect loop...")
        lib.timer(effectDuration, function()
            drugEffect = false
            dbug("drugEffect ended")
            if effect and effect['cameraShake'] then
                ShakeGameplayCam("DRUNK_SHAKE", 0.0) 
            end
            ResetPedMovementClipset(cache.ped, 1.0)
            ClearTimecycleModifier()
            ClearFocus()
            if GetResourceState("av_weather") == "started" then
                exports['av_weather']:useTimecycles(true)
            end
            LocalPlayer.state:set("inDrugs", false, true)
        end, true)
        if effect['movementSpeed'] and effect['movementSpeed'] > 1.0 then
            while drugEffect do
                if effect and effect['movementSpeed'] then
                    SetPedMoveRateOverride(cache.ped, effect['movementSpeed'] or 1.0)
                end
                if benefits and benefits['stamina'] then
                    local lucky = math.random(1,10)
                    if lucky == 1 then
                        ResetPlayerStamina(cache.ped)
                    end
                end
                Wait(15)
            end
        end
    end
end)

function calcValueToAdd(value, purity)
    dbug('calcValueToAdd(value,purity)', value, purity)
    if not value then return false end
    local purity = purity or 1
    local totalValue = math.floor((value * purity) / 10)
    dbug("totalValue", totalValue)
    if totalValue < 10 then
        totalValue = 10 -- minimum to add is 10, makes 0 sense to only add 1 point
    end
    return math.floor(totalValue)
end

function getDuration(time,purity)
    dbug('getDuration(time,purity)', time, purity)
    if not time then
        return 60000
    end
    purity = purity or 1
    time += math.floor(purity / 10)
    return (time*1000)
end