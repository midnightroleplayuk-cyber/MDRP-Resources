-- The handler's dog: deploy and recall (/dog), heel, sit, search vehicles and people, and send it after
-- someone. Target options appear on vehicles, people and the dog while it's out.
local Cfg = Config.Dogs
local L = VPO.L
local dog, injuredSent = nil, false

local function loadDict(d)
    RequestAnimDict(d)
    local deadline = GetGameTimer() + 3000
    while not HasAnimDictLoaded(d) and GetGameTimer() < deadline do Wait(10) end
    return HasAnimDictLoaded(d)
end

local function cb(name, data)
    local res = lib.callback.await('vinewood_police:cb:' .. name, false, data)
    if type(res) ~= 'table' then return { error = L('dog_failed') } end
    return res
end

local onLead, barkToken, barking = false, 0, false

local sendToken, staying = 0, false

-- Make sure this game is the one moving the dog before giving it an order
local function own()
    if not dog or not DoesEntityExist(dog) then return false end
    if NetworkHasControlOfEntity(dog) then return true end
    local deadline = GetGameTimer() + 1000
    NetworkRequestControlOfEntity(dog)
    while not NetworkHasControlOfEntity(dog) and GetGameTimer() < deadline do Wait(25); NetworkRequestControlOfEntity(dog) end
    return NetworkHasControlOfEntity(dog)
end

-- Stop whatever the dog is doing: barking, a sit, running somewhere
local function stopAll()
    barkToken = barkToken + 1
    sendToken = sendToken + 1
    StopAnimTask(dog, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 1.0)
    ClearPedTasksImmediately(dog)
end

--- Heel: come back to the handler's left side and walk with them
local function heel(tell)
    if not own() then return end
    stopAll()
    staying = false
    if onLead then
        TaskFollowToOffsetOfEntity(dog, PlayerPedId(), -0.45, -0.35, 0.0, 2.5, -1, 0.4, true)
    else
        TaskFollowToOffsetOfEntity(dog, PlayerPedId(), -0.6, -0.6, 0.0, 2.5, -1, 0.9, true)
    end
    SetPedKeepTask(dog, true)
    if tell then VPO.ClientNotify(L('dog_heel'), 'inform', 1500) end
end
local function sit()
    if not own() then return end
    stopAll()
    staying = true
    if loadDict('creatures@rottweiler@amb@world_dog_sitting@base') then
        TaskPlayAnim(dog, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 8.0, -8.0, -1, 1, 0.0, false, false, false)
    end
end

local function bark()
    if dog and loadDict('creatures@rottweiler@amb@world_dog_barking@idle_a') then
        TaskPlayAnim(dog, 'creatures@rottweiler@amb@world_dog_barking@idle_a', 'idle_a', 8.0, -8.0, 2500, 0, 0.0, false, false, false)
        if Cfg.Bark.Sound then TriggerServerEvent('vinewood_police:server:dog:barked')
        else pcall(PlayAnimalVocalization, dog, 3, 'BARK') end
    end
end

--- Lead on or off (the server shares it so every player draws the rope)
local function setLead(on)
    if not dog then return VPO.ClientNotify(L('dog_not_out'), 'error') end
    local res = cb('dog:lead', { on = on })
    if res.error then return VPO.ClientNotify(res.error, 'error') end
    onLead = res.on == true
    heel()
    VPO.ClientNotify(L(onLead and 'dog_lead_on' or 'dog_lead_off'), 'inform', 2500)
end
function VPO.DogLead() CreateThread(function() setLead(not onLead) end) end

