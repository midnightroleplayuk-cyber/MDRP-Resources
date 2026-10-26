local STATE_BAG_KEY = 'cinematics:animProvider'

local function updateField(field, value)
    local current = LocalPlayer.state[STATE_BAG_KEY]
    local nextBag = {
        providerId = GetCurrentResourceName(),
        anim       = current and current.anim or nil,
        walk       = current and current.walk or nil,
    }
    nextBag[field] = value
    if nextBag.anim == nil and nextBag.walk == nil then
        LocalPlayer.state:set(STATE_BAG_KEY, nil, true)
    else
        LocalPlayer.state:set(STATE_BAG_KEY, nextBag, true)
    end
end

local function getAnimData(name)
    if not name or name == '__cinematics_probe__' then return nil end
    if not Config or not Config.Categories then return nil end

    for _, category in pairs(Config.Categories) do
        if category.get then
            local data, sort = category.get()

            if sort and data then
                local entry = data[name]
                if entry then
                    local dict = entry[1]
                    local anim = entry[2]
                    local opts = entry.animationOptions
                    return {
                        dict       = dict,
                        anim       = anim,
                        flag       = (opts and opts.customMovementType) or 0,
                        label      = entry[3] or entry.label or name,
                        library    = category.name,
                        textureVar = 0,
                    }
                end
            elseif data then
                for i = 1, #data do
                    local entry = data[i]
                    if entry and (entry.name == name or entry[1] == name) then
                        if category.type == 'shared' or category.type == 'weaponstyles' then
                            return nil
                        end
                        return {
                            dict       = entry.lib or entry.animation,
                            anim       = entry.animation,
                            flag       = entry.flag or 0,
                            label      = entry.label or entry[3] or name,
                            library    = category.type or category.name,
                            textureVar = 0,
                        }
                    end
                end
            end
        end
    end

    return nil
end

AddStateBagChangeHandler(
    'isInAnimation',
    ('player:%s'):format(GetPlayerServerId(PlayerId())),
    function(bagName, key, value, _reserved, replicated)
        if replicated then return end

        if value and value ~= false then
            local data = getAnimData(value)
            if data then
                updateField('anim', {
                    name       = value,
                    dict       = data.dict,
                    anim       = data.anim,
                    flag       = data.flag,
                    textureVar = data.textureVar or 0,
                    library    = data.library,
                })
            else
                updateField('anim', {
                    name       = value,
                    dict       = MostRecentDict,
                    anim       = MostRecentAnimation,
                    flag       = 0,
                    textureVar = 0,
                    library    = 'animation',
                })
            end
        else
            updateField('anim', nil)
        end
    end
)

CreateThread(function()
    local lastWalk = nil
    while true do
        Wait(500)
        if Main then
            local currentWalk = Main.walkingstyle
            if currentWalk ~= lastWalk then
                lastWalk = currentWalk
                if currentWalk and currentWalk ~= '' and Config and Config.Walks then
                    for i = 1, #Config.Walks do
                        local w = Config.Walks[i]
                        if w.name == currentWalk then
                            updateField('walk', { name = currentWalk, clipset = w.animation })
                            break
                        end
                    end
                else
                    updateField('walk', nil)
                end
            end
        end
    end
end)

exports('GetAnimData', getAnimData)

local function spawnPropsOnPed(ped, name)
    if not ped or not name then return end
    if not Main or not Main.getAnimation or not Main.addProp then return end

    local animation = Main:getAnimation(name)
    if not animation or not animation.animationOptions then return end

    local opts = animation.animationOptions
    if not opts.prop then return end

    local bone = opts.propBone or 60309
    local placement = opts.propPlacement
    if not placement or #placement < 6 then return end

    local p1, p2, p3, p4, p5, p6 = table.unpack(placement)
    Main:addProp(opts.prop, bone, p1, p2, p3, p4, p5, p6, ped)

    if opts.secondProp and opts.secondPropPlacement and #opts.secondPropPlacement >= 6 then
        local s1, s2, s3, s4, s5, s6 = table.unpack(opts.secondPropPlacement)
        local sbone = opts.secondPropBone or bone
        Main:addProp(opts.secondProp, sbone, s1, s2, s3, s4, s5, s6, ped)
    end
end

