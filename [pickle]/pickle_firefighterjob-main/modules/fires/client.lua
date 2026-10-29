Fires = {}
local FireInstances = {}
FireBlips = {}
local Effects = {}
local FireTargetEnabled = false
local CurrentFireTarget = nil
local WaterCapacity

function GetDirectionFromRotation(rotation)
    local dm = (math.pi / 180)
    return vector3(-math.sin(dm * rotation.z) * math.abs(math.cos(dm * rotation.x)), math.cos(dm * rotation.z) * math.abs(math.cos(dm * rotation.x)), math.sin(dm * rotation.x))
end

function GetDirectionCoords()
    local range = 1000.0
	local coords = GetGameplayCamCoord()
    local rot = GetGameplayCamRot(2)
    local dir = GetDirectionFromRotation(rot)
	local ecoords = vector3(coords.x + dir.x * range, coords.y + dir.y * range, coords.z + dir.z * range)
    local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(StartShapeTestRay(coords.x, coords.y, coords.z, ecoords.x, ecoords.y, ecoords.z, -1, -1, 1))
	return hit, endCoords, entityHit 
end

function IsFireTargetActive()
    return IsFireTargetActive
end

function DisableFireTarget()
    FireTargetEnabled = false
end

function EnableFireTarget(damagePerTick, attackFunction)
    if FireTargetEnabled then return end
    FireTargetEnabled = true
    CreateThread(function()
        local spriteDict, sprite = "darts", "dart_reticules"
        local damage = 0
        while FireTargetEnabled do 
            local hit, coords, entity = GetDirectionCoords()
            RequestStreamedTextureDict(spriteDict, false)
            if hit and coords then 
                local found = false
                for k,v in pairs(FireInstances) do
                    if v.prop == entity then
                        found = true
                        DrawSprite(spriteDict, sprite, 0.5, 0.5, 0.015, 0.025, 180.0, 255, 0, 0, 255)
                        local ped = PlayerPedId()
                        local dist = #(GetEntityCoords(ped) - GetEntityCoords(v.prop))
                        local attacking = attackFunction(k, dist)
                        if attacking and damage < Config.Fires.damageUpdate then
                            damage = damage + damagePerTick
                        elseif damage > 0 then
                            TriggerServerEvent("pickle_firefighterjob:attackFire", k, damage)
                            damage = 0
                        end
                        break
                    end
                end
                if not found then 
                    DrawSprite(spriteDict, sprite, 0.5, 0.5, 0.015, 0.025, 180.0, 255, 255, 255, 255)
                end
            else
                DrawSprite(spriteDict, sprite, 0.5, 0.5, 0.015, 0.025, 180.0, 255, 255, 255, 255)
            end
            Wait(0)
        end
    end)
end

