local LastScenarioIndex = nil
local ScenarioIndex = nil
Fires = {}

function StartFire(coords, data, scenarioIndex)
    local index
    local data = data or {}
    repeat
        index = math.random(1, 999999999)
    until not Fires[index]
    local maxHealth = data.maxHealth or 100
    Fires[index] = {
        scenario = scenarioIndex,
        coords = coords, 
        offset = data.offset or vector3(0.0, 0.0, 0.0),
        rotation = data.rotation or vector3(0.0, 0.0, 0.0),
        flame = data.flame or Config.Default.flame,
        smoke = data.smoke or Config.Default.smoke,
        fighters = {},
        maxHealth = maxHealth,
        health = maxHealth
    }
    if not scenarioIndex then
        TriggerClientEvent("pickle_firefighterjob:startFire", -1, index, Fires[index])
        local players = GetFirefighters()
        for i=1, #players do 
            TriggerClientEvent("pickle_firefighterjob:fireEvent", players[i], "startFire", {index = index, data = Fires[index]})
        end
    end
    return index, Fires[index]
end

function StartFires(fires, scenarioIndex) 
    local list = {}
    for i=1, #fires do 
        local fire = StartFire(fires[i].coords, fires[i].data, scenarioIndex)
        list[#list + 1] = {index = fire, data = Fires[fire]} 
    end
    TriggerClientEvent("pickle_firefighterjob:startFires", -1, list)
    return list
end

function RemoveFire(index, rewards)
    local fire = Fires[index]
    Fires[index] = nil
    if rewards then
        for k,v in pairs(fire.fighters) do
            if GetPlayerName(k) then
                local scale = v / fire.maxHealth
                if scale > 1 then
                    scale = 1
                end
                local player_rewards = {}
                for i=1, #rewards do 
                    player_rewards[#player_rewards + 1] = { 
                        type = rewards[i].type, 
                        name = rewards[i].name, 
                        amount = math.ceil(rewards[i].amount * scale)
                    }
                end
                GiveRewards(k, player_rewards)
            end
        end
    end
    TriggerClientEvent("pickle_firefighterjob:removeFire", -1, index, fire)
end

function StartScenario(index)
    local scene = Config.Scenarios[index]
    if ScenarioIndex then
        StopScenario(ScenarioIndex)
    end
    if not scene then return end
    LastScenarioIndex = index
    ScenarioIndex = index
    local fires = scene.fires
    local list = StartFires(fires, index)
    local players = GetFirefighters()
    for i=1, #players do 
        TriggerClientEvent("pickle_firefighterjob:fireEvent", players[i], "startFire", {index = "scenario_" .. index, data = list[1].data})
    end
end

function StopScenario() 
    if not ScenarioIndex then return end
    local list = {}
    for k,v in pairs(Fires) do
        if v.scenario == ScenarioIndex then 
            list[#list + 1] = {index = k, data = v}
        end
        Fires[k] = nil
    end
    local players = GetFirefighters()
    for i=1, #players do 
        TriggerClientEvent("pickle_firefighterjob:fireEvent", players[i], "stopFire", {index = "scenario_" .. ScenarioIndex})
    end
    if #list > 0 then 
        TriggerClientEvent("pickle_firefighterjob:stopFires", -1, list)
    end
    ScenarioIndex = nil
end

function ScenarioThread()
    if not Config.Fires.scenarios.randomSpawn then return end
    if ScenarioIndex then
        local found = false
        for k,v in pairs(Fires) do
            if v.scenario == ScenarioIndex then 
                found = true 
                break
            end
        end
        if not found then
            StopScenario()
        end
    elseif Config.Fires.requiredFirefighters <= #GetFirefighters() then
        local index
        repeat
            index = math.random(1, #Config.Scenarios)
        until LastScenarioIndex ~= index or #Config.Scenarios == 1
        StartScenario(index)
    end
    SetTimeout(1000 * Config.Fires.scenarios.cooldown, function()
        ScenarioThread()
    end)
end

RegisterNetEvent("pickle_firefighterjob:attackFire", function(index, damage)
    local source = source
    if not Fires[index] then return end
    if not Fires[index].fighters[source] then 
        Fires[index].fighters[source] = damage
    else
        Fires[index].fighters[source] = Fires[index].fighters[source] + damage
    end
    Fires[index].health = Fires[index].health - damage
    if Fires[index].health < 0.1 then 
        RemoveFire(index, Config.Fires.rewards)
    else
        TriggerClientEvent("pickle_firefighterjob:updateFire", -1, index, Fires[index])
    end
end)

RegisterNetEvent("pickle_firefighterjob:startEffect", function(net_id, dict, particleName, off, rot, scale) 
    TriggerClientEvent("pickle_firefighterjob:startEffect", -1, net_id, dict, particleName, off, rot, scale)
end)

RegisterNetEvent("pickle_firefighterjob:stopEffect", function(net_id) 
    TriggerClientEvent("pickle_firefighterjob:stopEffect", -1, net_id)
end)

RegisterNetEvent("pickle_firefighterjob:removeItem", function(name, count)
    local source = source
    Inventory.RemoveItem(source, name, count)
end)

function IsExplosionAllowed(ev)
    for i=1, #Config.Explosions.explosionTypes do 
        if ev.explosionType == Config.Explosions.explosionTypes[i] then
            return true
        end
    end
end

AddEventHandler('explosionEvent', function(sender, ev)
    if Config.ExplosionEvent then 
        Config.ExplosionEvent(sender, ev)
    elseif IsExplosionAllowed(ev) then
        Config.Explosions.explosionEvent(sender, ev)
    end
end)

RegisterUsableItem("watertank", function(source)
    TriggerClientEvent("pickle_firefighterjob:useWaterTank", source)
end)

RegisterCommand("startfirescene", function(source, args, raw)
    if not args[1] then return end
    local index = tonumber(args[1]) or GetScenarioByName(args[1])
    if not Config.Scenarios[index] then return end
    if ScenarioIndex then return end
    if not CheckPermission(source, Config.AdminPermissions) then 
        ShowNotification(source, _L("no_permission"))
        return
    end
    StartScenario(index)
end)

RegisterCommand("stopfirescene", function(source, args, raw)
    if not CheckPermission(source, Config.AdminPermissions) then 
        ShowNotification(source, _L("no_permission"))
        return
    end
    StopScenario()
end)

RegisterCommand("stopfires", function(source, args, raw)
    if not CheckPermission(source, Config.AdminPermissions) then 
        ShowNotification(source, _L("no_permission"))
        return
    end
    local list = {}
    for k,v in pairs(Fires) do
        list[#list + 1] = {index = k, data = v}
        Fires[k] = nil
    end
    if #list > 0 then 
        TriggerClientEvent("pickle_firefighterjob:stopFires", -1, list)
    end
    ScenarioIndex = nil
end)

CreateThread(function()
    ScenarioThread()
end)

exports("StartFire", StartFire)
exports("RemoveFire", RemoveFire)
exports("StartScenario", StartScenario)
exports("StopScenario", StopScenario)