--- Bark at someone: on the lead the dog holds its ground at your side; off it, it goes up to them and
--- holds a few metres off. Either way it doesn't bite. Heel stops it.
local function barkAt(target, data)
    CreateThread(function()
        local res = cb('dog:bark', data)
        if res.error then return VPO.ClientNotify(res.error, 'error') end
        VPO.ClientNotify(res.gaveUp and L('dog_gave_up') or L('dog_barking'), res.gaveUp and 'success' or 'inform', 3000)
        barkToken = barkToken + 1
        local token = barkToken
        local B = Cfg.Bark
        local untilT = GetGameTimer() + B.Seconds * 1000
        ClearPedTasks(dog)
        barking = true
        while dog and DoesEntityExist(dog) and token == barkToken and GetGameTimer() < untilT and DoesEntityExist(target) do
            local d = #(GetEntityCoords(dog) - GetEntityCoords(target))
            if not onLead and d > B.HoldDistance + 1.5 then
                TaskGoToEntity(dog, target, -1, B.HoldDistance, 3.0, 1073741824, 0)
                Wait(400)
            else
                TaskTurnPedToFaceEntity(dog, target, 800)
                Wait(500)
                bark()
                Wait(1300)
            end
        end
        barking = false
        if token == barkToken then heel() end
    end)
end

local function recall(silent)
    if dog and DoesEntityExist(dog) and NetworkHasControlOfEntity(dog) then DeleteEntity(dog) end
    dog = nil
    CreateThread(function() cb('dog:recall') end)
    if not silent then VPO.ClientNotify(L('dog_recalled'), 'inform') end
end

local function control(ent, ms)
    local deadline = GetGameTimer() + (ms or 3000)
    NetworkRequestControlOfEntity(ent)
    while not NetworkHasControlOfEntity(ent) and GetGameTimer() < deadline do Wait(50); NetworkRequestControlOfEntity(ent) end
    return NetworkHasControlOfEntity(ent)
end

