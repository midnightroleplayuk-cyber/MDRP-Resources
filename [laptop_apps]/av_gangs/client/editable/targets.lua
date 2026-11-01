local models = {}

function refreshTargets()
    if gangSettings and next(gangSettings) then
        for k, v in pairs(gangSettings) do
            if v['peds'] and next(v['peds']) then
                for a, b in pairs(v['peds']) do
                    if not models[b] then
                        models[b] = true
                        local model = GetHashKey(b)
                        local options = {
                            {
                                label = Lang['npc_stash'],
                                icon = 'fa-solid fa-box',
                                event = "av_gangs:targetStash",
                                gangName = k,
                                model = model,
                                distance = 2.0,
                                canInteract = function(entity)
                                    local currentZone = getZoneGang()
                                    if not PlayerGang or not currentZone then return false end
                                    if currentZone and not IsEntityDead(entity) and (currentZone == PlayerGang['name']) then
                                        return true
                                    end
                                    return false
                                end,
                            },
                            {
                                label = Lang['rob'],
                                icon = 'fas fa-user-ninja',
                                event = "av_gangs:rob",
                                gangName = k,
                                model = model,
                                distance = 2.0,
                                canInteract = function(entity)
                                    local currentZone = getZoneGang()
                                    if not PlayerGang or not currentZone then return false end
                                    if currentZone and not IsEntityDead(entity) and currentZone ~= PlayerGang['name'] then
                                        return true
                                    end
                                    return false
                                end, 
                            },
                        }
                        if Config.Target == "ox_target" then
                            exports.ox_target:addModel(model, options)
                        else
                            exports[Config.Target]:AddTargetModel(model, {
                                options = options,
                                distance = 2.0
                            })
                        end
                    end
                end
            end
        end
    end
end

AddEventHandler('av_gangs:rob', function(data)
    local currentZone = getZoneGang()
    dbug('rob npc (currentZone, PlayerGang?)', currentZone, PlayerGang and PlayerGang['name'] or "no")
    if not PlayerGang or not currentZone then
        return
    end
    if currentZone == PlayerGang['name'] then
        dbug("You can't rob your own ppl wtf")
        return
    end
	local npc = data['entity']
    local ped = PlayerPedId()
    local netId = NetworkGetNetworkIdFromEntity(npc)
	while not NetworkHasControlOfEntity(npc) do
		NetworkRequestControlOfEntity(npc)
		Wait(10)
	end
    lib.requestAnimDict('combat@aim_variations@1h@gang')
    lib.requestAnimDict('missminuteman_1ig_2')
	TaskPlayAnim(ped, 'combat@aim_variations@1h@gang', 'aim_variation_a', 8.0, -8,-1, 2, 0, 0, 0, 0)
	TaskTurnPedToFaceEntity(npc,ped,-1)
    sendDispatch("robbing")
	TaskPlayAnim(npc, "missminuteman_1ig_2", "handsup_base", 8.0, 8.0, -1, 50, 0, false, false, false)
    local res = progressBar(false, false, math.random(7000, 10000))
    if res then
        if not exports['av_laptop']:isDead() then
            local state = Entity(npc).state
            if state and state['robbed'] then
                TriggerEvent('av_laptop:notification',Lang['app_title'],Lang['already_robbed'],'error') 
            else
                local coords = GetEntityCoords(npc)
                local zone = coords and GetNameZone(coords) or nil
                TriggerServerEvent('av_gangs:getMoney',netId,currentZone,zone,data)
            end
        end
		CreateThread(function()
            Wait(5000)
            ClearPedTasks(ped)
            ClearPedTasks(npc)
        end)
    else
        ClearPedTasks(ped)
		ClearPedTasks(npc)
        SetEntityAsNoLongerNeeded(npc)
    end
end)

RegisterNetEvent('av_gangs:alertMember', function(coords,msg) -- alert sent to members when someone is robbing their npc
    TriggerEvent('av_laptop:notification', Lang['app_title'], msg)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 2.0)
    SetBlipColour(blip, 3)
    PulseBlip(blip)
    Wait(60000)
    RemoveBlip(blip)
end)