exports('PlayAnimOnPed', function(ped, name, opts)
    if not ped or not DoesEntityExist(ped) then return false end
    opts = opts or {}

    local data = getAnimData(name)
    if not data or not data.dict or not data.anim then return false end

    local dict = data.dict
    local anim = data.anim
    local flag = (opts.flag or data.flag or 0) | 1

    ClearPedTasksImmediately(ped)

    -- Drop any props we attached to this ped on a previous replay call so
    -- repeated PlayAnimOnPed calls don't stack duplicates. Never touch the
    -- local player's own props here.
    if ped ~= cache.ped and Main and Main.destroyProps then
        Main:destroyProps(ped)
    end

    if dict == 'scenario' or dict == 'malescenario' or dict == 'scenarioobject' then
        TaskStartScenarioInPlace(ped, anim, 0, true)
        return true
    end

    RequestAnimDict(dict)
    local tries = 0
    while not HasAnimDictLoaded(dict) and tries < 30 do
        Wait(33)
        tries = tries + 1
    end
    if not HasAnimDictLoaded(dict) then return false end

    TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, flag, 0, false, false, false)
    RemoveAnimDict(dict)

    -- Attach the emote's prop(s) so they show up in cinematic recordings/replays.
    spawnPropsOnPed(ped, name)
    return true
end)

exports('CancelAnimOnPed', function(ped)
    if not ped or not DoesEntityExist(ped) then return end
    if ped == cache.ped and Main and Main.cancelEmote then
        Main:cancelEmote(ped)
    else
        -- Delete the props PlayAnimOnPed attached to this replay ped, then clear
        -- the body task. Main:cancelEmote already handles props for cache.ped.
        if Main and Main.destroyProps then
            Main:destroyProps(ped)
        end
        ClearPedTasksImmediately(ped)
    end
end)

exports('GetMenuPed', function()
    if Main and Main.pedHandle and DoesEntityExist(Main.pedHandle) then
        return Main.pedHandle
    end
    return 0
end)

local SKIP_TYPES = { walkingstyle = true, expression = true, weaponstyles = true, sequence = true, shared = true }

exports('GetAllAnims', function()
    local out = {}
    if not Main or not Main.animations then return out end
    for _, animation in ipairs(Main.animations) do
        if not SKIP_TYPES[animation.type] and not SKIP_TYPES[animation.category] and not animation.hide then
            out[#out + 1] = {
                name    = animation.name,
                label   = animation.label or animation.name,
                library = animation.category,
            }
        end
    end
    table.sort(out, function(a, b)
        if a.library == b.library then
            return (a.label or a.name):lower() < (b.label or b.name):lower()
        end
        return tostring(a.library) < tostring(b.library)
    end)
    return out
end)

exports('GetWalkData', function(name)
    if not name or name == '__cinematics_probe__' then return nil end
    if not Config or not Config.Walks then return nil end
    for i = 1, #Config.Walks do
        local w = Config.Walks[i]
        if w.name == name then
            return { clipset = w.animation, label = w.label or name }
        end
    end
    return nil
end)

exports('SetWalkOnPed', function(ped, name)
    if not ped or not DoesEntityExist(ped) or not name then return false end
    if not Config or not Config.Walks then return false end

    local clipset
    for i = 1, #Config.Walks do
        if Config.Walks[i].name == name then
            clipset = Config.Walks[i].animation
            break
        end
    end
    if not clipset then return false end

    if ped == cache.ped and Main and Main.playAnimation then
        Main:playAnimation(ped, name)
        return true
    end

    RequestAnimSet(clipset)
    local tries = 0
    while not HasAnimSetLoaded(clipset) and tries < 30 do
        Wait(33)
        tries = tries + 1
    end
    if not HasAnimSetLoaded(clipset) then return false end
    SetPedMovementClipset(ped, clipset, 0.2)
    RemoveAnimSet(clipset)
    return true
end)

exports('ClearWalkOnPed', function(ped)
    if not ped or not DoesEntityExist(ped) then return end
    if ped == cache.ped and Main and Main.resetClipset then
        Main:resetClipset()
        return
    end
    ResetPedMovementClipset(ped, 0.0)
end)

exports('GetAllWalks', function()
    local out = {}
    if not Config or not Config.Walks then return out end
    for i = 1, #Config.Walks do
        local w = Config.Walks[i]
        if w.name and w.animation then
            out[#out + 1] = { name = w.name, label = w.label or w.name }
        end
    end
    table.sort(out, function(a, b)
        return (a.label or a.name):lower() < (b.label or b.name):lower()
    end)
    return out
end)
