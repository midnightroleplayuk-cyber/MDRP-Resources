-- Police dogs. The handler's game creates and moves the dog; the server keeps track of whose dog is whose
-- and decides what a search finds and whether a detention counts.
VPO.Dogs = {}
local DG = VPO.Dogs
local Cfg = Config.Dogs
local L = VPO.L
local dogs = {}     -- [handler] = netId
local injured = {}  -- [identifier] = os.time() when it can deploy again

local function ped(src) local p = GetPlayerPed(src); return (p and p ~= 0) and p or nil end
local function entity(net)
    net = tonumber(net)
    local e = net and NetworkGetEntityFromNetworkId(net) or 0
    return (e and e ~= 0 and DoesEntityExist(e)) and e or nil
end
local function dist(a, b) if not a or not b then return math.huge end return #(GetEntityCoords(a) - GetEntityCoords(b)) end

local function onDogUnit(src)
    local s = VPO.Duty.Get(src)
    return s ~= nil and VPO.Util.Contains(Cfg.Units, s.unit)
end

function DG.Remove(src)
    local dog = entity(dogs[src])
    if dog then DeleteEntity(dog) end
    dogs[src] = nil
    GlobalState.vpo_dogs = (function() local t = {} for h, n in pairs(dogs) do t[tostring(n)] = h end return t end)()
end

local function publish()
    local t = {}
    for h, n in pairs(dogs) do t[tostring(n)] = h end
    GlobalState.vpo_dogs = t
end

VPO.Net.Callback('dog:canDeploy', { permission = 'dogs.handle', rate = 'dogs' }, function(src, o)
    if not onDogUnit(src) then return { error = L('dog_unit_only') } end
    if injured[o.identifier] and injured[o.identifier] > os.time() then return { error = L('dog_resting', injured[o.identifier] - os.time()) } end
    return { ok = true, model = Cfg.Model }
end)

--- The server creates the dog (works with sv_entityLockdown and anti-cheat entity protection, which
--- block or delay peds made by players). The handler's game then takes control of it.
VPO.Net.Callback('dog:spawn', { permission = 'dogs.handle', rate = 'dogs' }, function(src, o, d)
    if not onDogUnit(src) then return { error = L('dog_unit_only') } end
    if injured[o.identifier] and injured[o.identifier] > os.time() then return { error = L('dog_resting', injured[o.identifier] - os.time()) } end
    d = type(d) == 'table' and d or {}
    local p = ped(src)
    local x, y, z, h = tonumber(d.x), tonumber(d.y), tonumber(d.z), tonumber(d.h) or 0.0
    if not p or not x or #(GetEntityCoords(p) - vector3(x, y, z)) > 6.0 then return { error = L('dog_failed') } end
    if dogs[src] then DG.Remove(src) end
    local dog = CreatePed(28, GetHashKey(Cfg.Model), x, y, z, h, true, true)
    local deadline = GetGameTimer() + 4000
    while (not dog or dog == 0 or not DoesEntityExist(dog)) and GetGameTimer() < deadline do Wait(25) end
    if not dog or dog == 0 or not DoesEntityExist(dog) then
        VPO.Log.warn('Police dog for %s could not be created on the server (model %s). Check the model is streamed and entity limits.', GetPlayerName(src), Cfg.Model)
        return { error = L('dog_spawn_failed') }
    end
    SetEntityOrphanMode(dog, 2)
    local net = NetworkGetNetworkIdFromEntity(dog)
    dogs[src] = net
    publish()
    VPO.Audit.Log({ action = 'dogs.deploy', actor = src })
    return { ok = true, net = net }
end)

VPO.Net.Callback('dog:deployed', { permission = 'dogs.handle', rate = 'dogs' }, function(src, o, d)
    local dog = entity(type(d) == 'table' and d.net or nil)
    if not dog or GetEntityModel(dog) ~= GetHashKey(Cfg.Model) or dist(ped(src), dog) > 15.0 then return { error = L('dog_failed') } end
    if dogs[src] and dogs[src] ~= d.net then DG.Remove(src) end
    dogs[src] = tonumber(d.net)
    publish()
    VPO.Audit.Log({ action = 'dogs.deploy', actor = src })
    return { ok = true }
end)