function EnsureFire(index)
    if FireInstances[index] then return FireInstances[index] end
    local data = Fires[index]
    local off = data.offset or vector3(0.0, 0.0, 0.0)
    local rot = data.rotation or vector3(0.0, 0.0, 0.0)
    local prop = CreateProp(`v_serv_abox_g3`, data.coords.x, data.coords.y, data.coords.z, false, true, false)
    SetEntityAlpha(prop, 0, false)
    FreezeEntityPosition(prop, true)
    local particles = {}
    if data.flame then 
        for i=1, data.flame.stack do 
            local newOff = vector3(off.x, off.y, off.z + (data.flame.height * (i - 1)))
            particles[#particles + 1] = { type = "flame", offset = newOff, rotation = rot, handle = PlayEffect(data.flame.dict, data.flame.particle, prop, newOff, rot, data.flame.scale)}
            local percent = data.health / data.maxHealth
            local scale = data.flame.scale * percent
            local height = (particles[#particles].offset.z - off.z) * percent
            SetParticleFxLoopedScale(particles[#particles].handle, scale)
            SetParticleFxLoopedOffsets(particles[#particles].handle, off.x, off.y, off.z + height, rot.x, rot.y, rot.z)
        end
    end
    if data.smoke then 
        for i=1, data.smoke.stack do 
            local newOff = vector3(off.x, off.y, off.z + (data.smoke.height * (i - 1)))
            particles[#particles + 1] = { type = "smoke", offset = newOff, rotation = rot, handle = PlayEffect(data.smoke.dict, data.smoke.particle, prop, newOff, rot, data.smoke.scale)}
            local percent = data.health / data.maxHealth
            local scale = data.smoke.scale * percent
            local height = (particles[#particles].offset.z - off.z) * percent
            SetParticleFxLoopedScale(particles[#particles].handle, scale)
            SetParticleFxLoopedOffsets(particles[#particles].handle, off.x, off.y, off.z + height, rot.x, rot.y, rot.z)
        end
    end
    FireInstances[index] = {
        prop = prop,
        particles = particles
    }
    return FireInstances[index]
end

function RemoveFire(index)
    if not FireInstances[index] then return end
    DeleteEntity(FireInstances[index].prop)
    for i=1, #FireInstances[index].particles do
        RemoveParticleFx(FireInstances[index].particles[i].handle, true)
    end
    FireInstances[index] = nil
end

function WaterTank()
    if FireTargetEnabled then 
        DisableFireTarget()
        return
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    local prop = CreateProp(`v_ind_cs_gascanister`, coords.x, coords.y, coords.z, true, true, false)
    local boneIndex = GetPedBoneIndex(ped, 24818)
    local off = vector3(0.0, -0.25, 0.0)
    local rot = vector3(0.0, 90.0, 0.0)
    AttachEntityToEntity(prop, ped, boneIndex, off.x, off.y, off.z, rot.x, rot.y, rot.z, false, false, false, false, 2, true)
    
    local nozzle = CreateProp(`prop_hose_nozzle`, coords.x, coords.y, coords.z, true, true, false)
    local boneIndex = GetPedBoneIndex(ped, 57005)
    local off = vector3(0.2, 0.0, 0.0)
    local rot = vector3(18.0, 180.0, -25.0)
    AttachEntityToEntity(nozzle, ped, boneIndex, off.x, off.y, off.z, rot.x, rot.y, rot.z, false, false, false, false, 2, true)

    GiveWeaponToPed(ped, `WEAPON_FIREEXTINGUISHER`, 0, true, true)
    
    local WaterEffect
    DisableFireTarget()
    EnableFireTarget(Config.Fires.water.damage, function(index, dist)
        return dist < Config.Fires.water.range and IsDisabledControlPressed(1, 24)
    end) 
    WaterCapacity = Config.Fires.water.capacity
    while FireTargetEnabled and WaterCapacity > 0 do 
        local ped = PlayerPedId()
        SetCurrentPedWeapon(ped, `WEAPON_FIREEXTINGUISHER`, true)
        SetPedCurrentWeaponVisible(ped, false, false, true)
        DisablePlayerFiring(PlayerId(), true)

        DrawRect(0.5, 0.52, 0.02, 0.005, 255, 255, 255, 255)
        local factor = (WaterCapacity / Config.Fires.water.capacity)
        local width = 0.02 * factor
        local progressX = (0.5 + (width / 2)) - (0.02 /2)
        DrawRect(progressX, 0.52, width, 0.005, 0, 150, 255, 255)
        if IsControlJustPressed(1, 202) then
            break
        end
        if IsDisabledControlPressed(1, 24) then
            WaterCapacity = WaterCapacity - Config.Fires.water.waterPerTick
            if not WaterEffect then 
                WaterEffect = PlayEffect("core", "water_cannon_jet", nozzle, nil, nil, 1.0, true)
            end
        elseif WaterEffect then
            StopParticleFxLooped(WaterEffect, true)
            TriggerServerEvent("pickle_firefighterjob:stopEffect", ObjToNet(nozzle))
            WaterEffect = nil
        end 
        if DoesEntityExist(GetVehiclePedIsIn(ped)) then 
            break 
        end
        Wait(0)
    end 
    WaterCapacity = nil
    local ped = PlayerPedId()
    DisablePlayerFiring(PlayerId(), false)
    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    TriggerServerEvent("pickle_firefighterjob:stopEffect", ObjToNet(nozzle))
    SetTimeout(500, function()
        DeleteEntity(nozzle)
        DeleteEntity(prop)
    end)
    DisableFireTarget()
end

function ExtinguisherCheck() 
    local ped = PlayerPedId()
    local found, hash = GetCurrentPedWeapon(ped, 1)
    if found and hash == Config.Fires.extinguisher.hash then 
        EnableFireTarget(Config.Fires.extinguisher.damage, function(index, dist)
            local ped = PlayerPedId()
            if IsPedShooting(ped) and dist < Config.Fires.extinguisher.range then return true end 
        end)
        CreateThread(function() 
            while FireTargetEnabled do 
                local ped = PlayerPedId()
                local found, hash = GetCurrentPedWeapon(ped, 1)
                if (not found or hash ~= Config.Fires.extinguisher.hash) or DoesEntityExist(GetVehiclePedIsIn(ped)) then
                    DisableFireTarget()
                    break
                end
                Wait(0)
            end
        end)
        return true
    end
end

function TruckCheck() 
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if DoesEntityExist(vehicle) then
        local model = GetEntityModel(vehicle)
        for i=1, #Config.Fires.truck.vehicles do 
            if Config.Fires.truck.vehicles[i] == model then
                EnableFireTarget(Config.Fires.truck.damage, function(index, dist)
                    return dist < Config.Fires.truck.range and IsDisabledControlPressed(1, 70)  
                end)
                CreateThread(function() 
                    while FireTargetEnabled do 
                        local ped = PlayerPedId()
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        local found = false
                        local driving = (DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == ped)
                        if driving then
                            local model = GetEntityModel(vehicle)
                            for i=1, #Config.Fires.truck.vehicles do 
                                if Config.Fires.truck.vehicles[i] == model then
                                    found = true
                                    break
                                end
                            end
                        end
                        if (not found or not driving) then
                            DisableFireTarget()
                            break
                        end
                        Wait(0)
                    end
                end)
                return true
            end
        end
    end
end

CreateThread(function()
    while true do
        local wait = 1500
        local ped = PlayerPedId()
        local pcoords = GetEntityCoords(ped)
        for k,v in pairs(Fires) do 
            local dist = #(pcoords-v.coords)
            if dist < Config.RenderDistance then 
                wait = 0
                EnsureFire(k)
                if dist < v.flame.fireRadius and Config.Fires.flammable and not IsEntityOnFire(ped) then 
                    StartEntityFire(ped)
                    SetTimeout(2500, function()
                        StopEntityFire(ped)
                    end)
                end
            else 
                RemoveFire(k)
            end
        end
        if not FireTargetEnabled then 
            if ExtinguisherCheck() then
            elseif TruckCheck() then
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent("pickle_firefighterjob:startFire", function(index, data)
    Fires[index] = data
end)

RegisterNetEvent("pickle_firefighterjob:removeFire", function(index, data) 
    Fires[index] = nil
    RemoveFire(index)
    if Config.Fires.blip.enabled then 
        local blip_index = data.scenario and "scenario_"..data.scenario or index
        if FireBlips[blip_index] then 
            RemoveBlip(FireBlips[blip_index])
        end
        FireBlips[blip_index] = nil
    end    
end)

RegisterNetEvent("pickle_firefighterjob:updateFire", function(index, data)
    Fires[index] = data
    if not FireInstances[index] then return end 
    local fire = Fires[index]
    for i=1, #FireInstances[index].particles do 
        local particle = FireInstances[index].particles[i]
        local cfg = fire[particle.type]
        local percent = fire.health / fire.maxHealth
        local scale = cfg.scale * percent
        local height = (particle.offset.z - fire.offset.z) * percent
        SetParticleFxLoopedScale(particle.handle, scale)
        SetParticleFxLoopedOffsets(particle.handle, fire.offset.x, fire.offset.y, fire.offset.z + height, fire.rotation.x, fire.rotation.y, fire.rotation.z)
    end
end)

RegisterNetEvent("pickle_firefighterjob:stopFires", function(list)
    for i=1, #list do 
        Fires[list[i].index] = nil
        if Config.Fires.blip.enabled then 
            local index = list[i].data.scenario and "scenario_"..list[i].data.scenario or list[i].index
            if FireBlips[index] then 
                RemoveBlip(FireBlips[index])
            end
            FireBlips[index] = nil
        end    
        RemoveFire(list[i].index)
    end
end)

RegisterNetEvent("pickle_firefighterjob:startEffect", function(net_id, dict, particleName, off, rot, scale)
    if not NetworkDoesNetworkIdExist(net_id) then return end
    local object = NetToObj(net_id)
    Effects[net_id] = PlayEffect(dict, particleName, object, off, rot, scale)
end)

RegisterNetEvent("pickle_firefighterjob:stopEffect", function(net_id)
    if not Effects[net_id] then return end
    StopParticleFxLooped(Effects[net_id], true)
    Effects[net_id] = nil
end)

RegisterNetEvent("pickle_firefighterjob:startFires", function(list)
    for i=1, #list do 
        Fires[list[i].index] = list[i].data
    end
end)

RegisterNetEvent("pickle_firefighterjob:fireEvent", function(eventType, data)
    if eventType == "startFire" then 
        if Config.Fires.blip.enabled then 
            if FireBlips[data.index] then 
                RemoveBlip(FireBlips[data.index])
            end
            local cfg = Config.Fires.blip
            FireBlips[data.index] = CreateBlip({
                label = cfg.label,
                coords = data.data.coords,
                id = cfg.id,
                color = cfg.color,
                scale = cfg.scale,
            })
        end
    elseif eventType == "stopFire" then
        if Config.Fires.blip.enabled then 
            if FireBlips[data.index] then 
                RemoveBlip(FireBlips[data.index])
            end
            FireBlips[data.index] = nil
        end    
    end
    Config.Alerts(eventType, data)
end)

RegisterNetEvent("pickle_firefighterjob:useWaterTank", function()
    if WaterCapacity and WaterCapacity >= Config.Fires.water.capacity then
        ShowNotification(_L("tank_already_full"))
    elseif WaterCapacity then 
        WaterCapacity = Config.Fires.water.capacity
        ShowNotification(_L("tank_refilled"))
        TriggerServerEvent("pickle_firefighterjob:removeItem", "watertank", 1)
    elseif not FireTargetEnabled then
        TriggerServerEvent("pickle_firefighterjob:removeItem", "watertank", 1)
        WaterTank()
    end
end)

RegisterNetEvent("pickle_firefighterjob:syncFires", function(data)
    Fires = data
end)

AddEventHandler("onResourceStop", function(name)
    if GetCurrentResourceName() ~= name then return end
    for k,v in pairs(Fires) do 
        RemoveFire(k)
    end
end)

exports("EnableFireTarget", EnableFireTarget)
exports("DisableFireTarget", DisableFireTarget)
exports("IsFireTargetActive", IsFireTargetActive)