local trace = {}
local function step(msg)
    trace[#trace + 1] = ('%6d ms  %s'):format(GetGameTimer() % 1000000, msg)
    if Cfg.Debug then print('[vinewood_police] dog: ' .. msg) end -- written straight away, so it survives a crash
end

local function deploy()
    trace = {}
    step('deploy started')
    local res = cb('dog:canDeploy')
    step(('canDeploy: %s'):format(res.error or 'ok, model ' .. tostring(res.model)))
    if res.error then return VPO.ClientNotify(res.error, 'error') end
    -- Load the model here first, so it's ready to show (big custom dogs can take a while the first time)
    local hash = GetHashKey(res.model)
    step(('model in game files: %s, valid: %s'):format(tostring(IsModelInCdimage(hash)), tostring(IsModelValid(hash))))
    if not IsModelInCdimage(hash) then return VPO.ClientNotify(L('dog_model_missing', res.model), 'error') end
    RequestModel(hash)
    local deadline = GetGameTimer() + 20000
    local told = false
    while not HasModelLoaded(hash) and GetGameTimer() < deadline do
        if not told and GetGameTimer() > deadline - 17000 then told = true; VPO.ClientNotify(L('dog_loading'), 'inform', 3000) end
        Wait(50)
    end
    step(('model loaded: %s'):format(tostring(HasModelLoaded(hash))))
    if not HasModelLoaded(hash) then return VPO.ClientNotify(L('dog_model_slow'), 'error') end
    local me = PlayerPedId()
    local c = GetOffsetFromEntityInWorldCoords(me, 0.0, -1.2, 0.0)
    local spawned = cb('dog:spawn', { x = c.x, y = c.y, z = c.z - 0.9, h = GetEntityHeading(me) })
    step(('server spawn: %s'):format(spawned.error or ('net id ' .. tostring(spawned.net))))
    if spawned.error then return VPO.ClientNotify(spawned.error, 'error') end
    -- Wait for the server's dog to reach this game, then take control of it
    deadline = GetGameTimer() + 6000
    while not NetworkDoesEntityExistWithNetworkId(spawned.net) and GetGameTimer() < deadline do Wait(50) end
    if not NetworkDoesEntityExistWithNetworkId(spawned.net) then
        CreateThread(function() cb('dog:recall') end)
        return VPO.ClientNotify(L('dog_not_arrived'), 'error')
    end
    dog = NetToPed(spawned.net)
    step(('dog reached this game: entity %s, control: %s'):format(tostring(dog), tostring(NetworkHasControlOfEntity(dog))))
    if not control(dog, 3000) then VPO.Log.debug('dog: no control yet, will keep asking') end
    SetNetworkIdCanMigrate(spawned.net, false) -- the handler's game keeps moving it
    SetModelAsNoLongerNeeded(hash)
    SetEntityAsMissionEntity(dog, true, true)
    SetBlockingOfNonTemporaryEvents(dog, true)
    SetPedFleeAttributes(dog, 0, false)
    SetPedRelationshipGroupHash(dog, GetHashKey('COP'))
    SetEntityMaxHealth(dog, 300); SetEntityHealth(dog, 300)
    -- The police dog's look: head and coat textures, and the harness
    -- Only ever set a part the model really has (an invalid variation can crash the game)
    local look = Cfg.Look or {}
    local function set(component, drawable, texture)
        if IsPedComponentVariationValid(dog, component, drawable, texture) then
            SetPedComponentVariation(dog, component, drawable, texture, 0)
            step(('look: part %d = %d/%d'):format(component, drawable, texture))
        else
            step(('look: part %d %d/%d not in this model, skipped'):format(component, drawable, texture))
        end
    end
    local function tex(component, want)
        if GetNumberOfPedDrawableVariations(dog, component) <= 0 then return end
        local n = GetNumberOfPedTextureVariations(dog, component, 0)
        if n <= 0 then return end
        set(component, 0, look.random and math.random(0, n - 1) or math.min(tonumber(want) or 0, n - 1))
    end
    if look.enabled ~= false then
        tex(0, look.head)
        tex(3, look.uppr)
        if look.accs ~= false and GetNumberOfPedDrawableVariations(dog, 8) > 0 then set(8, tonumber(look.accs) or 0, 0) end
    end
    injuredSent = false
    -- Make sure it's actually there to see: visible, solid, and standing on the floor next to you
    SetEntityVisible(dog, true, false)
    ResetEntityAlpha(dog)
    FreezeEntityPosition(dog, false)
    local mine = GetEntityCoords(me)
    local dc = GetEntityCoords(dog)
    if dc.z < mine.z - 2.0 or #(dc - mine) > 6.0 then
        step(('dog was at %.1f, %.1f, %.1f (you at %.1f, %.1f, %.1f): moved next to you'):format(dc.x, dc.y, dc.z, mine.x, mine.y, mine.z))
        local beside = GetOffsetFromEntityInWorldCoords(me, 0.0, -1.2, 0.0)
        RequestCollisionAtCoord(beside.x, beside.y, beside.z)
        SetEntityCoords(dog, beside.x, beside.y, beside.z - 0.9, false, false, false, false)
    end
    step(('dog visible: %s, alpha %d, drawable parts: head %d coat %d, health %d'):format(tostring(IsEntityVisible(dog)), GetEntityAlpha(dog),
        GetNumberOfPedDrawableVariations(dog, 0), GetNumberOfPedDrawableVariations(dog, 3), GetEntityHealth(dog)))
    heel()
    VPO.ClientNotify(L('dog_deployed'), 'success')
end

-- /dogcheck: what happened on the last deploy, and what the dog is doing now (F8 console)
RegisterCommand('dogcheck', function()
    local hash = GetHashKey(Cfg.Model)
    print(('[vinewood_police] dogcheck  model %s  in game files: %s  valid: %s  loaded: %s'):format(Cfg.Model,
        tostring(IsModelInCdimage(hash)), tostring(IsModelValid(hash)), tostring(HasModelLoaded(hash))))
    for _, line in ipairs(trace) do print('  ' .. line) end
    if dog and DoesEntityExist(dog) then
        local c, m = GetEntityCoords(dog), GetEntityCoords(PlayerPedId())
        print(('  dog now: %.1f m from you, height difference %.1f m, visible %s, alpha %d, control %s, on lead %s'):format(
            #(c - m), c.z - m.z, tostring(IsEntityVisible(dog)), GetEntityAlpha(dog), tostring(NetworkHasControlOfEntity(dog)), tostring(onLead)))
    else
        print('  no dog out')
    end
    VPO.ClientNotify(L('dog_check_printed'), 'inform')
end, false)

-- Keep control of your dog (if it ever moves to another player's game, take it back)
CreateThread(function()
    while true do
        Wait(1000)
        if dog and DoesEntityExist(dog) and not NetworkHasControlOfEntity(dog) then
            NetworkRequestControlOfEntity(dog)
            Wait(300)
            if NetworkHasControlOfEntity(dog) and not staying then heel() end
        end
    end
end)

RegisterCommand(Cfg.Command, function()
    if not LocalPlayer.state[VPO.StateDefs.duty.bag] then return VPO.ClientNotify(L('perm_off_duty'), 'error') end
    CreateThread(function() if dog then recall() else deploy() end end)
end, false)

-- Into a vehicle: the dog goes in the cage (recalled). Hurt: reported. Signed off: recalled.
CreateThread(function()
    while true do
        Wait(1000)
        if dog then
            if not DoesEntityExist(dog) then dog = nil
            elseif IsPedInAnyVehicle(PlayerPedId(), false) then recall(true); VPO.ClientNotify(L('dog_in_van'), 'inform')
            elseif (IsEntityDead(dog) or GetEntityHealth(dog) < 120) and not injuredSent then
                injuredSent = true
                TriggerServerEvent('vinewood_police:server:dog:injured')
                Wait(3000)
                if dog and DoesEntityExist(dog) then DeleteEntity(dog) end
                dog = nil
            elseif not LocalPlayer.state[VPO.StateDefs.duty.bag] then recall(true) end
        end
    end
end)

---------------------------------------------------------------------------
-- Target options
---------------------------------------------------------------------------
local function dogOut() return dog ~= nil and DoesEntityExist(dog) end

local function searchAt(entity, data)
    CreateThread(function()
        local pos = GetEntityCoords(entity)
        ClearPedTasks(dog)
        TaskGoToCoordAnyMeans(dog, pos.x, pos.y, pos.z, 2.0, 0, false, 786603, 0.0)
        local deadline = GetGameTimer() + 8000
        while #(GetEntityCoords(dog) - pos) > 2.5 and GetGameTimer() < deadline do Wait(200) end
        Wait(2500) -- sniffing
        local res = cb('dog:search', data)
        if res.error then VPO.ClientNotify(res.error, 'error'); return heel() end
        if res.indicated then sit(); VPO.ClientNotify(res.message, 'success'); Wait(4000)
        else VPO.ClientNotify(res.message, 'inform') end
        heel()
    end)
end

local function sendAfter(entity, data)
    CreateThread(function()
        if onLead then setLead(false) end -- slipping the lead to send the dog
        local res = cb('dog:send', data)
        if res.error then return VPO.ClientNotify(res.error, 'error') end
        bark()
        ClearPedTasks(dog)
        SetBlockingOfNonTemporaryEvents(dog, false)
        TaskCombatPed(dog, entity, 0, 16)
        -- Called off once the person is down or after 20 seconds
        local deadline = GetGameTimer() + 20000
        while dog and GetGameTimer() < deadline do
            Wait(250)
            if not DoesEntityExist(entity) or IsPedRagdoll(entity) or IsEntityDead(entity) or IsPedBeingStunned(entity, 0) then Wait(1500); break end
        end
        if dog then SetBlockingOfNonTemporaryEvents(dog, true); heel() end
    end)
end

local function sidOf(e)
    if not IsPedAPlayer(e) then return nil end
    local pid = NetworkGetPlayerIndexFromPed(e)
    return pid ~= -1 and GetPlayerServerId(pid) or nil
end

local vehicleOptions = {
    { name = 'vpo_dog_vehicle', label = 'Dog: search vehicle', icon = 'fas fa-dog', distance = 4.0,
      canInteract = function() return dogOut() end,
      onSelect = function(veh) searchAt(veh, { kind = 'vehicle', net = VehToNet(veh) }) end },
}

local function personData(e)
    local sid = sidOf(e)
    return sid and { kind = 'person', player = sid } or { kind = 'person', net = NetworkGetEntityIsNetworked(e) and PedToNet(e) or nil }
end

local personOptions = {
    { name = 'vpo_dog_person', label = 'Dog: search person', icon = 'fas fa-dog', distance = 4.0,
      canInteract = function(e) return dogOut() and e ~= dog end,
      onSelect = function(e) searchAt(e, personData(e)) end },
    { name = 'vpo_dog_bark', label = 'Dog: bark at them', icon = 'fas fa-volume-high', distance = 25.0,
      canInteract = function(e) return dogOut() and e ~= dog end,
      onSelect = function(e) barkAt(e, personData(e)) end },
    { name = 'vpo_dog_send', label = 'Dog: detain them', icon = 'fas fa-person-running', distance = 25.0,
      canInteract = function(e) return dogOut() and e ~= dog and (sidOf(e) == nil or Cfg.BitePlayers) end,
      onSelect = function(e) sendAfter(e, personData(e)) end },
}

local dogOptions = {
    { name = 'vpo_dog_heel', label = 'Heel', icon = 'fas fa-dog', distance = 3.0,
      canInteract = function(e) return e == dog end, onSelect = function() CreateThread(function() heel(true) end) end },
    { name = 'vpo_dog_spot', label = 'Send to a spot', icon = 'fas fa-location-crosshairs', distance = 3.0,
      canInteract = function(e) return e == dog end, onSelect = function() CreateThread(function() VPO.DogSendAim() end) end },
    { name = 'vpo_dog_lead', label = 'Lead on / off', icon = 'fas fa-link', distance = 3.0,
      canInteract = function(e) return e == dog end, onSelect = function() VPO.DogLead() end },
    { name = 'vpo_dog_sit', label = 'Sit / stay', icon = 'fas fa-hand', distance = 3.0,
      canInteract = function(e) return e == dog end, onSelect = function() CreateThread(sit) end },
    { name = 'vpo_dog_recall', label = 'Back in the van', icon = 'fas fa-van-shuttle', distance = 3.0,
      canInteract = function(e) return e == dog end, onSelect = function() CreateThread(function() recall() end) end },
}

CreateThread(function()
    Wait(1700)
    VPO.Target.AddGlobalVehicle(vehicleOptions)
    VPO.Target.AddGlobalPlayer(personOptions)
    VPO.Target.AddGlobalPed(personOptions)
    VPO.Target.AddGlobalPed(dogOptions)
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= VPO.Resource then return end
    if dog and DoesEntityExist(dog) then DeleteEntity(dog) end
    VPO.Target.RemoveGlobalVehicle(vehicleOptions)
    VPO.Target.RemoveGlobalPlayer(personOptions)
    VPO.Target.RemoveGlobalPed(personOptions)
    VPO.Target.RemoveGlobalPed(dogOptions)
end)

---------------------------------------------------------------------------
-- On the lead: keep the dog within the lead's length (the rope itself can't hold a ped back)
---------------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(250)
        if dog and DoesEntityExist(dog) then
            local d = #(GetEntityCoords(dog) - GetEntityCoords(PlayerPedId()))
            if onLead and d > Cfg.Lead.Length + 4.0 then
                local c = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.45, -0.35, 0.0)
                SetEntityCoords(dog, c.x, c.y, c.z - 1.0, false, false, false, false)
                heel()
            elseif onLead and not barking and d > Cfg.Lead.Length + 0.6 then
                TaskGoToEntity(dog, PlayerPedId(), -1, 0.6, 3.0, 1073741824, 0)
            end
        else
            onLead = false
        end
    end
end)

---------------------------------------------------------------------------
-- Drawing every dog lead near you (a real rope from the handler's hand to the collar)
---------------------------------------------------------------------------
local ropes = {} -- [dogNet] = rope

local function dropRope(net)
    if ropes[net] then DeleteRope(ropes[net]) end
    ropes[net] = nil
end

-- Which dogs near you are on a lead, and whose hand holds it: { { dog, handler } }
local function leashedNear(range)
    local out = {}
    local me = GetEntityCoords(PlayerPedId())
    for netStr in pairs(GlobalState.vpo_dogs or {}) do
        local net = tonumber(netStr)
        local d = net and NetworkDoesEntityExistWithNetworkId(net) and NetworkGetEntityFromNetworkId(net) or 0
        local lead = d ~= 0 and Entity(d).state.vpo_lead
        local pid = lead and GetPlayerFromServerId(lead) or -1
        local hp = pid ~= -1 and GetPlayerPed(pid) or 0
        if d ~= 0 and hp ~= 0 and #(me - GetEntityCoords(d)) < range then out[#out + 1] = { dog = d, handler = hp, net = net } end
    end
    return out
end

-- Drawn lead: a strap from the handler's hand to the collar, sagging when slack, facing the camera
local function drawLead(hp, d, LC)
    local hand = GetPedBoneCoords(hp, 57005, 0.08, 0.0, -0.02)
    local nb = GetEntityBoneIndexByName(d, LC.CollarBone)
    local neck = nb ~= -1 and GetWorldPositionOfEntityBone(d, nb) or (GetEntityCoords(d) + vector3(0.0, 0.0, 0.35))
    local span = neck - hand
    local len = #span
    if len < 0.05 or len > 12.0 then return end
    local sag = math.max(0.0, LC.Length - len) * 0.45 + 0.02
    local cam = GetFinalRenderedCamCoord()
    local r, g, b = LC.Colour[1], LC.Colour[2], LC.Colour[3]
    local half = (LC.Thickness or 0.018) / 2
    local N = 10
    local prev
    for i = 0, N do
        local t = i / N
        local p = hand + span * t - vector3(0.0, 0.0, sag * 4.0 * t * (1.0 - t))
        if prev then
            local seg = p - prev
            local toCam = cam - p
            -- width across the strap, facing the camera
            local w = vector3(seg.y * toCam.z - seg.z * toCam.y, seg.z * toCam.x - seg.x * toCam.z, seg.x * toCam.y - seg.y * toCam.x)
            local wl = #w
            if wl > 0.0001 then
                w = w / wl * half
                local a1, a2, b1, b2 = prev + w, prev - w, p + w, p - w
                DrawPoly(a1.x, a1.y, a1.z, b1.x, b1.y, b1.z, b2.x, b2.y, b2.z, r, g, b, 255)
                DrawPoly(a1.x, a1.y, a1.z, b2.x, b2.y, b2.z, a2.x, a2.y, a2.z, r, g, b, 255)
                DrawPoly(b1.x, b1.y, b1.z, a1.x, a1.y, a1.z, a2.x, a2.y, a2.z, r, g, b, 255)
                DrawPoly(b1.x, b1.y, b1.z, a2.x, a2.y, a2.z, b2.x, b2.y, b2.z, r, g, b, 255)
            end
        end
        prev = p
    end
end

if (Cfg.Lead.Style or 'drawn') == 'drawn' then
    CreateThread(function()
        while true do
            local list = leashedNear(60.0)
            if #list == 0 then
                Wait(500)
            else
                local untilT = GetGameTimer() + 500
                while GetGameTimer() < untilT do
                    for _, l in ipairs(list) do
                        if DoesEntityExist(l.dog) and DoesEntityExist(l.handler) then drawLead(l.handler, l.dog, Cfg.Lead) end
                    end
                    Wait(0)
                end
            end
        end
    end)
end

CreateThread(function()
    local LC = Cfg.Lead
    if (LC.Style or 'drawn') ~= 'rope' then return end
    while true do
        Wait(500)
        local me = GetEntityCoords(PlayerPedId())
        local seen = {}
        for netStr, handlerSrc in pairs(GlobalState.vpo_dogs or {}) do
            local net = tonumber(netStr)
            local d = net and NetworkDoesEntityExistWithNetworkId(net) and NetworkGetEntityFromNetworkId(net) or 0
            local lead = d ~= 0 and Entity(d).state.vpo_lead
            local pid = lead and GetPlayerFromServerId(lead) or -1
            local hp = pid ~= -1 and GetPlayerPed(pid) or 0
            if d ~= 0 and hp ~= 0 and #(me - GetEntityCoords(d)) < 60.0 then
                seen[net] = true
                if not ropes[net] or not DoesRopeExist(ropes[net]) then
                    RopeLoadTextures()
                    local deadline = GetGameTimer() + 2000
                    while not RopeAreTexturesLoaded() and GetGameTimer() < deadline do Wait(0) end
                    local hand = GetPedBoneCoords(hp, GetPedBoneIndex(hp, 57005), 0.0, 0.0, 0.0)
                    local nb = GetEntityBoneIndexByName(d, LC.CollarBone)
                    local neck = nb ~= -1 and GetWorldPositionOfEntityBone(d, nb) or (GetEntityCoords(d) + vector3(0.0, 0.0, 0.35))
                    local rope = AddRope(hand.x, hand.y, hand.z, 0.0, 0.0, 0.0, LC.Length, LC.RopeType, LC.Length, 0.3, 0.5, false, false, false, 1.0, false, 0)
                    AttachEntitiesToRope(rope, hp, d, hand.x, hand.y, hand.z, neck.x, neck.y, neck.z, LC.Length, false, false, LC.HandBone, LC.CollarBone)
                    ropes[net] = rope
                end
            end
        end
        for net in pairs(ropes) do if not seen[net] then dropRope(net) end end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= VPO.Resource then return end
    for net in pairs(ropes) do dropRope(net) end
end)

-- Any police dog barking near you (the server sends where it is)
RegisterNetEvent('vinewood_police:client:dog:bark', function(c)
    if type(c) ~= 'table' or not Cfg.Bark.Sound then return end
    local d = #(GetEntityCoords(PlayerPedId()) - vector3(c.x, c.y, c.z))
    local range = Cfg.Bark.HearRange or 40.0
    if d > range then return end
    local vol = (Cfg.Bark.Volume or 0.8) * (1.0 - d / range) ^ 1.5
    SendNUIMessage({ type = 'sound', name = Cfg.Bark.Sound, volume = vol })
end)

---------------------------------------------------------------------------
-- /dogtest: your dog model and the game's shepherd side by side, in your game only (not networked),
-- for 20 seconds. Tells a model problem apart from a spawning problem.
---------------------------------------------------------------------------
RegisterCommand('dogtest', function()
    CreateThread(function()
        local me = PlayerPedId()
        local made = {}
        local function one(model, side)
            local hash = GetHashKey(model)
            local line = ('[vinewood_police] dogtest %-14s in files %s  '):format(model, tostring(IsModelInCdimage(hash)))
            if not IsModelInCdimage(hash) then return print(line .. 'not found') end
            RequestModel(hash)
            local deadline = GetGameTimer() + 10000
            while not HasModelLoaded(hash) and GetGameTimer() < deadline do Wait(50) end
            if not HasModelLoaded(hash) then return print(line .. 'did not load') end
            local c = GetOffsetFromEntityInWorldCoords(me, side, 2.5, 0.0)
            local p = CreatePed(28, hash, c.x, c.y, c.z - 0.9, GetEntityHeading(me) + 180.0, false, false)
            SetModelAsNoLongerNeeded(hash)
            FreezeEntityPosition(p, true)
            SetBlockingOfNonTemporaryEvents(p, true)
            made[#made + 1] = p
            Wait(500)
            local mn, mx = GetModelDimensions(hash)
            print(line .. ('size %.2f x %.2f x %.2f m  visible %s  on screen %s  head parts %d (textures %d)  coat parts %d (textures %d)'):format(
                mx.x - mn.x, mx.y - mn.y, mx.z - mn.z, tostring(IsEntityVisible(p)), tostring(IsEntityOnScreen(p)),
                GetNumberOfPedDrawableVariations(p, 0), GetNumberOfPedTextureVariations(p, 0, 0),
                GetNumberOfPedDrawableVariations(p, 3), GetNumberOfPedTextureVariations(p, 3, 0)))
        end
        one(Cfg.Model, -1.0)
        if Cfg.Model ~= 'a_c_shepherd' then one('a_c_shepherd', 1.0) end
        VPO.ClientNotify(L('dog_test_shown'), 'inform', 6000)
        Wait(20000)
        for _, p in ipairs(made) do if DoesEntityExist(p) then DeleteEntity(p) end end
    end)
end, false)

---------------------------------------------------------------------------
-- Sending the dog somewhere: a spot you aim at (the floor included), or a car or object you target.
-- It runs there and waits, sitting, until you call it to heel.
---------------------------------------------------------------------------
local function sendTo(pos)
    if not own() then return VPO.ClientNotify(L('dog_not_out'), 'error') end
    if onLead then setLead(false) end -- slipping the lead to send it
    stopAll()
    staying = true
    local token = sendToken
    SetBlockingOfNonTemporaryEvents(dog, true)
    TaskGoToCoordAnyMeans(dog, pos.x, pos.y, pos.z, 3.0, 0, false, 786603, 0.0)
    VPO.ClientNotify(L('dog_sent'), 'inform', 3000)
    CreateThread(function()
        local deadline = GetGameTimer() + 25000
        while dog and DoesEntityExist(dog) and token == sendToken and GetGameTimer() < deadline do
            if #(GetEntityCoords(dog) - pos) < 1.6 then
                ClearPedTasks(dog)
                if loadDict('creatures@rottweiler@amb@world_dog_sitting@base') then
                    TaskPlayAnim(dog, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 8.0, -8.0, -1, 1, 0.0, false, false, false)
                end
                VPO.ClientNotify(L('dog_arrived'), 'success', 2500)
                return
            end
            Wait(250)
        end
    end)
end

local function aimSpot()
    local cam, rot = GetGameplayCamCoord(), GetGameplayCamRot(2)
    local rx, rz = math.rad(rot.x), math.rad(rot.z)
    local dir = vector3(-math.sin(rz) * math.abs(math.cos(rx)), math.cos(rz) * math.abs(math.cos(rx)), math.sin(rx))
    local to = cam + dir * 80.0
    local ray = StartExpensiveSynchronousShapeTestLosProbe(cam.x, cam.y, cam.z, to.x, to.y, to.z, 1 | 16, PlayerPedId(), 7)
    local _, hit, pos = GetShapeTestResult(ray)
    return hit == 1 and pos or nil
end

function VPO.DogSendAim()
    if not dog or not DoesEntityExist(dog) then return VPO.ClientNotify(L('dog_not_out'), 'error') end
    while true do
        Wait(0)
        for _, c in ipairs({ 24, 25, 38, 140, 141, 142, 177, 200 }) do DisableControlAction(0, c, true) end
        local p = aimSpot()
        local ok = p and #(p - GetEntityCoords(PlayerPedId())) <= 80.0
        if p then DrawMarker(25, p.x, p.y, p.z + 0.03, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, ok and 47 or 217, ok and 111 or 83, ok and 224 or 79, 200, false, false, 2, false, nil, nil, false) end
        BeginTextCommandDisplayHelp('STRING')
        AddTextComponentSubstringPlayerName(L('dog_send_help', p and ('%d m away'):format(math.floor(#(p - GetEntityCoords(PlayerPedId())))) or 'aim at the ground or an object'))
        EndTextCommandDisplayHelp(0, false, false, -1)
        if IsDisabledControlJustReleased(0, 38) and ok then return sendTo(p) end
        if IsDisabledControlJustReleased(0, 177) or IsDisabledControlJustReleased(0, 200) then return end
    end
end

-- Target a car or an object: "Dog: go here"
local goHere = {
    { name = 'vpo_dog_gohere', label = 'Dog: go here', icon = 'fas fa-location-dot', distance = 30.0,
      canInteract = function(e) return dog ~= nil and DoesEntityExist(dog) and e ~= dog end,
      onSelect = function(e) CreateThread(function() sendTo(GetEntityCoords(e)) end) end },
}
CreateThread(function()
    Wait(1800)
    VPO.Target.AddGlobalVehicle(goHere)
    if VPO.Target.AddGlobalObject then VPO.Target.AddGlobalObject(goHere) end
end)
AddEventHandler('onResourceStop', function(res)
    if res ~= VPO.Resource then return end
    VPO.Target.RemoveGlobalVehicle(goHere)
    if VPO.Target.RemoveGlobalObject then VPO.Target.RemoveGlobalObject(goHere) end
end)

function VPO.DogHeel() CreateThread(function() heel(true) end) end