VPO.Net.Callback('dog:recall', { permission = 'dogs.handle', rate = 'dogs' }, function(src)
    DG.Remove(src)
    return { ok = true }
end)

-- The dog has been hurt (reported by the handler's game, checked against its health)
VPO.Net.On('dog:injured', { permission = 'dogs.handle', rate = 'dogs', silent = true }, function(src, o)
    local dog = entity(dogs[src])
    if dog and GetEntityHealth(dog) > 120 then return end
    injured[o.identifier] = os.time() + Cfg.RedeployAfterInjury
    DG.Remove(src)
    VPO.Notify(src, L('dog_injured'), 'error', 10000)
end)

---------------------------------------------------------------------------
-- Searches: does the dog indicate?
---------------------------------------------------------------------------
-- What a find is, if it's something the dog is trained for: 'drugs', 'firearms' or 'cash'
local function itemKind(name)
    name = tostring(name or '')
    local D = Cfg.Detects or { drugs = true }
    if D.drugs and VPO.Util.Contains(Cfg.DrugItems, name) then return 'drugs' end
    if D.firearms then
        local up = name:upper()
        if (up:find('^WEAPON_') and not VPO.Util.Contains(Cfg.IgnoreWeapons or {}, up)) or name:lower():find('^ammo') then return 'firearms' end
    end
    if D.cash and VPO.Util.Contains(Cfg.CashItems or {}, name) then return 'cash' end
    return nil
end

local function wordsKind(label)
    label = tostring(label or ''):lower()
    local D = Cfg.Detects or { drugs = true }
    local function any(list) for _, w in ipairs(list or {}) do if label:find(w, 1, true) then return true end end return false end
    if D.drugs and any(Cfg.DrugWords) then return 'drugs' end
    if D.firearms and any(Cfg.FirearmWords) then return 'firearms' end
    if D.cash and any(Cfg.CashWords) then return 'cash' end
    return nil
end

local function addItems(found, items)
    for _, it in ipairs(items or {}) do local k = itemKind(it.name); if k then found[k] = true end end
end
local function addWords(found, list)
    for _, f in ipairs(list or {}) do local k = wordsKind(f.label); if k then found[k] = true end end
end

local function oxItems(id)
    local ok, items = pcall(function() return exports.ox_inventory:GetInventoryItems(id) end)
    if not ok or type(items) ~= 'table' then return {} end
    local out = {}
    for _, it in pairs(items) do out[#out + 1] = it end
    return out
end

--- Search a vehicle: NPC stop finds, or a player vehicle's boot and glovebox (ox_inventory). Returns { kind = true }, stop
local function searchVehicle(veh, net)
    local found = {}
    local stop = VPO.Roads.ForVehicle(net)
    if stop and stop.npc then
        if stop.npc.enc.drug and (Cfg.Detects or {}).drugs ~= false then found.drugs = true end
        addWords(found, (stop.npc.finds or {}).vehicle)
        return found, stop
    end
    if GetResourceState('ox_inventory') ~= 'started' then return found, stop end
    local plate = (GetVehicleNumberPlateText(veh) or ''):gsub('^%s+', ''):gsub('%s+$', '')
    addItems(found, oxItems('trunk' .. plate))
    addItems(found, oxItems('glove' .. plate))
    return found, stop
end

--- Search a person: an NPC at a scene or stop, or a player. Returns { kind = true }
local function searchPerson(target)
    local found = {}
    if target.player then addItems(found, VPO.Inventory.List(target.player)); return found end
    local p = target.encounter
    if p then
        if p.drug and (Cfg.Detects or {}).drugs ~= false then found.drugs = true end
        if p.weapon and (Cfg.Detects or {}).firearms and tostring(p.weapon):upper() ~= 'WEAPON_KNIFE' then found.firearms = true end
        addWords(found, p.finds)
        return found
    end
    local stop = target.stop
    if stop and stop.npc then
        if stop.npc.enc.drug and (Cfg.Detects or {}).drugs ~= false then found.drugs = true end
        addWords(found, (stop.npc.finds or {}).person)
    end
    return found
end

local KIND_LABEL = { drugs = 'drugs', firearms = 'firearms or ammunition', cash = 'cash' }
local function describe(found)
    local list = {}
    for _, k in ipairs({ 'drugs', 'firearms', 'cash' }) do if found[k] then list[#list + 1] = KIND_LABEL[k] end end
    return list
end

VPO.Net.Callback('dog:search', { permission = 'dogs.handle', rate = 'dogs' }, function(src, o, d)
    d = type(d) == 'table' and d or {}
    local dog = entity(dogs[src])
    if not dog then return { error = L('dog_not_out') } end
    if dist(ped(src), dog) > Cfg.HandlerRange then return { error = L('dog_too_far') } end
    local hit, what, note
    if d.kind == 'vehicle' then
        local veh = entity(d.net)
        if not veh or GetEntityType(veh) ~= 2 then return { error = L('restraint_no_vehicle') } end
        if dist(dog, veh) > Cfg.SearchRange + 2.5 then return { error = L('dog_get_closer') } end
        local stop, found
        found, stop = searchVehicle(veh, tonumber(d.net))
        hit = describe(found)
        what = (GetVehicleNumberPlateText(veh) or ''):gsub('%s+$', '')
        if stop then stop.checks.dog = { at = os.time(), indicated = #hit > 0, found = hit, by = VPO.Officers.Label(o) } end
    else
        local target = {}
        local tped
        if tonumber(d.player) then
            target.player = tonumber(d.player)
            if VPO.IsOnDuty(target.player) == true then return { error = L('dog_not_officers') } end
            tped = ped(target.player)
            what = VPO.Bridge.GetName(target.player)
        else
            local e = entity(d.net)
            tped = e
            local encId = (GlobalState.vpo_enc_peds or {})[tostring(d.net)]
            target.encounter = encId and VPO.Encounters.Get(encId) or nil
            local vehNet = (GlobalState.vpo_npc_peds or {})[tostring(d.net)]
            target.stop = vehNet and VPO.Roads.ForVehicle(vehNet) or nil
            what = 'person'
        end
        if not tped or dist(dog, tped) > Cfg.SearchRange then return { error = L('dog_get_closer') } end
        hit = describe(searchPerson(target))
        if target.encounter then
            local call = VPO.Callouts.Get(target.encounter.callId)
            if call then VPO.Callouts.Note(call, #hit > 0 and ('Police dog indicated on a person (%s)'):format(table.concat(hit, ', ')) or 'Police dog: no indication on a person') end
        end
    end
    VPO.Audit.Log({ action = 'dogs.search', actor = src, targetType = d.kind or 'person', targetId = what, new = { indicated = hit } })
    return { ok = true, indicated = #hit > 0, message = #hit > 0 and L('dog_indicates_on', table.concat(hit, ', ')) or L('dog_no_indication') }
end)

--- The dog is sent after someone. Players only if allowed; it counts as use of force.
VPO.Net.Callback('dog:send', { permission = 'dogs.handle', rate = 'dogs' }, function(src, o, d)
    d = type(d) == 'table' and d or {}
    local dog = entity(dogs[src])
    if not dog then return { error = L('dog_not_out') } end
    local target
    if tonumber(d.player) then
        if not Cfg.BitePlayers then return { error = L('dog_no_players') } end
        target = tonumber(d.player)
        if VPO.IsOnDuty(target) == true then return { error = L('dog_not_officers') } end
        if dist(ped(target), dog) > 80.0 then return { error = L('dog_too_far') } end
    else
        local e = entity(d.net)
        if not e or dist(e, dog) > 80.0 then return { error = L('dog_too_far') } end
    end
    VPO.Standards.Prompt(src, 'Police dog deployed', target and VPO.Bridge.GetName(target) or nil, nil)
    VPO.Audit.Log({ action = 'dogs.send', actor = src, targetType = target and 'player' or 'npc', targetId = target and VPO.Bridge.GetIdentifier(target) or d.net })
    return { ok = true }
end)

---------------------------------------------------------------------------
-- The lead and barking
---------------------------------------------------------------------------
VPO.Net.Callback('dog:lead', { permission = 'dogs.handle', rate = 'dogs' }, function(src, o, d)
    local dog = entity(dogs[src])
    if not dog then return { error = L('dog_not_out') } end
    local on = type(d) == 'table' and d.on == true
    if on and dist(ped(src), dog) > 4.0 then return { error = L('dog_get_closer_lead') } end
    -- Every player's game draws the lead from this
    Entity(dog).state:set('vpo_lead', on and src or false, true)
    return { ok = true, on = on }
end)

VPO.Net.Callback('dog:bark', { permission = 'dogs.handle', rate = 'dogs' }, function(src, o, d)
    d = type(d) == 'table' and d or {}
    local dog = entity(dogs[src])
    if not dog then return { error = L('dog_not_out') } end
    local B = Cfg.Bark
    local tped, label
    if tonumber(d.player) then
        tped = ped(tonumber(d.player)); label = VPO.Bridge.GetName(tonumber(d.player))
    else
        tped = entity(d.net); label = 'NPC'
    end
    if not tped or dist(tped, dog) > B.Range + 5.0 then return { error = L('dog_too_far') } end
    -- A barking police dog: suspects who are running or fighting often give up
    local gaveUp = false
    if not tonumber(d.player) then
        local encId = (GlobalState.vpo_enc_peds or {})[tostring(d.net)]
        local p = encId and VPO.Encounters.Get(encId)
        if p and (p.state == 'fleeing' or p.state == 'hostile' or (p.state == 'idle' and p.trigger == 'approach'))
            and dist(tped, dog) <= B.IntimidateRange + 4.0 and math.random(1, 100) <= B.SurrenderChance then
            VPO.Encounters.Surrender(p)
            gaveUp = true
            local call = VPO.Callouts.Get(p.callId)
            if call then VPO.Callouts.Note(call, 'Suspect gave up when challenged by a police dog') end
        end
    end
    VPO.Audit.Log({ action = 'dogs.bark', actor = src, targetType = tonumber(d.player) and 'player' or 'npc', targetId = label })
    return { ok = true, gaveUp = gaveUp }
end)

-- The dog barked: everyone near it hears the bark sound
local lastBark = {}
VPO.Net.On('dog:barked', { permission = 'dogs.handle', rate = 'dogs', silent = true }, function(src)
    local dog = entity(dogs[src])
    if not dog then return end
    local now = GetGameTimer()
    if lastBark[src] and now - lastBark[src] < 1200 then return end
    lastBark[src] = now
    local c = GetEntityCoords(dog)
    local range = Cfg.Bark.HearRange or 40.0
    for _, id in ipairs(GetPlayers()) do
        local p = ped(tonumber(id))
        if p and #(GetEntityCoords(p) - c) <= range then
            TriggerClientEvent('vinewood_police:client:dog:bark', tonumber(id), { x = c.x, y = c.y, z = c.z })
        end
    end
end)

local function cleanup(src) lastBark[src] = nil; if dogs[src] then DG.Remove(src) end end
AddEventHandler('playerDropped', function() cleanup(source) end)
VPO.Duty.OnSignOff(function(src) cleanup(src) end)
AddEventHandler('onResourceStop', function(res)
    if res ~= VPO.Resource then return end
    for src in pairs(dogs) do DG.Remove(src) end
end)

-- The custom dog lives in vinewood_policedog: say so on start if it's chosen but not running
AddEventHandler(VPO.Events.ready, function()
    if Cfg.Model == 'vw_policedog' and GetResourceState('vinewood_policedog') ~= 'started' then
        VPO.Log.warn('Config.Dogs.Model is vw_policedog but the vinewood_policedog resource isn\'t started. Add "ensure vinewood_policedog" before vinewood_police, or set Config.Dogs.Model = \'a_c_shepherd\'.')
    end
end)
